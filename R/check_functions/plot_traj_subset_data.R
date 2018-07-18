#===============================================================================
# Name   : plot_traj_subset_data
# Author : Lett; modified by Jorge Flores
# Date   : 
# Version:
# Aim    : Plot particle paths from a subset of data of the form
#          [drifter,lon,lat,depth,time]
# URL    : 
#===============================================================================
plot_traj_subset_data <- function(df, pngfile = NULL){
  
  library(ncdf4)
  library(ggmap)
  
  df = df

  # Name of the simulation
  # simulation = "sechura_lobos"
  
  # The minimum and maximum longitudes and latitudes for the plots
  # Northern Peru
  lonmin  <- 278 - 360
  lonmax  <- 280 - 360
  latmin  <- -4.6
  latmax  <- -7.4

  nbcolor <- 10

  mymap  <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
                    zoom = 8, maptype = "hybrid", color="bw")
  map    <- ggmap(mymap)
  map <- map + # geom_point(data = df, aes(x = lon, y = lat, colour = time), size = .1) +
    geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = time), size = .1) +
    scale_colour_gradientn(colours = rainbow(nbcolor), limits=c(0,27), expression(Days))  
  
  map + labs(x = 'Longitude (°O)', y = 'Latitude (°S)')
  if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map
}

