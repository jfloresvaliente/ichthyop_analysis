#===============================================================================
# Name   : tracking_mean_depth
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Get larval trajectorie for each recruited particle
# URL    : 
#===============================================================================
tracking_mean_depth = function (
  firstdrifter = 1
  ,lastdrifter = 20000
  ,recruitmentzone = 1
  ,firsttime = 1
  ,lasttime = 55
  ,dates
  ,filenames
  ,old.path
  ,new.path
  ,status){
  
  #============ ============ Arguments ============ ============#
  
  # In case one wishes to consider only a subset of all drifters
  # firstdrifter = Index of first drifter to be compued
  # lastdrifter  = Index of last drifter to be computed
  
  # recruitmentzone = The index of the recruitment zone for which recruitment is computed
  # firsttime = Time at tracking begins
  # lasttime = Time at tracking ends
  # dates = '.csv' file with information of release days
  # filenames = list of selected ncfiles
  
  # To read 'xml' files from a directory different to original directory
  # old.path = path written in each ncdf input file
  # new.path = path where '.xml' files are stored
  
  # status; if 1 = recruited, if 0 = non-recruited
  
  #============ ============ Arguments ============ ============#
  
  library(ncdf4)
  library(XML)
  library(sp)
  
  # An inner function that computes 'tracking_each_larval' for one file
  each_larval_file = function(filename){
    
    nc <- nc_open(filename)
    nbdrifter <- lastdrifter - firstdrifter + 1
    nbtime    <- lasttime    - firsttime    + 1
    
    #Gets the drifter, lon, lat, and depth
    drifter <- rep(seq(firstdrifter, lastdrifter), each = nbtime)
    timer <- rep(seq(firsttime, lasttime), times = nbdrifter)
    lon <- as.vector(t(ncvar_get(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
    lon <- lon-360  
    lat <- as.vector(t(ncvar_get(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
    depth <- as.vector(t(ncvar_get(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
    recruited <- ncvar_get(nc,'recruited_zone',c(recruitmentzone,firstdrifter,lasttime),c(1,nbdrifter,1))
    recruited <- as.vector(rep(recruited, each = lasttime))
    age <- ncatt_get(nc,0 ,'action.recruitment.zone.limit_age')$value
    
    # settle_day = ncvar_get(nc,'recruited_zone',c(recruitmentzone,firstdrifter,firsttime),c(1,nbdrifter,lasttime))
    # settlement = NULL
    # for(i in 1:20000){
    #   settle = which.max(settle_day[i,])[1]/2
    #   settlement = c(settlement, settle)
    # }
    # settlement = rep(settlement, each = lasttime)
    
    #Gets the year and day
    compute_yearday <- function(time){
      nbdays <- 1+time/86400
      year <- 1+as.integer(nbdays/360)
      day <- as.integer(nbdays-360*(year-1))
      #if (day < 10) day <- paste('0',day,sep='')
      #if (as.numeric(day) < 100) day <- paste('0',day,sep='')
      return(c(year,day))
    }
    
    # Gets the value of time of release
    t0 <- ncvar_get(nc,'time',1,1)
    
    # Computes year and day of release
    yearday <- compute_yearday(t0)
    calendar <- subset(dates, dates$year == yearday[1] & dates$month == yearday[2])
    year <- calendar$Y
    month <- calendar$M
    
    # Gets the release_depth
    filezone <- ncatt_get(nc,0,'release.zone.zone_file')$value
    filezone <- gsub(pattern = old.path, replacement = new.path, filezone)
    mindepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['upper_depth']])
    maxdepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['lower_depth']])
    release_depth <- paste(mindepth,maxdepth,sep='-')
    
    df <- data.frame(drifter, lon, lat, depth, year, month, release_depth, age, timer,recruited) #settlement,
    days <- seq(1,55,2) # To get only record time in days

    df2 <- subset(df, df$drifter == 1 & df$timer %in% days)
    df2$depth <- rep(NA, times = 28) # Para rellenar espacio donde no hubo reclutamiento
    df2$timer <- 1:28
    
    df <- subset(df, df$timer %in% days & df$recruited == status) # cambiar a cero para no reclutadas
    
    if(dim(df)[1]==0){
      df <- df2[1:28,1:9]
    }else{
      m <- tapply(df$depth, list(df$timer), mean)
      m <- cbind(df[1:28,1:3], m , df[1:28,5:9])
      names(m) <- names(df)[1:9]
      df <- m
      df$timer <- 1:28
    }
    
    rm(filezone, mindepth, maxdepth)
    
    return(df)
    close.ncdf(nc)
  }
  
  # Computes larval tracking for the first file 
  dataset <- each_larval_file(filenames[1])
  print(filenames[1])
  # Computes larval tracking for all subsequent files 
  if (length(filenames) > 1){
    for (i in seq(2, length(filenames))){
      # Shows name of opened file on the console
      print(filenames[i])
      flush.console()
      # Computes larval tracking data for file i
      data <- each_larval_file(filenames[i])
      # Adds track_each_larval data computed for file i to those computed from all previous files
      dataset <- rbind(dataset,data)
    }
  }

  colnames(dataset) <- c('Drifter','Lon','Lat','Depth','Year','Month','ReleaseDepth','Age','Day')
  return(dataset)
}
