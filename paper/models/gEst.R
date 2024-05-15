# Function to simulate data for mediation
simulate_mediation <- function(n) {
  Z <-  rbinom(n = n, size = 1, prob = 0.3)
  U <-  rbinom(n = n, size = 1, prob = pnorm(-1 + 0.3*Z))
  X1 <- 1 + 0.8*Z + 0.6*U + rnorm(n, 0, 1)
  Y1 <- 1 + 0.8*Z + 0.9*U + rnorm(n)
  Y2 <- 1 + 0.8*Z + 0.9*U + 0.3*X1 + 0.5*Y1 + rnorm(n)
  return(data.frame(Z, U, X1, Y1, Y2))
}
df <- simulate_mediation(n = 1000)


# Package data for Stan
# use the MLE estimates as informative priors

fitU  <-   glm(U ~ Z, data = df)  
fitY1 <-   glm(Y1 ~ Z + U, data = df)  
fitY2 <-   glm(Y2 ~ Z + X1 + U + Y1, data = df)

# Prior means for coefficients
gamma_m <-  unname(coef(fitU))
beta_m  <-  unname(coef(fitY1))
alpha_m  <-  unname(coef(fitY2))          
gamma_v <-  unname(vcov(fitU))
beta_v  <-  unname(vcov(fitY1))
alpha_v  <-  unname(vcov(fitY2))     

# Stan Data List
dat <- list(N = nrow(df),
            P = 2,
            Z = cbind(1, df$Z),
            X1 =  df$X1,
            Y1 =  df$Y1,
            Y2 =  df$Y2,
            gamma_m = gamma_m,
            beta_m  = beta_m,
            alpha_m  = alpha_m,
            gamma_v = gamma_v,
            beta_v  = beta_v,
            alpha_v  = alpha_v)

save(dat, file = "testSim.Rdata")


generated quantities {
  int row_i;
  real NDE = 0;
  vector[N] U;
  vector[N] Y1_a0;
  vector[N] Y_a1Ma0;
  vector[N] Y_a0Ma0;
  for (n in 1:N) {
    // sample baseline covariates
    row_i = 1;
    //categorical_rng(boot_probs);
    // sample U
    U[n] = bernoulli_logit_rng(X[row_i] * gamma);
    // sample M_a where X1=0
    Y1_X1[n] = bernoulli_logit_rng(Z[row_i] * betaZ + U[n] * betaU);
    
    // sample Y_(a=0, M=M_0) and Y_(a=1, M=M_0)
    Y_a0Ma0[n] = bernoulli_logit_rng(X[row_i] * alphaZ + M_a0[n] * alphaM +
                                       U[n] * alphaU);
    Y_a1Ma0[n] = bernoulli_logit_rng(X[row_i] * alphaZ + M_a0[n] * alphaM +
                                       alphaA + U[n] * alphaU);
    // add contribution of this observation to the bootstrapped NDE
    NDE = NDE + (Y_a1Ma0[n] - Y_a0Ma0[n])/N;
  }
}

for (n in 1:N)
  target += log_sum_exp(normal_lpdf(y[n] | mu[1], sigma[1]),
                        normal_lpdf(y[n] | mu[2], sigma[2]));