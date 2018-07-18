plot_traj_data_gif_jorge <- function(dataset,pngfile){
  
  library(ncdf4)
  library(ggmap)
  library(fields)
  
  df2 = dataset
  timer <- rep(1:28, times = max(df2[,1]))
  df2 <- cbind(df2, timer)
  
  # The minimum and maximum longitudes and latitudes for the plots
  # Northern Peru
  lonmin  <- -82
  lonmax  <- -80
  latmin  <- -5.5
  latmax  <- -6.5
  
  x.axis <- c(-82, -80.15)    # X limits of plot
  y.axis <- c(-7, -5.15)      # Y limits of plot
  
  nbcolor <- 10
  
  lonlim <- c(lonmin, lonmax)
  latlim <- c(latmin, latmax)
  
  for(i in 1:28){
    
    df <- subset(df2, df2$timer == i)
    mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
                     zoom = 8, maptype = 'satellite', color='bw')
    map   <- ggmap(mymap)
    
    map <- map +
      geom_point(data = df, aes(x = lon, y = lat, colour = depth), size = .1) +
      # geom_path(data = df, aes(group = drifter, x = lon, y = lat, colour = depth), size = .2) +
      scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = color.limits, expression(Depth)) +
      labs(x = 'Longitude (°W)', y = 'Latitude (°S)') +
      # geom_text(data = t.legend, aes(x = x, y = y, label = texts), size = 5, colour = 'yellow', show_guide  = F) +
      coord_fixed(xlim = x.axis, ylim = y.axis, ratio = 2/2)
    
    
    # map    <- map + geom_point(data = df, aes(x = lon, y = lat, colour = depth), size = .4) + 
    #   scale_colour_gradientn(colours = rainbow(nbcolor), limits=c(-65,0), expression(Depth[m]))
    # map + labs(x = 'Longitude (°W)', y = 'Latitude (°S)')
    # # ggsave(paste0('time', i,'_',filename), width = 9, height = 9)
    if(!is.null(pngfile)) ggsave(filename = paste0(pngfile,'_',i,'.png'), width = 9, height = 9) else map
    print(paste0(pngfile,'_',i)); flush.console()
  }
}

