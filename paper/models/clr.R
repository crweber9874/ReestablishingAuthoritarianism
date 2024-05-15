rm(list = ls())
library(haven)
library(dplyr)

setwd("/Users/Chris/ReestablishingAuthoritarianism/paper/")
load("/Users/Chris/Dropbox/masterData/LuttigReplication/panel_data_2016.rda")
zero.one<-function(x){
  min.x<-min(x, na.rm=T)
  max.x<-max(x-min.x, na.rm=T)
  return((x-min.x)/max.x)
}

datSSI <- read_dta("data/dataverse_files/2016 panel study.dta") 
datNES <- read_dta("data/dataverse_files/merge201213nes.dta")   

## Recodes and type conversion ##

print("This is the lagged Regressor Model, Luttig's Model (SSI):")
lm(w2repft   ~     w1authoritarianism + w1repft +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datSSI) %>% summary
lm(w2authoritarianism   ~     w1authoritarianism + w1repft +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datSSI) %>% summary


print("This is the lagged Regressor Model, Luttig's Model (NES):")
lm(romneyft13   ~  w1authoritarianism + romneyft12 +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary
lm(w2authoritarianism   ~  w1authoritarianism + romneyft12 +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary
lm(w2authoritarianism   ~  w1authoritarianism + ft_rep12 +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary 


print("This is the lagged Regressor Model, 16-20 ANES:")

panel_data_2016 = panel_data_2016 %>% 
  mutate(authW1 = rowMeans(cbind(auth.1.2016, auth.2.2016, auth.3.2016, auth.4.2016), na.rm = TRUE)) %>%
  mutate(authW2 = rowMeans(cbind(auth.1.2020, auth.2.2020, auth.3.2020, auth.4.2020), na.rm = TRUE)) %>%
  mutate(authW1 = zero.one(authW1)) %>%
  mutate(authW2 = zero.one(authW2)) %>%
  mutate(feeling.repc.2016 = zero.one(feeling.repc.2016)) %>%
  mutate(feeling.repc.2020 = zero.one(feeling.repc.2020)) 

lm(authW2   ~  authW1 + feeling.repc.2016 +
     college.2016 +  income.2016 +  age.2016 +  white.2016 +
     black.2016 +  female.2016, data = panel_data_2016) %>% summary 

lm(feeling.repc.2020   ~  authW1  + feeling.repc.2016 +
     college.2016 +  income.2016 +  age.2016 +  white.2016 +
     black.2016 +  female.2016, data = panel_data_2016) %>% summary 

## Effect Moderationa

print("This is the lagged Regressor Model, effect moderation,  Luttig's Model (SSI):")
lm(w2repft   ~     w1authoritarianism + w1repft + w1authoritarianism:w1repft +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datSSI) %>% summary
lm(w2authoritarianism   ~     w1authoritarianism + w1repft + w1authoritarianism:w1repft +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datSSI) %>% summary
print("This is the lagged Regressor Model, Luttig's Model (NES):")
lm(romneyft13   ~  w1authoritarianism + romneyft12 + w1authoritarianism:romneyft12 +
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary
lm(w2authoritarianism   ~  w1authoritarianism + romneyft12 + w1authoritarianism:romneyft12+
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary
lm(w2authoritarianism   ~  w1authoritarianism + ft_rep12 + w1authoritarianism:romneyft12+
     educ01 +  income01 +  age +  white +
     black +  sex, data = datNES) %>% summary 
lm(authW2   ~  authW1 + feeling.repc.2016 +  authW1:feeling.repc.2016 + 
     college.2016 +  income.2016 +  age.2016 +  white.2016 +
     black.2016 +  female.2016, data = panel_data_2016) %>% summary 
lm(feeling.repc.2020   ~  authW1  + feeling.repc.2016  +  authW1:feeling.repc.2016 +
     college.2016 +  income.2016 +  age.2016 +  white.2016 +
     black.2016 +  female.2016, data = panel_data_2016) %>% summary 
### This is the sorting argument ####


