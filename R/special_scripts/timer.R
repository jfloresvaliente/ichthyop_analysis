#===============================================================================
# Name   : timer.R
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Programa para buscar el T0 (scrum time) de cada output de ROMS
# URL    : 
#===============================================================================
timer <- function(dirpath){
  source('R/source/climatological_calendar.R')
  library(ncdf4)
  
  # The directory that contains the series of netcdf input files
  # dirpath <- '/run/media/jtam/JORGE_NEW/Peru10km/'
  
  # An inner function that computes year and day from time in seconds
  compute_yearday <- function(time){
    nbdays <- 1+time/86400
    year <- 1+as.integer(nbdays/360)
    day <- as.integer(nbdays-360*(year-1))
    #if (day < 10) day <- paste('0',day,sep='')
    #if (as.numeric(day) < 100) day <- paste('0',day,sep='')
    return(cbind(year,day))
  }
  
  # Gets filenames of all files in the dirpath directory 
  file_date <- NULL
  for(i in 2008:2012){
    for(j in 1:12){
      
      # ncfile <- paste0(dirpath, 'newperush_avg.Y',i,'.M',j,'.newperush.nc')
      ncfile <- paste0(dirpath, 'roms_avg_Y',i,'M',j,'.AscatMerClim.nc')
      print(ncfile)
      nc <- nc_open(ncfile)
      
      # Gets the value of time (t0 in seconds), year and day
      t0 <- ncvar_get(nc, 'time')
      year_day <- compute_yearday(t0)
      
      Y <- rep(i, times = length(t0))
      M <- rep(j, times = length(t0))
      t_x <- 1:length(t0)
      
      date <- cbind(t0, year_day, Y, M, t_x, ncfile)
      file_date <- rbind(file_date, date)
      nc_close(nc)
    }
  }
  
  # file_date <- as.data.frame(file_date)
  
  # Crear un calendadrio climatologico
  clim_calendar <- as.data.frame(climatological_calendar())
  clim_calendar <- subset(clim_calendar, clim_calendar$Seconds %in% as.numeric(file_date[,1]))
  
  timer_date <- cbind(file_date[,1],
                      file_date[,2],
                      file_date[,3],
                      clim_calendar[,1],
                      clim_calendar[,2],
                      clim_calendar[,3],
                      file_date[,4],
                      file_date[,5],
                      file_date[,6],
                      file_date[,7])
  colnames(timer_date) <- c('t0'
                            ,'year'
                            ,'day'
                            ,'sim_year'
                            ,'sim_month'
                            ,'sim_day'
                            ,'Y'
                            ,'M'
                            ,'t_x'
                            ,'name_file'
                            )
  return(timer_date)
}

dirpath <- '/run/media/jtam/JORGE_NEW/Peru10km/'
a <- timer(dirpath = dirpath)
write.table(x = a, file = paste0(dirpath, 'date_init_ichthyop.csv'), sep = ';', row.names = F)
