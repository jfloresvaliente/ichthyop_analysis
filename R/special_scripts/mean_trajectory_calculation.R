#===============================================================================
# Name   : -----
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
library(nlme)
dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/'

index_paths <- read.table(file = paste0(out_path, 'daily_lobos_sechura_index_paths.csv'), sep = ',', header = T)
simu <- 'daily_lobos_sechura'

# Path index
# path1 <- subset(index_paths, index_paths$Path == 1)
# path2 <- subset(index_paths, index_paths$Path == 2)
# path3 <- subset(index_paths, index_paths$Path == 3)

df_month <- NULL
for(i in 1:12){
  csvfile <- paste0(dirpath,'traj_', simu, i, '.csv')
  df <- read.table(csvfile, header = T)
  df_month <- rbind(df_month, df)
  print(csvfile)
}

############ ############ Path 1 ############ ############
month_mean <- NULL
for(i in 1:12){
  index <- subset(index_paths, index_paths$Month == i & index_paths$Path == 1)
  index <- index[,2]
  
  df2 <- subset(df_month, df_month$Month == i)
  df2 <- subset(df2, df2$Drifter %in% index)
  
  days <- as.numeric(levels(factor(df2$Day)))
  
  day_mean <- NULL
  for(j in days){
    df3 <- subset(df2, df2$Day == j)
    lon <- mean(df3$Lon)
    lat <- mean(df3$Lat)
    depth <- mean(df3$Depth)
    
    dat <- c(lon,lat, depth, i,j)
    day_mean <- rbind(day_mean, dat)
  }
  month_mean <- rbind(month_mean, day_mean)
}

colnames(month_mean) <- c('Lon', 'Lat', 'Depth', 'Month', 'Day')
month_mean <- as.data.frame(month_mean)

lon <- tapply(X = month_mean$Lon, FUN = mean, INDEX = list(c(month_mean$Day)))
lat <- tapply(X = month_mean$Lat, FUN = mean, INDEX = list(c(month_mean$Day)))
depth <- tapply(X = month_mean$Depth, FUN = mean, INDEX = list(c(month_mean$Day)))
drifter <- rep(1, times = 28)

path1 <- as.data.frame(cbind(drifter,lon, lat, depth))
colnames(path1) <- c('Drifter','Lon', 'Lat', 'Depth')
# plot_traj_ggmap_depth(df = path1, color.limits = c(-55,0), pngfile = NULL, texts = '')


############ ############ Path 2 ############ ############
month_mean <- NULL
for(i in 1:12){
  index <- subset(index_paths, index_paths$Month == i & index_paths$Path == 2)
  index <- index[,2]
  
  df2 <- subset(df_month, df_month$Month == i)
  df2 <- subset(df2, df2$Drifter %in% index)
  
  days <- as.numeric(levels(factor(df2$Day)))
  
  day_mean <- NULL
  for(j in days){
    df3 <- subset(df2, df2$Day == j)
    lon <- mean(df3$Lon)
    lat <- mean(df3$Lat)
    depth <- mean(df3$Depth)
    
    dat <- c(lon,lat, depth, i,j)
    day_mean <- rbind(day_mean, dat)
  }
  month_mean <- rbind(month_mean, day_mean)
}

colnames(month_mean) <- c('Lon', 'Lat', 'Depth', 'Month', 'Day')
month_mean <- as.data.frame(month_mean)

lon <- tapply(X = month_mean$Lon, FUN = mean, INDEX = list(c(month_mean$Day)))
lat <- tapply(X = month_mean$Lat, FUN = mean, INDEX = list(c(month_mean$Day)))
depth <- tapply(X = month_mean$Depth, FUN = mean, INDEX = list(c(month_mean$Day)))
drifter <- rep(2, times = 28)

path2 <- as.data.frame(cbind(drifter,lon, lat, depth))
colnames(path2) <- c('Drifter','Lon', 'Lat', 'Depth')
# plot_traj_ggmap_depth(df = path2, color.limits = c(-55,0), pngfile = NULL, texts = '')

