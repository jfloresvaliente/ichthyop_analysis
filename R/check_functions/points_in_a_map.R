#===============================================================================
# Name   : points_in_a_map
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Plot specific points (lon , lat) in a map
# URL    : 
#===============================================================================
points_in_a_map <- function(){
  
  library(ggmap)
  
  # Set up approximate coordinates for map dimensions
  lonmin <- 277 - 360 
  lonmax <- 280 - 360
  latmin <- -8.0
  latmax <- -4.0
  
  # Coordinates of each point. Firts longitudes, then latitudes
  lon     = c(-80.83, -81.07, -81.30, -81.18)
  lat     = c(-06.32, -06.19, -05.51, -05.86)
  
  # Name for each point
  Name = c("P1","P2","P3","P4")
  
  df = data.frame(lon, lat,Name)
  
  lonlim <- c(lonmin, lonmax)
  latlim <- c(latmin, latmax)
  mymap  <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2), zoom = 9, maptype = "hybrid")
  map    <- ggmap(mymap)
  map    <- map + geom_point(data = df, aes(x = lon, y = lat), size = 3, color="yellow") +
            geom_text(data = df, aes(x=lon, y=lat, label=Name), size=7, hjust= 1.3, color="yellow")
  map + labs(x = 'Longitude', y = 'Latitude')
  # ggsave(filename= paste0("MAPA",".png")) # Comment this line if you don't want to save the plot
  
}
# setwd("~/Documentos/ICHTHYOP/ichthyop-3.2/output")
  
