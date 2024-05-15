## Stan model, modified from StanCon 2018: Causal inference with the g-formula in Stan by Leah Comment
## file:///Users/Chris/Downloads/gformula-in-Stan.pdf
load("testSim.RData")

# Z = gammaU*U
# Y1 = betaZ*Z + betaZ*U 
# Y2 = alphaZ*Z + X1*alphaX1 + Y1*alphaY1 + U*alphaU

test = "
data {
  // number of rows in the data
  int<lower=0> N;
  // number of columns in matrix of exogenous variables, including intercept
  int<lower=0> P;
  // matrix  Z, including intercept
  matrix[N, P] Z;
  // observed treatment, X1
  vector[N] X1;
  // observed Lag, Y1
  vector[N] Y1;
  // outcome
  vector[N] Y2;
  // mean of regression priors, from glm
  vector[P + 3] alpha_m;
  vector[P + 1] beta_m;
  vector[P]     gamma_m;
  // variance-covariance of regression priors
  cov_matrix[P + 3] alpha_v;
  cov_matrix[P + 1] beta_v;
  cov_matrix[P]     gamma_v;
}
transformed data {
  // bootstrapping. This selects each row with equal probability, adjust for weights
  vector[N] boot_probs = rep_vector(1.0/N, N);
}
parameters {
      // regression coefficients (confounder model)
        vector[P]     gamma;
      // regression coefficients (Y2 model)
        vector[P + 3] alpha;
      // regression coefficients (Y1 model)
        vector[P + 1] beta;
        real<lower=0> sigmaY1;
        real<lower=0> sigmaY2;

}
transformed parameters {
//  Y1 coefficient parameters
      vector[P] betaZ  = head(beta, P);
      real betaU       = beta[P + 1];
//      real betaX1      = beta[P + 2];
// Y2 coefficient parameters
      vector[P] alphaZ   = head(alpha, P);
      real alphaU        = alpha[P + 1];
      real alphaX1       = alpha[P + 2];
      real alphaY1       = alpha[P + 3];
}
model {
// linear predictors
// U regression
        vector[N] eta_u;
// Y1 regression, if U = 0
        vector[N] etay1_0;
// Y2 regression, if U = 0
        vector[N] etay2_0;
// log-likelihood contributions for U = 0 and U = 1 cases
        real ll_0;
        real ll_1;

// calculate linear predictors for U = 0 
        eta_u   = Z * gamma;
        etay1_0 = Z * betaZ;
        etay2_0 = Z * alphaZ + X1 * alphaX1 + Y1 * alphaY1;
// informative priors, check indexing
        alpha ~ multi_normal(alpha_m, alpha_v);
        beta ~  multi_normal(beta_m,  beta_v);
        gamma ~ multi_normal(gamma_m, gamma_v);
        sigmaY1 ~ cauchy(0, 5);
        sigmaY2 ~ cauchy(0, 5);

// likelihood
for (n in 1:N) {
// contribution if U = 0, last term is 1 - U. By adding *weights* at the end, can weight things
    ll_0 = normal_lpdf(Y1[n] | etay1_0[n], sigmaY1) + 
           normal_lpdf(Y2[n] | etay2_0[n], sigmaY2) + 
           log1m_inv_logit(eta_u[n]);
    ll_1 = normal_lpdf(Y1[n] | etay1_0[n] + betaU, sigmaY1) + 
           normal_lpdf(Y2[n] | etay2_0[n] + alphaU, sigmaY2) + 
           log1m_inv_logit(eta_u[n]);
// contribution is summation over U possibilities, add weight here..
    target += log_sum_exp(ll_0, ll_1);
}
}
generated quantities {
// row index to be sampled for bootstrap
    int row_i;
// calculate NDE in the bootstrapped sample
    real NDE = 0;
    real NIE = 0;
    vector[N] U;
    vector[N] Y1_x0;
    vector[N] Y2_y1x1;
    vector[N] Y2_y1x0;
    vector[N]  Y2_y0x0;
    real max_x1;
    real min_x1;
    real max_y1;
    real min_y1;
    max_x1 =  max(X1);
    min_x1 =  min(X1);
    max_y1 =  max(Y1);
    min_y1 =  min(Y1);
for (n in 1:N) {
// sample baseline covariates
      row_i = 1;
//categorical_rng(boot_probs);
// sample U, from instruments
      U[n] = bernoulli_logit_rng(Z[row_i] * gamma);
// sample Y1 where X1 = 0, they're currently independent, but this would normally correspond to a 
// mediator. By sampling from X1 = 0, we're then generating a counterfactual Y1,
// where the mediator is set to 0.
      Y1_x0[n] = normal_rng(Z[row_i] * betaZ + U[n] * betaU + min_x1*alphaX1, sigmaY1);
// sample Y2_(x1=0, y1=y1) and Y2_(x1=1,y1=y1). We then take these difference.
// This is the Natural direct effect: Assume counterfactual Y1 when X1 =0; Then calculate the counterfactual Y2
// where X1 = 0 and Y1 = Y1_a0[n]. Then calculate the counterfactual Y2 where X1 = 1 and Y1 = Y1_a0[n].
// this is intepreted as the effect of X1 on Y2, when Y1 is set to Y1_a0[n].
      Y2_y1x0[n] =  normal_rng(Z[row_i] * alphaZ + Y1_x0[n] * alphaY1 + U[n] * alphaU + alphaX1*min_x1, sigmaY2);
      Y2_y1x1[n] =  normal_rng(Z[row_i] * alphaZ + Y1_x0[n] * alphaY1 + alphaX1*max_x1 + U[n] * alphaU, sigmaY2);
// add contribution of this observation to the bootstrapped NDE
    NDE = NDE + (Y2_y1x1[n] - Y2_y1x0[n])/N;
// The natural indirect efffect is the difference between the observed Y2 and the counterfactual Y2
// where X1 = 0 and Y1 = Y1_a0[n]. This is the effect of X1 on Y2, when Y1 is set to Y1_a0[n].
// This simply means that 1) we fix the treatment to 0 and 2) we fix the mediator to Y1_x0[n],
// The value of the mediator is set to the value of the mediator under the observed treatment.
      Y1_x1[n] = normal_rng(Z[row_i] * betaZ + U[n] * betaU + max_x1*alphaX1, sigmaY1);

      Y2_y0x0[n] =  normal_rng(Z[row_i] * alphaZ + min_y1 * alphaY1 + U[n] * alphaU + alphaX1*min_x1, sigmaY2);
      Y2_y1x0[n] =  normal_rng(Z[row_i] * alphaZ + max_y1 * alphaY1 + U[n] * alphaU + alphaX1*min_x1, sigmaY2);
    NIE = NIE + (Y2_y1x0[n] - Y2_y0x0[n])/N;

}
}
"
fit = stan(model_code  = test, data = dat)
# Retrieve only alphaU
mean(extract(fit, pars = "NDE")$NDE)


