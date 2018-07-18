#===============================================================================
# Name   : count_limit_lat_trajectorie
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
count_limit_lat_trajectorie <- function(dates, filenames, lat_limit){
  library(ncdf4)
  library(XML)
  
  lat_limit <- lat_limit # Limit of latitude to calculate passed particles
  
  # Dates of release particles needed for daily winds
  dates <- dates # this file must be consistent with the type of simulation
  # dates <- subset(dates, dates[,1] %in% c(2009:2011))
  
  # Directory that contains the series of netcdf input files
  # dirpath <- paste0('D:/ICHTHYOP/final/output_2nd/', winds, '_sechura_lobos_t',tx,'/')
  
  # To read 'xml' files from a directory different to original directory
  old.path <- '/run/media/jtam/JORGE_NEW/ICHTHYOP/ichthyop-3.2/cfg/'
  new.path <- 'D:/ICHTHYOP/final/processed/cfg/'
  
  # In case one wishes to consider only a subset of all drifters
  # Index of the first and last drifters
  firstdrifter <- 1 # firstdrifter
  lastdrifter  <- 20000 # lastdrifter
  
  # In case one wishes to consider only a subset of all time records
  # Index of the first and last time records
  firsttime <- 1 # firsttime
  lasttime  <- 55 # lasttime
  
  compute_limit_lat_trajectorie_files <- function(filename){
    
    # An inner function that computes year and day from time in seconds
    compute_yearday <- function(time){
      nbdays <- 1+time/86400
      year <- 1+as.integer(nbdays/360)
      day <- as.integer(nbdays-360*(year-1))
      #if (day < 10) day <- paste('0',day,sep='')
      #if (as.numeric(day) < 100) day <- paste('0',day,sep='')
      return(c(year,day))
    }
    
  nc        <- nc_open(filename)
  nbdrifter <- lastdrifter - firstdrifter + 1
  nbtime    <- lasttime    - firsttime + 1
  drifter   <- rep(seq(firstdrifter, lastdrifter), each = nbtime)
  lon       <- as.vector(t(ncvar_get(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  lon       <- lon-360
  lat <- as.vector(t(ncvar_get(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
    
  # Gets the value of time of release
  t0 <- ncvar_get(nc,'time',1,1)
  
  # Computes year and day of release
  yearday <- compute_yearday(t0)
    
  # Read a file with particles release time (year-month)...
  # times <- read.table(paste0(new.path, dates), sep=";", header = TRUE)
  times <- dates
  calendar <- subset(times, times$year == yearday[1] & times$month == yearday[2])
    
  #Reads zonefile, gets the values of min and max depth of release and concatenates them
  filezone <- ncatt_get(nc,0,'release.zone.zone_file')$value
  filezone <- gsub(pattern = old.path, replacement = new.path, filezone)
  mindepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[["zone"]][["thickness"]][["upper_depth"]])
  maxdepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[["zone"]][["thickness"]][["lower_depth"]])
  depth    <- paste(mindepth,maxdepth,sep='-')

  year <- calendar$Y
  # if(year == 2008){ year = 2012 }
  month <- calendar$M
    
  df <- data.frame(lon, lat, drifter)
  # a <- subset(df, df$lat < lat_limit)
  # a <- subset(df, df$lat > -6.35 & df$lon > -81.7 & df$lat < -6)
  a <- subset(df, df$lon < -81.5 & df$lat < -6.25) # para saber cuantas se perdieron off-shore
  b <- factor(a$drifter)
  b <- levels(b)
  b <- length(as.numeric(b))
  # b <- lastdrifter - length(as.numeric(b))
  df <- data.frame(lastdrifter, b , year, month, depth)
  nc_close(nc)
  return(df)
  }
  
  # filenames <- list.files(path = dirpath, pattern = 'nc', full.names = TRUE)
  filenames <- filenames
  
  # Computes 'compute_limit_lat_trajectorie_files' for the first file 
  dataset <- compute_limit_lat_trajectorie_files(filenames[1])
  print(filenames[1])
  flush.console()
  
  # Computes 'compute_limit_lat_trajectorie_files' for all subsequent files
  if (length(filenames) >1){
    for (i in seq(2, length(filenames))){
      # Shows name of opened file on the console
      print(filenames[i])
      flush.console()
      # Computes recruitment data for file i
      data <- compute_limit_lat_trajectorie_files(filenames[i])
      # Adds recruitment data computed for file i to those computed from all previous files
      dataset <- rbind(dataset,data)
    }
  }
  
  colnames(dataset) <- c('NumberReleased','NumberPassed','Year','Month','Release_Depth')
  return (dataset)
}


#===============================================================================
# END OF PROGRAM
#===============================================================================
