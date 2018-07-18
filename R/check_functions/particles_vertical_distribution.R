particles_vertical_distribution <- function(){
  
  library(ncdf)
#   library(ggmap)
  
  # The netcdf input file
  dirpath  = "C:/JORGE_FLORES/ICHTHYOP_OUTPUT/output/scallop_sechura_lobos/"
  dirpath2 = "C:/JORGE_FLORES/ICHTHYOP_OUTPUT/"
#   ncfile = nc
  ncfile = "sechura_lobos_ichthyop-run201608051145_s109.nc"
  
  # Name of the simulation
  simulation = "sechura_lobos"
  rele_depth = "20.0-30.0"
  # In case one wishes to consider only a subset of all drifters
  # Index of the first and last drifters
  firstdrifter <- 1
  lastdrifter  <- 20000
  
  # In case one wishes to consider only a subset of all time records
  # Index of the first and last time records
  firsttime <- 1
  lasttime  <- 55
  computeattime = lasttime
  # The minimum and maximum longitudes and latitudes for the plots
  # Peru
  lonmin <- 276.5 - 360
  lonmax <- 280.5 - 360
  latmin <- -8.0
  latmax <- -4.0
  
  nbcolor <- 10
  
  nc <- open.ncdf(paste0(dirpath,ncfile))
  nbdrifter <- lastdrifter - firstdrifter + 1
  nbtime    <- lasttime    - firsttime + 1
#   
#   drifter <- rep(seq(firsttime, lasttime), nbdrifter)
#   lon <- as.vector(t(get.var.ncdf(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
#   lon <- lon-360
#   lat <- as.vector(t(get.var.ncdf(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
#   #mortality <- as.vector(t(get.var.ncdf(nc, 'death', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
#   depth <- as.vector(t(get.var.ncdf(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
#   #releasezone <- rep(get.var.ncdf(nc, 'zone', c(firstdrifter,1), c(nbdrifter,1)), each = nbtime)
#   #length <- as.vector(t(get.var.ncdf(nc, 'length', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
#   recruitmentzonenb <- 1
#   recruitedzone <- as.vector(t(get.var.ncdf(nc, 'recruited_zone', c(recruitmentzonenb, firstdrifter, firsttime), c(1, nbdrifter, nbtime))))
#   #df <- data.frame(drifter, lon, lat, mortality, depth, releasezone, recruitedzone, length)
# #   df = data.frame(drifter, lon, lat)#, depth, recruitedzone)
#   df = data.frame(drifter, depth)#, recruitedzone)
# #   df = subset(df, df$recruitedzone == 1)
# #   df = df[,1:2]

drifter <- rep(seq(firstdrifter, lastdrifter), each = nbtime)   
lon <- as.vector(t(get.var.ncdf(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
lon <- lon-360  
lat <- as.vector(t(get.var.ncdf(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
depth <- as.vector(t(get.var.ncdf(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))

recruitmentzone <- 1
recruited = get.var.ncdf(nc,'recruited_zone',c(recruitmentzone,firstdrifter,computeattime),c(1,nbdrifter,1))
recruited = as.vector(rep(recruited, each = computeattime))

df = data.frame(drifter, lon, lat, depth, recruited)

  close.ncdf(nc)
  
  lonlim <- c(lonmin, lonmax)
  latlim <- c(latmin, latmax)
  
  ### LOOP PARA GRAFICAR CADA INSTANTE ###
#   x11()
# png(filename= paste0("vertical_distribution_",simulation,rele_depth  ,".png") , width = 700 , height = 750 , res=120) 
  for (i in 1:nbtime){
    snapchat = subset(df, df$drifter == i)
    if (i == 1){
#       plot(snapchat, type="n", cex=0.1, xlim=c(0,nbtime), ylim=c(min(df$depth),0))
      plot(snapchat, type="n", cex=0.1, xlim=c(0,nbtime), ylim=c(-250,0), axes=FALSE, xlab="time in days")
#       axis(1, at=1:55, labels=seq(0,55*12-12, 12))
      axis(1, at=1:55, labels=seq(0,27, 0.5))
      axis(2, ylim=c(-250,0))
           
           
#            xlim=c(0,nbtime), ylim=c(-250,0))
      points(snapchat, cex=0.1)
    }else{
      points(snapchat, cex=0.1)
    }    
  }
# dev.off()
}