############ ############ Path 3 ############ ############
# month_mean <- NULL
# for(i in 1:12){
#   index <- subset(index_paths, index_paths$Month == i & index_paths$Path == 3)
#   index <- index[,2]
#   
#   df2 <- subset(df_month, df_month$Month == i)
#   df2 <- subset(df2, df2$Drifter %in% index)
#   
#   days <- as.numeric(levels(factor(df2$Day)))
#   
#   day_mean <- NULL
#   for(j in days){
#     df3 <- subset(df2, df2$Day == j)
#     lon <- mean(df3$Lon)
#     lat <- mean(df3$Lat)
#     depth <- mean(df3$Depth)
#     
#     dat <- c(lon,lat, depth, i,j)
#     day_mean <- rbind(day_mean, dat)
#   }
#   month_mean <- rbind(month_mean, day_mean)
# }
# 
# colnames(month_mean) <- c('Lon', 'Lat', 'Depth', 'Month', 'Day')
# month_mean <- as.data.frame(month_mean)
# 
# lon <- tapply(X = month_mean$Lon, FUN = mean, INDEX = list(c(month_mean$Day)))
# lat <- tapply(X = month_mean$Lat, FUN = mean, INDEX = list(c(month_mean$Day)))
# depth <- tapply(X = month_mean$Depth, FUN = mean, INDEX = list(c(month_mean$Day)))
# drifter <- rep(3, times = 28)
# 
# path3 <- as.data.frame(cbind(drifter,lon, lat, depth))
# colnames(path3) <- c('Drifter','Lon', 'Lat', 'Depth')
# plot_traj_ggmap_depth(df = path3, color.limits = c(-55,0), pngfile = NULL, texts = '')


############ ############ Path 1-2-3 ############ ############

# paths <- rbind(path1, path2, path3)
paths <- rbind(path1, path2)
out_file <- paste0(out_path, simu,'_mean_paths')
write.table(x = paths, file = paste0(out_file, '.csv'), row.names = F, sep = ',')

plot_traj_ggmap_depth <- function(df, color.limits, pngfile = NULL){
  #============ explanation of function arguments ============#
  
  # df = Data frame with the form ['Drifter','Lon','Lat','Depth','Year','Month','ReleaseDepth','Age']
  # color.limits = min and max values of colors in the the plot
  # pngfile = file name to save the plot. If NULL, plot and show in graphic device
  # texts = Texts to be show like legend, If '', then, legend is empty
  
  #============ explanation of function arguments ============#
  
  library(ggmap)
  library(fields)
  
  # Domain (by default) for plots, you can change this geographical domain
  lonmin  <- -82
  lonmax  <- -80
  latmin  <- -5.5
  latmax  <- -6.5
  x.axis <- c(-82, -80.15)    # X limits of plot
  y.axis <- c(-7, -5.15)      # Y limits of plot
  
  x <- c(-80.80290+0.027, -80.74779+0.027, -81.35225-0.027) # x position of legend in the plot
  y <- c(-6.395314, -6.541144, -5.488812) # y position of legend in the plot
  texts <- c(1:3)
  t.legend <- data.frame(x,y,texts)
  
  mymap <- get_map(location = c(lon = (lonmin + lonmax) / 2, lat = (latmin + latmax) / 2),
                   zoom = 8, maptype = 'satellite', color='bw')
  map   <- ggmap(mymap)
  map <- map +
    # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = 1.5) +
    # geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Depth), size = .1) +
    geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Depth), size = 1) +
    scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = color.limits, expression(Depth)) +
    labs(x = 'Longitude (W)', y = 'Latitude (S)') +
    # geom_text(data = t.legend, aes(x = x, y = y, label = texts), size = 7, colour = 'yellow', show.legend  = F) +
    coord_fixed(xlim = x.axis, ylim = y.axis, ratio = 2/2) +
    theme(axis.text.x  = element_text(face='bold', color='black',
                                      size=15, angle=0),
          axis.text.y  = element_text(face='bold', color='black',
                                      size=15, angle=0),
          axis.title.x = element_text(face='bold', color='black',
                                      size=15, angle=0),
          axis.title.y = element_text(face='bold', color='black',
                                      size=15, angle=90),
          legend.text  = element_text(size=15),
          legend.title = element_text(size=15))
  
  print(pngfile); flush.console()
  if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map
}

paths <- paths
pngfile <- paste0(out_file, '.png')
plot_traj_ggmap_depth(df = paths, color.limits = c(-30,0), pngfile = pngfile)

