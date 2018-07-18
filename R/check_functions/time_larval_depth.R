#===============================================================================
# Name   : time_larval_depth
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute mean depth, upper limit and lower limit for time vs larval depth
# URL    : 
#===============================================================================
time_larval_depth <- function(data, firstdrifter, lastdrifter){
  
  data = data
  firstdrifter = firstdrifter
  lastdrifter  = lastdrifter
  
  times = rep(1:lastdrifter,times=length(data[,1])/lastdrifter)
  data  = cbind(data, times)
  
  time_day = NULL
  for (i in 1:lastdrifter){
    group = subset(data, data$times == i) # subset all particles at time 1,2,3...
    
    particles.depth = group$depth
    
    x  = particles.depth; n  = length(x); m  = mean(x); s  = sd(x)
    a  = 0.05           # Statistical confidence 
    tt = -qt(a/2,n-1)
    ee = sd(x)/sqrt(n)  # Standard error
    e  = tt*ee          # Error range
    d  = e/m            # Relative error
    li = m-e            # Lower limit
    ls = m+e            # Upper limit
    
    res = c(m , li , ls)
    time_day = rbind.data.frame(time_day , res) # Save values of "res" for each time 
    colnames(time_day) = c("mean","lim_min", "lim_max")
  }
  
  time_day[,3][time_day[,3] >=0] = 0
  # time_day[,2][time_day[,2] < (-100)] = -100
  return(time_day)
  
}
