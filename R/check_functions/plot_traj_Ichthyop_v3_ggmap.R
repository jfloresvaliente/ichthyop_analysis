#===============================================================================
# Name   : plot_traj_Ichthyop_v3_ggmap
# Author : Lett; modified by Jorge Flores
# Date   : 
# Version:
# Aim    : Plot particle paths from an 'nc' file
# URL    : 
#===============================================================================
plot_traj_Ichthyop_v3_ggmap <- function(ncfile, firstdrifter, lastdrifter, firsttime,
                                        lasttime, pngfile = NULL){
	library(ncdf4)
	library(ggmap)

	# In case one wishes to consider only a subset of all drifters
	# Index of the first and last drifters
  firstdrifter <- firstdrifter
	lastdrifter  <- lastdrifter
	
	# In case one wishes to consider only a subset of all time records
	# Index of the first and last time records
  firsttime <- firsttime
	lasttime  <- lasttime

	# The minimum and maximum longitudes and latitudes for the plots
	# Northern Peru
  lonmin  <- 278 - 360
	lonmax  <- 280 - 360
	latmin  <- -5.5
	latmax  <- -6.5
	
	nbcolor <- 10

  nc        <- nc_open(ncfile)
  nbdrifter <- lastdrifter - firstdrifter + 1
  nbtime    <- lasttime    - firsttime + 1
	drifter   <- rep(seq(firstdrifter, lastdrifter), each = nbtime)
  lon       <- as.vector(t(ncvar_get(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  lon       <- lon-360
  lat <- as.vector(t(ncvar_get(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  depth <- as.vector(t(ncvar_get(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  time <- rep(ncvar_get(nc, 'time', firsttime, nbtime), nbdrifter)
  time <- (time - time[1])/86400
  # mortality <- as.vector(t(get.var.ncdf(nc, 'death', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  #releasezone <- rep(get.var.ncdf(nc, 'zone', c(firstdrifter,1), c(nbdrifter,1)), each = nbtime)
  #length <- as.vector(t(get.var.ncdf(nc, 'length', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  #   recruited <- ncvar_get(nc,'recruited_zone',c(recruitmentzone,firstdrifter,computeattime),c(1,nbdrifter,1))
  # recruitedzone <- as.vector(t(ncvar_get(nc, 'recruited_zone', c(recruitmentzonenb, firstdrifter, firsttime), c(1, nbdrifter, nbtime))))
  #	recruitedzone = ncvar_get(nc,'recruited_zone',c(recruitmentzonenb,firstdrifter,lasttime),c(1,nbdrifter,1))
  # recruitedzone = as.vector(rep(recruitedzone, each = lasttime))
  # df <- data.frame(drifter, lon, lat, mortality, depth, releasezone, recruitedzone, length)
  df <- data.frame(drifter, lon, lat, depth, time)
  nc_close(nc)

	mymap  <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
	                  zoom = 9, maptype = "hybrid", color="bw")
	map    <- ggmap(mymap)
	
	# map    <- map + geom_point(data = df, aes(x = lon, y = lat, colour = depth), size = .4) + 
	#   scale_colour_gradientn(colours = rainbow(nbcolor), limits=c(-65,0), expression(Depth))
	
	map <- map + geom_point(data = df, aes(x = lon, y = lat, colour = time), size = .1) +
	  geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = time), size = .1) +
	  scale_colour_gradientn(colours = rainbow(nbcolor), limits=c(0,27), expression(Days))
	
  map + labs(x = 'Longitude (?O)', y = 'Latitude (?S)')
  if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map

}
