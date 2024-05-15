data{
                int<lower=0> N;                           // number of observations
                int<lower=0> P;                           // number of columns in the control matrix. Call control the matrix of rhs variables minus partisanship and authoritarianism
                matrix[N, P] X;                           // controls, so excluding authoritariaism and pid
                vector[N]    A;                           // observed authoritarianism, again just extracting stuff from the data matrix
                vector[N]    A_2;
                int<lower=0,upper=1> M[N];                // partisan feeling-t1
                real MxA[N];                              //partisan feeling-t1 x authoritarianism-t1
                real Y[N];                                // partisan feeling
                vector[P + 5]     alpha_m;                // mean of regression priors.  Again, just declaring according to the
                vector[P + 2]     beta_m;                 // vector of priors for the mediation equation, PID = .....
                cov_matrix[P + 5] alpha_vcv;              // variance-covariance of regression priors
                cov_matrix[P + 2] beta_vcv;
                    }
        transformed data{
                vector[N] boot_probs = rep_vector(1.0/N, N);     // make vector of 1/N for (classical) bootstrapping. This just assigns an equal probability for bootstrap samples..
                vector[N] vM   = to_vector(M);                  // make vector copy of M
                vector[N] vMxA = to_vector(MxA);                 // make vector copy of MxA
                vector[N] vMxA_2 = to_vector(MxA_2);             // make vector copy of MxA_2
                }
        parameters{
                vector[P + 5] alpha;                         // regression coefficients (outcome model), add 2 because the size of this vector also include pid/auth ints included
                vector[P + 2] beta;                          // regression coefficients (mediator model), add 1 because must also include auth.
                real<lower=0>sigma;
                }
        transformed parameters {
                //Save all the parameters in a set of vectors; alpha for the outcome, beta for the mediation
                vector[P] betaZ       = head(beta, P);
                vector[P] alphaZ      = head(alpha, P);
                real betaA            = beta[P + 1];
                real betaA_2          = beta[P + 2];
                real alphaA           = alpha[P + 1];
                real alphaA_2         = alpha[P + 2];
                real alphaM           = alpha[P + 3];
                real alphaMxA         = alpha[P + 4];
                real alphaMxA_2       = alpha[P + 5];

            }
        model {
            alpha ~ multi_normal(alpha_m, alpha_vcv);                   // priors on causal coefficients weakly informative for binary exposure
            beta  ~ multi_normal(beta_m, beta_vcv);
            // Likelihood in the mediation -- pid model
            M ~ bernoulli_logit(X * betaZ +  A * betaA + A_2 * betaA_2);
           // Likelihood in the outcome -- vote model
            Y ~ normal(X * alphaZ + A * alphaA +  A_2 * alphaA_2 + vM * alphaM + vMxA * alphaMxA + vMxA_2*alphaMxA_2, sigma);
                        }

        generated quantities{
            int row_i;
            real NDE_0 = 0;
            real NDE_1 = 0;

            real NIE_0 = 0;
            real NIE_1 = 0;

            vector[N] M_a0;
            vector[N] M_a1;

            vector[N] Y_a1_m0;
            vector[N] Y_a0_m0;
            vector[N] Y_a1_m1;
            vector[N] Y_a0_m1;
        for(n in 1:N){
            row_i = categorical_rng(boot_probs);
            M_a0[n] = bernoulli_logit_rng(X[row_i] * betaZ );
            M_a1[n] = bernoulli_logit_rng(X[row_i] * betaZ +  betaA + betaA_2);
            //Use these draws to form various NIE, NDE estimands
            //NDE -- Dem and Rep
            Y_a1_m0[n] = normal_rng(X[row_i] * alphaZ + M_a0[n] * alphaM + alphaA + alphaA_2 + M_a0[n]*1*alphaMxA  + M_a0[n]*1*alphaMxA_2, sigma);
            Y_a0_m0[n] = normal_rng(X[row_i] * alphaZ + M_a0[n] * alphaM, sigma);

            Y_a1_m1[n] = normal_rng(X[row_i] * alphaZ + M_a1[n] * alphaM + alphaA + alphaA_2 + M_a1[n]*1*alphaMxA  + M_a1[n]*1*alphaMxA_2, sigma);
            Y_a0_m1[n] = normal_rng(X[row_i] * alphaZ + M_a1[n] * alphaM, sigma);
        NDE_0 = NDE_0 + (Y_a1_m0[n] - Y_a0_m0[n])/N;
        NDE_1 = NDE_1 + (Y_a1_m1[n] - Y_a0_m1[n])/N;
        NIE_0 = NIE_0 + (Y_a0_m1[n] - Y_a0_m0[n])/N;
        NIE_1 = NIE_1 + (Y_a1_m1[n] - Y_a1_m0[n])/N;
    }
}


