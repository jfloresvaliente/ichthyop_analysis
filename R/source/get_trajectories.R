#===============================================================================
# Name   : get_trajectories
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Get larval trajectories only for recruited particles from a ncfile
# URL    : 
#===============================================================================
get_trajectories <- function(
  files
  ,firstdrifter = 1
  ,lastdrifter = 20000
  ,recruitmentzone = 1
  ,firsttime = 1
  ,lasttime = 55
  ,dates
  ,old_path
  ,new_path
  ){
  #============ ============ Arguments ============ ============#
  
  # files = list of selected ncfiles to get larval trajectories
  # In case one wishes to consider only a subset of all drifters
  # firstdrifter = Index of first drifter to be compued
  # lastdrifter  = Index of last drifter to be computed
  
  # recruitmentzone = The index of the recruitment zone for which recruitment is computed
  # firsttime = Time at tracking begins
  # lasttime = Time at tracking ends
  # dates = '.csv' file with information of release days

  # To read 'xml' files from a directory different to original directory
  # old_path = path written in each ncdf input file
  # new_path = path where '.xml' files are stored
  
  #============ ============ Arguments ============ ============#
  
  library(ncdf4)
  library(XML)
  # library(sp)

  # An inner function that computes 'tracking_each_larval' for one file
  get_trajectories_file = function(filename){
    
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
    
    # Get step-time when the particles were recruited (if 0.5 is consider non-recruited)
    settlement <- ncvar_get(nc,'recruited_zone',c(recruitmentzone,firstdrifter,firsttime),c(1,nbdrifter,lasttime))
    settlement <- apply(settlement, 1, function(x) which.max(x)/2)
    
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
    filezone <- gsub(pattern = old_path, replacement = new_path, filezone)
    mindepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['upper_depth']])
    maxdepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['lower_depth']])
    release_depth <- paste(mindepth,maxdepth,sep='-')
    
    df <- data.frame(drifter, lon, lat, depth, year, month, release_depth, age, timer,recruited) #settlement,
    days <- seq(1,55,2) # To change record time into days
    df <- subset(df, df$timer %in% days & df$recruited == 1)
    rm(filezone, mindepth, maxdepth)
    
    return(df)
    close.ncdf(nc)
  }
  
  # Computes get_trajectories for all files
  dataset <- NULL
  for(i in seq_along(files)){
    # Shows name of opened file on the console
    print(files[i])
    flush.console()
    # Computes recruitment data for file i
    data <- get_trajectories_file(files[i])
    # Adds recruitment data computed for file i to those computed from all previous files
    dataset <- rbind(dataset,data)
  }
  
  # # Computes larval tracking for the first file 
  # dataset <- get_trajectories_file(files[1])
  # 
  # # Computes larval tracking for all subsequent files 
  # if (length(files) > 1){
  #   for (i in seq(2, length(files))){
  #     # Shows name of opened file on the console
  #     print(files[i])
  #     flush.console()
  #     # Computes larval tracking data for file i
  #     data <- get_trajectories_file(files[i])
  #     # Adds track_each_larval data computed for file i to those computed from all previous files
  #     dataset <- rbind(dataset,data)
  #   }
  # }
  
  if(dim(dataset)[1] == 0){ # In case there is any particle recruited
    dataset = data.frame(t(rep(999, times = 9)))
  }else{
    drifter <- rep((1:(dim(dataset)[1]/round(lasttime/2))), each = round(lasttime/2))
    days <- rep(1:round(lasttime/2), times = length(1:(dim(dataset)[1]/round(lasttime/2))))
    dataset <- cbind(drifter, dataset[,2:8], days)
  }

  colnames(dataset) <- c('Drifter','Lon','Lat','Depth','Year','Month','ReleaseDepth','Age','Day')
  return(dataset)
}
#===============================================================================
# END OF PROGRAM
#===============================================================================