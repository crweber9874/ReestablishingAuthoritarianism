### Simulate two wave panel data

library(MASS)
library(dplyr)

MU = 0
SIGMA = 1
A1 = 0.5 # Set 1 Equation, Z
A2 = 0.5 # Set 1 Equation, U
B1 = 0.5 # Set 2 Equation, X1
B2 = 0.5 # Set 2 Equation, Y1
B3 = 0.5 # Set 2 Equation, Instrument
B4 = 0   # Set 2 Equation, Unobserved Confounder

generateData = function(n = 1000, mu = MU, sigma = SIGMA,
                        A1 = 0.5,
                        A2 = 0.5,
                        B1 = 0.5,
                        B2 = 0.5,
                        B3 = 0.5,
                        B4 = 0){
                        
                        z1 =  rnorm(n, mu,  sigma)
                    


                        #2) Missing set U
                        
                        u1 =  rnorm(n, mu,  sigma)
                        
                        ### Endogenous Set X and Y
                
                        y1 = A1 * z1 + A2 * u1  + rnorm(n, 0, .5)
                        x1 = A1 * z1 + A2 * u1  + rnorm(n, 0, .5)
                        y2 = B1 * x1 + B2 * y1   + B3 * z1 + B4 * u1 + rnorm(n, 0, .5)
                        x2 = B1 * x1 + B2 * y1   + B3 * z1 + B4 * u1 + rnorm(n, 0, .5)
                        dat = data.frame(y1, y2, x1, x2, z1, u1) 
                        names(dat) = c("y1", "y2", "x1", "x2", "z1", "u1")
                                       return(dat)
}
  

b4 = seq(-1, 1, by = .1)
for(i in 1:length(b4)){
        print(lm(y2 ~ y1 + x1 + z1,
                 generateData(B4 = b4[i])))}
              
              
              
           



