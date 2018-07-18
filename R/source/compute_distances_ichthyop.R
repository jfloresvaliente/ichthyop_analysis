compute_distances_Ichthyop_v3_TP <- function(){

	library(sp)
	library(ncdf4)
	library(XML)

  old.path <- 'G:/ICHTHYOP/ichthyop-3.2/cfg/'
  new.path <- 'G:/ICHTHYOP/ichthyop-3.2/cfg/'
  # The directory that contains the series of netcdf input files
  #dirpath <- 'C:\\Users\\Christophe\\IRD\\Ichthyop\\Ichthyop3.2b\\ichthyop-3.2b\\ichthyop-3.2b\\output\\TP2\\'
  dirpath <- 'G:/ICHTHYOP/ichthyop-3.2/output/'
  
	# In case one wishes to consider only a subset of all drifters
	# Index of the first and last drifters
	firstdrifter <- 1
	lastdrifter <- 1000

	# The time record at which to compute distances
	computeattime <- 61
	
	
	# An inner function that computes dispersal distance for one file
	compute_distances_file <- function(filename){

		# An inner function that computes year and day from time in seconds
		compute_yearday <- function(time){
			nbdays = 1+time/86400
			year = 1+as.integer(nbdays/360)
			day = as.integer(nbdays-360*(year-1))
			return(c(year,day))
		}

		nc <- nc_open(filename)

		# Gets the value of time of release
		t0 <- ncvar_get(nc,'time',1,1)

		# Computes year and day of release
		yearday <- compute_yearday(t0)

		#Reads zonefile, gets the values of min and max depth of release and concatenates them
		#Warning all release zones should have the same min and max depths as the script returns the values found for the first zone only
		filezone <- ncatt_get(nc,0,'release.zone.zone_file')$value
		# filezone <- ncatt_get(nc,0,'release.bottom.zone_file')$value ## if you release particles from BOTTOM
		filezone <- gsub(pattern = old.path, replacement = new.path, filezone)
		mindepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['upper_depth']])
		maxdepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[['zone']][['thickness']][['lower_depth']])
		depth <- paste(mindepth,maxdepth,sep='-')
		nbdrifter <- lastdrifter-firstdrifter+1
		
		# Gets latitude and longitude of release for all drifters
		releaselon <- ncvar_get(nc,'lon',c(firstdrifter,1),c(nbdrifter,1))
		releaselat <- ncvar_get(nc,'lat',c(firstdrifter,1),c(nbdrifter,1))

		# Gets latitude and longitude at computeattime for all drifters
		finallon <- ncvar_get(nc,'lon',c(firstdrifter,computeattime),c(nbdrifter,1))
		finallat <- ncvar_get(nc,'lat',c(firstdrifter,computeattime),c(nbdrifter,1))

		# Calculates dispersal distances
		d <- vector()
		for (i in 1 : nbdrifter) {
		pts <- matrix(c(releaselon[i],releaselat[i]),nrow=1,ncol=2)
		pt  <- as.numeric(c(finallon[i],finallat[i]))
		d[i] <- spDistsN1(pts, pt, longlat = T)
		}

		nc_close(nc)
		return(d)
	}

	# Rprof('Rprof.out',interval=0.01)

	# Gets filenames of all files in the dirpath directory 
	filenames <- list.files(path = dirpath, full.names = TRUE, pattern = '.nc')

	# Computes distances for the first file 
	dataset <- compute_distances_file(filenames[1])

	# Computes recruitment for all subsequent files 
	if (length(filenames) >1){
		for (i in seq(2, length(filenames))){

			# Shows name of opened file on the console
			print(filenames[i])
			flush.console()

			# Computes distances data for file i
			data <- compute_distances_file(filenames[i])

			# Adds recruitment data computed for file i to those computed from all previous files
			dataset <- rbind(dataset,data)
		}
	}

	# Makes the corresponding plots
	par(mfrow=c(3,4))
	for (i in 1 : length(filenames)) {
		hist(dataset[i,],breaks=50,xlab='Dispersal distance (km)',ylab='Frequency',main=paste('File',i),
		xlim = c(0,500),ylim=c(0,120),col='gray')
	}

  Rprof(NULL)
  summaryRprof('Rprof.out')

}