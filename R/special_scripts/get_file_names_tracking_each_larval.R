#===============================================================================
# Name   : get_file_names_tracking_each_larval
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Get full name of ncfiles
#          then it can be used by main_tracking_each_larval.R
# URL    : 
#===============================================================================

#------------------------------------------------------------------------------#
# Este script permite obtener los nombres completos de los archivos a ser leidos
# y luego serán usados por la funcion que extrae la trajectoria de particulas
#------------------------------------------------------------------------------#
library(ncdf4)
library(XML)

winds <- 'daily'
simu  <- 'sechura_lobos'

# This directory contains directories with nc output files stored
directory <- 'G:/ICHTHYOP/final/output_2nd/'
directory <- paste0(directory, winds,'_',simu, '/')

# Real dates file
dates <- paste0('timer_Ascat_',winds,'.csv')
simuname <- paste0(winds, '_', simu)

# To read 'xml' files from a directory different to original directory
old.path <- '/run/media/cimobp/JORGE_NEW/ICHTHYOP/ichthyop-3.2/cfg/'
new.path <- 'F:/ichthyop_output_analysis/RUN4/cfg/'

times <- read.table(paste0(new.path, dates), sep=";", header = TRUE)

#Gets the year and day
compute_yearday <- function(time){
  nbdays = 1+time/86400
  year = 1+as.integer(nbdays/360)
  day = as.integer(nbdays-360*(year-1))
  #if (day < 10) day <- paste('0',day,sep='')
  #if (as.numeric(day) < 100) day <- paste('0',day,sep='')
  return(c(year,day))
}

# Get all nc filenames for input directory
file.names <- list.files(directory, 'nc', full.names = T, recursive = T)

# release.month = 2
ini.dates = NULL
for(i in 1:length(file.names)){
  
  nc <- nc_open(file.names[i])
  
  # Gets the value of time of release
  t0 <- ncvar_get(nc,'time',1,1)
  # Computes year and day of release
  yearday <- compute_yearday(t0)
  calendar <- subset(times, times$year == yearday[1] & times$month == yearday[2])
  yearday <- cbind(as.numeric(calendar$Y), as.numeric(calendar$M), nc$filename)
  
  ini.dates <- rbind(ini.dates,yearday)
  
  print(nc$filename)
  # if(release.month != calendar$M){next} else {ini.dates = rbind(ini.dates,yearday)}
  nc_close(nc); rm(t0,yearday,calendar)
}

ini.dates <- as.data.frame(ini.dates)
colnames(ini.dates) <- c('Year', 'Day', 'FileName')
write.table(ini.dates, paste0(new.path, winds, '_', simu, '_files.csv'), row.names = F, col.names = T)
