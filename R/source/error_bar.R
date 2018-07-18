#===============================================================================
# Name   : error_bar
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Calculate the error bar with significance value
# URL    : 
#===============================================================================
error_bar <- function(x, a = 0.05){
  # x = vector o matrix with data to evaluate, if x is a matrix, each column will be evaluate
  # a = confianza interval to evaluate
  
  if(!is.null(dim(x))){
    stat <- NULL
    for(i in 1:dim(x)[2]){
      n  <- length(x[,i])
      m  <- mean(x[,i], na.rm = T)
      s  <- sd(x[,i], na.rm = T)
      tt <- -qt(a/2,n-1)
      ee <- sd(x[,i])/sqrt(n)  # standard error. It is different from the standard deviation
      e  <- tt*ee          # error range
      d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
      li <- m-e            # lower limit
      ls <- m+e            # upper limit
      vec <- c(m, li, ls)
      stat <- rbind(stat, vec)
    }
  }else{
    n  <- length(x)
    m  <- mean(x, na.rm = T)
    s  <- sd(x)
    tt <- -qt(a/2,n-1)
    ee <- sd(x)/sqrt(n)  # standard error. It is different from the standard deviation
    e  <- tt*ee          # error range
    d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
    li <- m-e            # lower limit
    ls <- m+e            # upper limit
    stat <- c(m, li, ls)
  }
  return(stat)
}

#===============================================================================
# END OF PROGRAM
#===============================================================================
