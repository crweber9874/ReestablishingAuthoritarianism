library(MASS)
library(dplyr)
library(tidyr)

reshapeLong = function(data = dat){
  y = data %>% 
    select(contains("y"))%>%
    mutate(id = row_number()) %>%
    pivot_longer(cols = starts_with("y"))
  names(y) = c("id", "y_var", "yval")            
  
  x = data %>% select(contains("x"))%>%
    #mutate(id = row_number()) %>%
    pivot_longer(cols = starts_with("x")) 
  names(x) = c("x_var", "xval")  #
  
  # join x y
  dat = cbind(x, y) %>%
    mutate(wave = readr::parse_number(x_var)) %>%
    group_by(id) %>%  
    mutate(
      xlag = lag(xval, order_by = wave),
      ylag = lag(yval, order_by = wave)
    ) %>%
    ungroup()  %>%
    select(id, wave, xval, yval, xlag, ylag)
  return(dat)
  }
  
## Not Run
## generate_data()$data %>% reshapeLong()
 
