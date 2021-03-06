plot_traj_Ichthyop_v3 <- function(){

	library(ncdf)
	library(maps)

	# The netcdf input file
	ncfile <- 'C:\\Users\\Christophe\\IRD\\Ichthyop\\Ichthyop_stable-3\\stable-3\\stable-3\\output\\roms3d_ichthyop-run201206051442.nc'

	# In case one wishes to consider only a subset of all drifters
	# Index of the first and last drifters
	firstdrifter <- 1
	lastdrifter <- 100

	# In case one wishes to consider only a subset of all time records
	# Index of the first and last time records
	firsttime <- 1
	lasttime <- 601

	# The minimum and maximum longitudes and latitudes for the plots
	lonmin <- 11.6
	lonmax <- 27.4
	latmin <- -38.8
	latmax <- -27.8

	nc <- open.ncdf(ncfile)

	nbtime <- lasttime-firsttime
	lonlim <- c(lonmin,lonmax)
	latlim <- c(latmin,latmax)

	for (i in seq(firstdrifter,lastdrifter)){
		loni <- get.var.ncdf(nc,'lon',c(i,firsttime),c(1,nbtime))
		lati <- get.var.ncdf(nc,'lat',c(i,firsttime),c(1,nbtime))
		plot(loni[1],lati[1],type='p',pch=20,xlim=lonlim,ylim=latlim,xlab='',ylab='')
		par(new=TRUE)
		plot(loni,lati,type='l',col='red',xlim=lonlim,ylim=latlim,xlab='',ylab='')
		par(new=TRUE)
	}

	close.ncdf(nc)

	map('world',xlim=lonlim,ylim=latlim,add=TRUE)
}