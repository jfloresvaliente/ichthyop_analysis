#===============================================================================
# Name   : main_tracking_mean_depth
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute larval tracking for ICHTHYOP outputs (from any directory)
# URL    : 
#===============================================================================
source('source/tracking_mean_depth.R')
start.time <- Sys.time()

# dirpath     <- 'G:/ICHTHYOP/final/output_2nd/daily_lobos/'
out_path    <- 'F:/ichthyop_output_analysis/RUN2/csv_files/tracking_mean_depth/'

winds <- 'clim'
simu <- 'sechura_lobos'
status <- 1 # 1 reclutados, 0 no-reclutados

if(winds == 'daily') a <- 'Daily' else a <- 'Clim'
if(simu == 'lobos')  b <- 'Lobos' else b <- 'SechuraLobos'
if(status == 1)      d <- 'Recruited' else d <- 'NonRecruited'

outName <- paste0('Traj', a,b,d)
# outName <- 'test'
table.files <- read.table(paste0('F:/ichthyop_output_analysis/RUN2/cfg/',winds,'_',simu, '_files.csv'), header = F)
table.files <- subset(table.files, table.files[,1] %in% c(2009:2011))

# To read 'xml' files from a directory different to original directory
old.path <- '/run/media/jtam/JORGE_NEW/ICHTHYOP/ichthyop-3.2/cfg/'  # path written in each ncdf input file
new.path <- 'F:/ichthyop_output_analysis/RUN2/cfg/'                     # path where '.xml' files are stored

dates <- paste0('timer_Ascat_', winds,'.csv')
dates <- read.table(paste0(new.path, dates), sep=';', header = TRUE)

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
  recruitmentzone <- 2 # 1 = WEST , 2 = EAST, 3 = SECHURA
  
  dataset <- tracking_mean_depth(firstdrifter,lastdrifter,recruitmentzone,firsttime,lasttime,
                                  dates,filenames = files,old.path,new.path,status = status)
  write.table(dataset, paste0(out_path,outName,i,'.csv'), row.names = F)
  rm(dataset)
}

end.time <- Sys.time()
time.taken <- print(end.time - start.time)
#===============================================================================
# END OF PROGRAM
#===============================================================================
