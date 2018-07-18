#===============================================================================
# Name   : recruitment_temp
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : This reads and calculates recruits for each lethal temp
#===============================================================================
recruitment_temp = function(dataset){
  
  #============ ============ Arguments ============ ============#
  
  # dataset = dataframe with recruitment information
  # with the following format and name of columns
  # [NumberReleased, NumberRecruited, ReleaseArea, Year, Day, Depth, ...
  #  Age, Coast_Behavior, Temp_min, name_file, t_x, Recruitprop ]      
  
  #============ ============ Arguments ============ ============#
  
  data_factor <- 100*tapply(as.numeric(dataset$NumberRecruited),dataset$Temp_min,sum) /
                 tapply(as.numeric(dataset$NumberReleased),dataset$Temp_min, sum)
  
  # An inner function that computes statistics of recruitment for a given factor
  compute_recruitment_stats <- function(released,recruited,factor){
    mean <- tapply(recruited,factor,sum)/tapply(released,factor,sum)
    var <- tapply(recruited^2,factor,sum)/tapply(released^2,factor,sum)-mean^2
    sem <- sqrt(var/table(factor))
    return(cbind(mean,sem))
  }
  
  # COMPUTE STATS -----------------------------------------------------------
  # Computes stats (mean, std error of the mean)
  data_stats <-compute_recruitment_stats(as.numeric(dataset$NumberReleased),
                                         as.numeric(dataset$NumberRecruited),
                                         as.numeric(dataset$Temp_min))
  data_mean      <- data_stats[,1]
  data_sem       <- data_stats[,2]
  
  return(cbind(data_factor, data_mean, data_sem))
}
#===============================================================================
# END OF PROGRAM
#===============================================================================