# Test the dataSimulate, Use testthis in the console to run the test

# Test
library(dplyr)
WAVES = 3
SAMPLES = 1000
UNOBSERVED_SLOPE = 0.5
INSTRUMENT_SLOPE = 0.5
STABILITY_SLOPE   = 0.5
CROSS_LAG = c(0.5, 0.5)
CURRENT = rep(0.5, WAVES)
CORR.ZU = 0

dataWide = generate_data()$data
# List of data elements, data is data$data
dataLong = dataWide %>% reshapeLong()
# Test
# dim(dataLong)[1] == dim(dataWide)[1] * WAVES
# [1] TRUE
# BRMS multilevel model

library(brms)

formula_brms <- bf(yval ~ xlag + ylag + 
                      (1 | id) )

formula_lm  <- formula(yval ~ xlag + ylag)

betas = lm(formula_lm, data = dataLong)$coefficients

prior = c(
  prior(normal(0.5, 10), class = "Intercept"),    # Intercept prior
  prior(normal(0.5, 2), class = "b", coef = "xlag"), # xlag slope prior
  prior(normal(0.5, 2), class = "b", coef = "ylag"), # ylag slope prior
  prior(cauchy(0, 2), class = "sd", lb = 0)       # Standard deviation prior
)

model <- brm(formula_brms, 
             prior = prior,
             iter = 1000,
             cores = 9,
             control = list(adapt_delta = 0.99),
             data = na.omit(dataLong))


prior = c(
  prior(normal(0.5, 10), class = "Intercept"),    # Intercept prior
  prior(normal(0.5, 2), class = "b", coef = "xlag"), # xlag slope prior
  prior(normal(0.5, 2), class = "b", coef = "ylag"), # ylag slope prior
  prior(normal(0.5, 2), class = "b", coef = "xval"), # ylag slope prior
  prior(cauchy(0, 2), class = "sd", lb = 0)       # Standard deviation prior
)

formula_brms <- bf(yval ~ xlag + ylag + xval + 
                     (1 | id) )







# Fix cmdstan
# Priors (optional but recommended)
priors <- c(
  prior(normal(80, 10), class = "Intercept"),
  prior(normal(5, 5), class = "b"),   # Slope prior
  prior(normal(0, 5), class = "sd")   # Standard deviation prior
)

# Fit the model
model <- brm(model_formula, data = data, prior = priors)

# Summarize results
summary(model)



# Test
test <- generate_data(waves = 3, 
                      sample_size = 10000,
                      unobserved_slopes = 0,
                      cross_lag_slopes = rep(0.5, 3 - 1),  # Fix: Default for multiple waves
                      contemporaneous_slopes = rep(1, 3))

dat = test$data
# Set index
# Pivot Y

y = dat %>% select(contains("y"))%>%
  mutate(id = row_number()) %>%
  # pivot longer -- cols contain y, use contains
  pivot_longer(cols = starts_with("y"))
names(y) = c("id", "y_var", "yval")            

x = dat %>% select(contains("x"))%>%
  #mutate(id = row_number()) %>%
  pivot_longer(cols = starts_with("x")) 
names(x) = c("x_var", "xval")  #

# join x y
dat = cbind(x, y) %>%
  mutate(wave = readr::parse_number(x_var)) %>%
  group_by(id) %>%  
  mutate(
    xlag = lag(xval, order_by = wave) 
  ) %>%
  ungroup()  %>%
  select(id, wave, xval, yval, xlag)


?pivot_longer
lm(y2 ~ -1 + y1 + x1 ,  data = test$data) 

