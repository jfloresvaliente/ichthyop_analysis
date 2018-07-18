#===============================================================================
# Name   : max_distance_calculation
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
library(abind)
library(foreach)
source('source/MaxDistFromBeginning.R')
source('source/LonLatArray.R')
source('source/traitsDrift.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/csv_files/max_distance/'

simu <- 'clim_lobos'

month_max.distance <- NULL
for(i in 1:12){
  ini <- Sys.time()
  csvfile <- paste0(dirpath,'traj_', simu, i, '.csv')
  print(paste('Reading ...', csvfile))
  df <- read.table(csvfile, header = T)
  
  print(paste('Converting [lon lat] in [lon lat drifter]...'))
  arr <- foreach(drif=1) %dopar%
    LonLatArray(df)
  arr <- arr[[1]]; dim(arr)
  
  print(paste('Obtaining traits of each particle...'))
  traits <- foreach(drif=1) %dopar%
    traitsDrift(df)
  traits <- traits[[1]]; dim(traits)
  
  print('Calculating the maximum distance from the starting point...')
  distance <- foreach(drif=1:length(levels(factor(df$Drifter)))) %dopar%
    MaxDistFromBeginning(arr[,,drif])
  distance <- unlist(distance)/1000 # Max distance in Km
  
  dist_month <- cbind(traits, distance)
  
  # print(csvfile)
  month_max.distance <- rbind(month_max.distance, dist_month)
  
  out <- Sys.time()
  print(out-ini)
}

colnames(month_max.distance) <- c('Drifter', 'Month', 'ReleaseDepth', 'Age', 'MaxDistFromBeginning')
# write.table(x = month_max.distance, file = paste0(out_path,simu, '_distance.csv'), row.names = F, sep = ',')

