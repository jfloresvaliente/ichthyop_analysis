#===============================================================================
# Name   : main_tracking_each_larval
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute larval tracking for ICHTHYOP outputs (from any directory)
# URL    : 
#===============================================================================
source('F:/GitHub/ichthyop_analysis/R/source/get_trajectories.R')
start.time <- Sys.time()

dirpath     <- 'G:/ICHTHYOP/final/output_2nd/daily_lobos/'
out_path    <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'

winds <- 'daily'
simu <- 'lobos_sechura' # Name of output files
table.files <- read.table(paste0('F:/ichthyop_output_analysis/RUN2/cfg/',winds,'_',simu, '_files.csv'), header = T, sep = ';')
table.files <- subset(table.files, table.files[,1] %in% c(2009:2011))

# To read 'xml' files from a directory different to original directory
old_path <- '/run/media/lmoecc/JORGE_NEW/ICHTHYOP/ichthyop-3.2/cfg/'  # path written in each ncdf input file
new_path <- 'F:/ichthyop_output_analysis/RUN2/cfg/'                     # path where '.xml' files are stored

dates <- paste0('timer_Ascat_', winds,'.csv')
dates <- read.table(paste0(new_path, dates), sep=';', header = TRUE)

for(i in 1:12){ # Loop for all months
  
  files <- subset(table.files, table.files[,2] == i)
  files <- as.vector(files[,3])

  firstdrifter  <- 1
  lastdrifter   <- 20000
  firsttime <- 1
  lasttime <- 55

  # The number of release zones
  nbreleasezones  <- 1
  # The index of the recruitment zone for which recruitment is computed
  recruitmentzone <- 3 # 1 = WEST , 2 = EAST, 3 = SECHURA
  
  dataset <- get_trajectories(firstdrifter,lastdrifter,recruitmentzone,firsttime,lasttime,
                                  dates,files = files,old_path,new_path)
  write.table(dataset, paste0(out_path,'traj_',winds,'_',simu,i,'.csv'), row.names = F, sep = ';')
  rm(dataset)
}

end.time <- Sys.time()
time.taken <- print(end.time - start.time)
rm(list = ls())
#===============================================================================
# END OF PROGRAM
#===============================================================================