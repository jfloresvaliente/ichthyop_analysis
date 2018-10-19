#===============================================================================
# Name   : image_for_gif
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Plot a set of figures from ichthyop output
# URL    : 
#===============================================================================
image_for_gif <- function(){

	library(ncdf4)
	library(ggmap)

	# The netcdf input file
	dirpath = 'D:/ICHTHYOP/final/output_2nd/daily_sechura_lobos/'
	# dirpath = '/run/media/jtam/TOSHIBA EXT/ICHTHYOP/ichthyop_scallop/output/sechura_lobos_e/'
  # dirpath2 = 'C:/JORGE_FLORES/ICHTHYOP_OUTPUT/'
	ncfile  = 'daily_sechura_lobos_ichthyop-run201701271043_s317.nc'

  # Name of the simulation to be add in the name of the figures
  simulation = 'sechura_lobos_e'
  
  recruitmentzone <- 3
  
  
	# In case one wishes to consider only a subset of all drifters
	# Index of the first and last drifters
  firstdrifter = 1
	lastdrifter  = 20000
	
	# In case one wishes to consider only a subset of all time records
	# Index of the first and last time records
  firsttime    = 1
	lasttime     = 55

	# The minimum and maximum longitudes and latitudes for the plots
	# Peru
  lonmin  = -82
	lonmax  = -80
	latmin  = -7.0
	latmax  = -5.1
	# latmax  = -4.0
	
	nbcolor = 10
	
  nc = nc_open(paste0(dirpath,ncfile))
  nbdrifter = lastdrifter - firstdrifter + 1
  nbtime    = lasttime    - firsttime + 1

  drifter     = rep(seq(firsttime, lasttime), nbdrifter)
  lon         = as.vector(t(ncvar_get(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  lon         = lon-360
  lat         = as.vector(t(ncvar_get(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  mortality   = as.vector(t(ncvar_get(nc, 'mortality', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  depth       = as.vector(t(ncvar_get(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  # releasezone = rep(get.var.ncdf(nc, 'zone', c(firstdrifter,1), c(nbdrifter,1)), each = nbtime)
  
  releasezone <- rep(ncvar_get(nc,'zone',c(1,firstdrifter,1),c(1,nbdrifter,1)), each = nbtime)
  releasezone <- releasezone + 1
  
  # length <- as.vector(t(get.var.ncdf(nc, 'length', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
  
  recruitedzone <- as.vector(t(ncvar_get(nc, 'recruited_zone', c(recruitmentzone, firstdrifter, firsttime), c(1, nbdrifter, nbtime))))
  df = data.frame(drifter, lon, lat, mortality, depth, releasezone, recruitedzone)
  # df = data.frame(drifter, lon, lat)#, depth, recruitedzone)
#   df = subset(df, df$recruitedzone==1)
  nc_close(nc)
  
  lonlim <- c(lonmin, lonmax)
  latlim <- c(latmin, latmax)

### LOOP TO PLOT EACH RECORD TIME ###
m = seq(1, 55, 1)

# for (i in 1:nbtime){
for (i in m){

  name.day <- paste0('Dia ' , i)
  # a = -81.5 ; b = -6
  # d = paste0('Dia', i)
  # c = cbind(a,b,d); c = as.data.frame(c)
  
  
  snapchat = subset(df, df[,1] == i)
#   snapchat = subset(snapchat, snapchat$recruitedzone == 1)
  # mymap  <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2), zoom = 8, maptype = 'satellite', color='bw')
  map    <- ggplot(df, aes(lon,lat)) +
    borders(fill="black",colour="black") +
  #           geom_point(col="red", pch=16)
  # map    <- ggmap(mymap)
            geom_point(data = snapchat, aes(x = lon, y = lat), size = .05, colour ='red')+
            labs(x = 'Longitude (W)', y = 'Latitude (S)', title = ' ') +
            coord_fixed(xlim = lonlim, ylim = latlim, ratio = 2/2) +
            theme(axis.text.x  = element_text(face='bold', color='black', size=15, angle=0),
                  axis.text.y  = element_text(face='bold', color='black', size=15, angle=0),
                  axis.title.x = element_text(face='bold', color='black', size=15, angle=0),
                  axis.title.y = element_text(face='bold', color='black', size=15, angle=90),
                  plot.title   = element_text(face='bold', color='black', size=15, angle=0),
                  legend.text  = element_text(face='bold', color='black', size=15),
                  legend.title = element_text(face='bold', color='black', size=20),
                  legend.position   = c(0.92, 0.9),
                  legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.5, linetype='solid'))
  
  # map    <- map + geom_text(aes(x = -82.5, y = -6, label = name.day), colour='yellow',
  #                           size = 6.5, vjust = 0, hjust = -0.5)
  # map    <- map + geom_text (data = snapchat, aes(x = lon, y = lat, label=puntos), size = 1.5, colour ='black')
  # map + labs(x = 'Longitude', y = 'Latitude')
  ggsave(filename =  paste0(dirpath, simulation ,'_', i , '.png'))
  # ggsave(filename= paste0(dirpath2 , simulation ,'_', i , '.png'))
  }
}
image_for_gif()
