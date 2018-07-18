plot_traj_Ichthyop_v3_ggmap <- function(ncfile, firstdrifter = 1, lastdrifter = 1, firsttime = 1, lasttime = 1, longitudemin, longitudemax, latitudemin, latitudemax, zoom = 6, pngfile = NULL){

	library(ncdf4)
	library(ggmap)
	library(marmap)
	library(sp)

	# The minimum and maximum longitudes and latitudes for the plots, e.g.
        # New-Caledonia
        #longitudemin <- 166.1  longitudemax <- 166.5  latitudemin <- -22.5  latitudemax <- -22.1        
	# Benguela
        #longitudemin <- 15.0  longitudemax <- 20.0  latitudemin <- -35.0  latitudemax <- -30.0
	# Gulg Guinea
        #longitudemin <- -12.3333  longitudemax <- 11.7333  latitudemin <- -3.9826  latitudemax <- 8.0550
	# Peru
        #longitudemin <- 276.5 - 360  longitudemax <- 280.5 - 360  latitudemin <- -8.0  latitudemax <- -4.0
	# Indian Ocean
        #longitudemin <- 20.0  longitudemax <- 120.0  longitudemin <- 35.0  longitudemax <- 55.0  latitudemin <- -20.0  latitudemax <- 0.0
	# Med
        #longitudemin <- 2.0  longitudemax <- 10.0  latitudemin <- 41.0  latitudemax <- 44.5
	
	nbcolor <- 10
	
	#ncdf
        #nc <- open.ncdf(ncfile)
	#ncdf4
        nc <- nc_open(ncfile)
        
        nbdrifter <- lastdrifter - firstdrifter + 1
        nbtime <- lasttime - firsttime + 1
	      drifter <- rep(seq(firstdrifter, lastdrifter), each = nbtime)
	
	#ncdf
	#time <- rep(get.var.ncdf(nc, 'time', firsttime, nbtime), nbdrifter)
	#lon <- as.vector(t(get.var.ncdf(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #lat <- as.vector(t(get.var.ncdf(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #depth <- as.vector(t(get.var.ncdf(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #mortality <- as.vector(t(get.var.ncdf(nc, 'mortality', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #ncdf4
        time <- rep(ncvar_get(nc, 'time', firsttime, nbtime), nbdrifter)
	time <- (time - time[1])/86400
	lon <- as.vector(t(ncvar_get(nc, 'lon', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        lat <- as.vector(t(ncvar_get(nc, 'lat', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #depth <- as.vector(t(ncvar_get(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        mortality <- as.vector(t(ncvar_get(nc, 'mortality', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #temp <- as.vector(t(ncvar_get(nc, 'temp', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #releasezone <- rep(ncvar_get(nc, 'release_zone', firstdrifter, nbdrifter), each = nbtime)
        #recruitmentzone <- as.vector(t(ncvar_get(nc,'zone',c(2,firstdrifter,firsttime),c(1,nbdrifter,nbtime))))
        
        pts <- matrix(c(lon, lat), nrow = nbtime * nbdrifter, ncol = 2)  
        dist <- spDists(pts, longlat = TRUE, segments = TRUE)
        distance <- c(0, dist)

        # Ichthyop v2
        #mortality <- as.vector(t(get.var.ncdf(nc, 'death', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #depth <- as.vector(t(get.var.ncdf(nc, 'depth', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #releasezone <- rep(get.var.ncdf(nc, 'release_zone', c(firstdrifter), c(nbdrifter)), each = nbtime)
        # Ichthyop v2 warning problem if release and recruitment zones overlap
        #releasezone <- rep(get.var.ncdf(nc, 'zone', c(firstdrifter,1), c(nbdrifter,1)), each = nbtime)
        #length <- as.vector(t(get.var.ncdf(nc, 'length', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #stage <- as.vector(t(get.var.ncdf(nc, 'stage', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        #temp <- as.vector(t(get.var.ncdf(nc, 'temp', c(firstdrifter, firsttime), c(nbdrifter, nbtime))))
        
        #recruitmentzonenb <- 1
        #recruitedzone <- as.vector(t(get.var.ncdf(nc, 'recruited_zone', c(recruitmentzonenb, firstdrifter, firsttime), c(1, nbdrifter, nbtime))))
        # Ichthyop v2
        #recruitedzone <- as.vector(t(get.var.ncdf(nc, 'recruited', c(recruitmentzonenb, firstdrifter, firsttime), c(1, nbdrifter, nbtime))))
        
        #df <- data.frame(drifter, lon, lat, mortality, depth, releasezone, recruitedzone, length, stage, temp)
        #df <- data.frame(drifter, time, lon, lat, depth, mortality, temp, distance)
        #df <- data.frame(drifter, time, lon, lat, depth, mortality, temp, distance, recruitmentzone)
        #df <- data.frame(drifter, time, lon, lat, depth, mortality, releasezone, temp, distance)
        df <- data.frame(drifter, time, lon, lat, mortality, distance)
        
        # Put distance at first time to 0 for all drifters
        df$distance[which(df$time==time[firsttime])] <- 0
        
        # To keep only "alive" points
        df <- df[which(df$mortality==0),]
        # To keep only drifters with "alive" points
        #df <- df[which(!df$drifter%in%unique(df$drifter[which(df$mortality!=0)])),]
        # To keep only drifters in recruitment zone 0 at lasttime
        #df <- df[which(df$drifter%in%(df[which(df$time==time[lasttime] & df$recruitmentzone==0),]$drifter)),]
        # Other tests
        #df <- df[which(df$recruitedzone!=0),]
        #df <- df[which(df$releasezone==0),]
        #df <- df[which(df$lon>5),]
        df <- df[which(!df$drifter%in%unique(df$drifter[which(df$distance>0 & df$distance<0.1)])),]
        #print(dim(df)[1]/nbtime)
        # Thau
        #df <- df[which(df$drifter%in%(df$drifter[which(df$time==time[firsttime] & df$lon>3.5 & df$lon<3.8 & df$lat>43.28 & df$lat<43.5)])),]
        # Salses
        #df <- df[which(df$drifter%in%(df$drifter[which(df$time==time[firsttime] & df$lon>3 & df$lon<3.2 & df$lat>42.75 & df$lat<42.95)])),] 
        
        #ncdf
        #close.ncdf(nc)
        #ncdf4
        nc_close(nc)
        	
	# Google map ...
	mymap <- get_map(location = c(lon = (longitudemin + longitudemax) / 2, lat = (latitudemin + latitudemax) / 2), zoom = zoom, maptype = 'hybrid')
        map <- ggmap(mymap)
        
        # ... or NOAA bathy
        #mymap <- getNOAA.bathy(longitudemin, longitudemax, latitudemin, latitudemax, keep = TRUE, resolution = 8)
	#map <- autoplot(mymap, geom = 'raster') + scale_fill_etopo(guide = 'none')
        # geom = c('raster', 'contour'), colour='white', size=0.1   adds contours to bathy
	
	# Trajectories
        map <- map + geom_point(data = df, aes(x = lon, y = lat, colour = time), size = .1) + geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = time), size = .1) + scale_colour_gradientn(colours = rainbow(nbcolor))
                  
        # Plot of mean drifter
        #mean_lon <- tapply(df$lon, df$time, mean)
        #mean_lat <- tapply(df$lat, df$time, mean)
        #mean_time <- tapply(df$time, df$time, mean)
        #mean_drifter <- data.frame(mean_time, mean_lon, mean_lat)
        #map <- map + geom_point(data = mean_drifter, aes(x = mean_lon, y = mean_lat), colour = 'white', size = .9) + geom_point(data = mean_drifter, aes(x = mean_lon, y = mean_lat, colour = mean_time), size = .5)
           
        # Plot of trajectories from csv files
        #drifter <- read.csv('Drifter_Julien.csv')
        #map <- map + geom_point(data = drifter, aes(x = lon, y = lat), size = .9) + geom_point(data = drifter, aes(x = lon, y = lat, colour = as.numeric(strptime(paste(date, time), '%Y-%m-%d %H:%M:%S') - as.numeric(strptime('1992-10-05', '%Y-%m-%d')))), size = .5)
        
        shark <- read.csv('Sharks/104662.csv')
        shark$date <- (as.numeric(strptime(shark$date, format = '%d/%m/%Y')) - as.numeric(strptime(shark$date[1], format = '%d/%m/%Y')))/86400
        map <- map + geom_point(data = shark, aes(x = Longitude, y = Latitude), colour = 'white', size = 1.5) + geom_path(data = shark, aes(x = Longitude, y = Latitude), colour = 'white', size = .8)  + geom_point(data = shark, aes(x = Longitude, y = Latitude, colour = date), size = 1) + geom_path(data = shark, aes(x = Longitude, y = Latitude,  colour = date), size = .5)
        
        
        shark_new <- read.csv('Sharks/104662_new.csv')
        Sys.setlocale('LC_TIME', 'C')
        shark_new$date <- (as.numeric(strptime(shark_new$Date, format = '%d-%b-%Y %H:%M:%S')) - as.numeric(strptime(shark_new$Date[1], format = '%d-%b-%Y %H:%M:%S')))/86400
        map <- map + geom_point(data = shark_new, aes(x = Most.Likely.Longitude, y = Most.Likely.Latitude), colour = 'black', size = 1.5) + geom_path(data = shark_new, aes(x = Most.Likely.Longitude, y = Most.Likely.Latitude), colour = 'black', size = .8)  + geom_point(data = shark_new, aes(x = Most.Likely.Longitude, y = Most.Likely.Latitude, colour = date), size = 1) + geom_path(data = shark_new, aes(x = Most.Likely.Longitude, y = Most.Likely.Latitude,  colour = date), size = .5)
        
        #fad <- read.csv('Sharks/2012_04_13_03_XXhYY_2ndMonth_51d.csv')
        #map <- map + geom_point(data = fad, aes(x = lon, y = lat), size = 2) + geom_point(data = fad, aes(x = lon, y = lat, colour = as.numeric(strptime(date, format = '%Y-%m-%d') - as.numeric(strptime('1992-10-05', format = '%Y-%m-%d')))), size = 1)
        
        #fad <- read.csv('Sharks/2012_04_13_01_XXhYY_2ndMonth_51d.csv')
        #map <- map + geom_point(data = fad, aes(x = lon, y = lat), size = 2) + geom_point(data = fad, aes(x = lon, y = lat, colour = as.numeric(strptime(date, format = '%Y-%m-%d') - as.numeric(strptime('1992-10-05', format = '%Y-%m-%d')))), size = 1)
        
        map + labs(x = 'Longitude (°E)', y = 'Latitude (°N)')
	#length(df$drifter)/nbtime
        #+ theme(axis.text = element_text(size = 14), axis.title = element_text(size=16))
        #ggsave(filename='Sharks/plot_traj_Ichthyop_v3_ggmap_104663_path.png')
        
        #ggplot() + geom_histogram(data = df, aes(distance, ..density..), colour = 'black', fill = 'red', alpha = 0.5) + geom_histogram(data = shark, aes(DistanceKm, ..density..), colour = 'black', fill = 'blue', alpha = 0.5) + labs(x = 'Distance (km)', y = 'Density')
        if(!is.null(pngfile)) ggsave(filename = pngfile) else map
}