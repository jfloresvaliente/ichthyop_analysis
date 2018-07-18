compute_connectivity_Ichthyop_v3_TP <- function(){

	library(ncdf4)
	library(XML)
	library(fields)
	library(spam)

  old.path <- 'G:/ICHTHYOP/ichthyop-3.2/cfg/'
  new.path <- 'G:/ICHTHYOP/ichthyop-3.2/cfg/'
  # The directory that contains the series of netcdf input files
	#dirpath <- 'C:\\Users\\Christophe\\IRD\\Ichthyop\\Ichthyop3.2b\\ichthyop-3.2b\\ichthyop-3.2b\\output\\TP2\\'
  dirpath <- 'G:/ICHTHYOP/ichthyop-3.2/output/'
	
	# In case one wishes to consider only a subset of all drifters
	# Index of the first and last drifters
	firstdrifter <- 1
	lastdrifter <- 1000

	# The time record at which to compute connectivity
	computeattime <- 61
	
	# The number of release zones
	nbreleasezones <- 3
	# The number of destination zones
	nbdestinationzones <- 3

	# The maximum value of the transport success plot (in %)
	ymax <- 10

	# An inner function that computes recruitment for one file
	compute_recruitment_file <- function(filename){

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
		# Gets the value of release zone for all drifters
		releasezone <- ncvar_get(nc,'zone',c(1,firstdrifter,1),c(1,nbdrifter,1))
		releasezone <- releasezone +1
		releasezonefactor <- factor(releasezone,levels=1:nbreleasezones)
		# Gets the value of zone at computeattime for all drifters
		destinationzone <- ncvar_get(nc,'zone',c(2,firstdrifter,computeattime),c(1,nbdrifter,1))
		destinationzone <- destinationzone +1
		destinationzonefactor <- factor(destinationzone,levels=0:nbdestinationzones)
		# Calculates the number of individuals transported from every release zone to every destination zone
		connectivitymatrix <- table(releasezonefactor,destinationzonefactor)[,-1]
		# Calculates the number of released from every release zone
		releasenb <- table(releasezonefactor)
		nc_close(nc)
		# returns a collage of columns, i.e., a table, that looks like the following
		# releasenb1 recruitnb1 1 year day depth
		# releasenb2 recruitnb2 2 year day depth
		# releasenb3 recruitnb3 3 year day depth
		# ...
		return(cbind(releasenb,connectivitymatrix,seq(1,nbreleasezones),rep(yearday[1],nbreleasezones),
			rep(yearday[2],nbreleasezones),rep(depth,nbreleasezones)))
	}


	# An inner function that computes statistics of recruitment for a given factor
	compute_recruitment_stats <- function(released,recruited,factor){
		mean <- tapply(recruited,factor,sum)/tapply(released,factor,sum)
		var <- tapply(recruited^2,factor,sum)/tapply(released^2,factor,sum)-mean^2
		sem <- sqrt(var/table(factor))
		return(cbind(mean,sem))
	}


	# Gets filenames of all files in the dirpath directory 
	filenames <- list.files(path = dirpath, full.names = TRUE, pattern = '.nc')
	# Computes recruitment for the first file 
	dataset <- compute_recruitment_file(filenames[1])
	# Computes recruitment for all subsequent files 
	if (length(filenames) >1){
		for (i in seq(2, length(filenames))){
			# Shows name of opened file on the console
			print(filenames[i])
			flush.console()
			# Computes recruitment data for file i
			data <- compute_recruitment_file(filenames[i])
			# Adds recruitment data computed for file i to those computed from all previous files
			dataset <- rbind(dataset,data)
		}
	}

	print(dataset)
	return(dataset)
	# Makes the corresponding plots
	par(mfrow=c(2,2))

	# Computes stats (mean, std error of the mean) of release to destination connectivity
	dataarea_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,nbdestinationzones+2]))
	dataarea_mean=dataarea_stats[,1]
	dataarea_sem=dataarea_stats[,2]
	areaplot=barplot(100*dataarea_mean,xlab='Release area',ylab='Connectivity (%)',ylim = c(0,ymax),main='Destination area 1')
	arrows(areaplot,100*(dataarea_mean+dataarea_sem),areaplot,100*(dataarea_mean-dataarea_sem),angle=90,code=3,length=0.05)
	if (nbdestinationzones > 1){
		for (i in seq(2, nbdestinationzones )){	
			dataarea_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,1+i]),as.numeric(dataset[,nbdestinationzones+2]))
			dataarea_mean=cbind(dataarea_mean,dataarea_stats[,1])
			dataarea_sem=cbind(dataarea_sem,dataarea_stats[,2])
			areaplot=barplot(100*dataarea_stats[,1],xlab='Release area',ylab='Connectivity (%)',ylim = c(0,ymax),main=paste('Destination area',i))
			arrows(areaplot,100*(dataarea_stats[,1]+dataarea_stats[,2]),areaplot,100*(dataarea_stats[,1]-dataarea_stats[,2]),angle=90,code=3,length=0.05)
		}
	print(100*dataarea_mean)
	image.plot(1:nbreleasezones,1:nbdestinationzones,100*dataarea_mean,col=tim.colors(256),xlab='Release area',ylab='Destination area',main='Mean connectivity (%)')
	#print(100*dataarea_sem)
	#image.plot(1:nbreleasezones,1:nbdestinationzones,100*dataarea_sem,col=tim.colors(256),xlab='Release area',ylab='Destination area',main='Standard error of the mean (%)')
	}
}