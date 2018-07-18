source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'

# Plot sample of trayectories
num_sample <- 100

winds <- 'daily'
simu <- 'sechura'

index_month <- NULL
month_mean <- NULL
for(i in 2:12){
  csv_file <- paste0(dirpath, 'traj_', winds, '_', simu, i, '.csv')
  dat <- read.table(csv_file, header = T, sep = '')
  print(csv_file)
  
  # # Serie promedio antes de sacar las 100 muestras
  # days <- as.numeric(levels(factor(dat$Day)))
  # day_mean <- NULL
  # for(j in seq_along(days)){
  #   df <- subset(dat, dat$Day == j)
  #   lon <- mean(df$Lon)
  #   lat <- mean(df$Lat)
  #   depth <- mean(df$Depth)
  #   dat2 <- c(i, lon, lat, depth, j)
  #   day_mean <- rbind(day_mean, dat2)
  # }
  # month_mean <- rbind(month_mean, day_mean)
  # #
  
  # index_sample <- sample(levels(as.factor(dat$Drifter)), size = num_sample)
  # dat <- subset(dat, dat$Drifter %in% index_sample)
  # index_month <- cbind(as.numeric(index_sample), index_month)
  
  # Serie promedio despues de sacar las 100 muestras
  days <- as.numeric(levels(factor(dat$Day)))
  day_mean <- NULL
  for(j in seq_along(days)){
    df <- subset(dat, dat$Day == j)
    lon <- mean(df$Lon)
    lat <- mean(df$Lat)
    depth <- mean(df$Depth)

    dat2 <- c(i, lon, lat, depth, j)
    day_mean <- rbind(day_mean, dat2)
  }
  month_mean <- rbind(month_mean, day_mean)
  
  #
  pngfile <- paste0('F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/',
                     winds,simu,i,'.png')
  pngfile2 <- paste0('F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/','days_',
                    winds,simu,i,'.png')
 
  # plot_traj_ggmap_depth(df = dat, color.limits = c(-60,0), pngfile = pngfile)
  # plot_traj_ggmap_day  (df = dat, color.limits = c(1,28) , pngfile = pngfile2)
}

write.table(x = index_month,
            file = paste0('F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/',winds,simu,'.csv'),
            row.names = F, col.names = F, sep = ',')

colnames(month_mean) <- c('Drifter', 'Lon', 'Lat','Depth','Day')
month_mean <- as.data.frame(month_mean)
df <- subset(month_mean, month_mean$Drifter == 6)
pngfile3 <- paste0('F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/','meanPath_',
                   winds,simu,'.png')

# df <- sec_lob
## Plot only one trayectorie
library(ggmap)
library(fields)

# Domain (by default) for plots, you can change this geographical domain
 # LOBOS
# lonmin  <- -82
# lonmax  <- -80
# latmin  <- -6
# latmax  <- -7
# x.axis <- c(-81, -80.5)    # X limits of plot
# y.axis <- c(-6.7, -6.2)      # Y limits of plot

 # SECHURA
lonmin  <- -82
lonmax  <- -80
latmin  <- -6
latmax  <- -7
x.axis <- c(-81.5, -80.5)    # X limits of plot
y.axis <- c(-6, -5.2)      # Y limits of plot

# x <- c(-81.75) # x position of legend in the plot
# y <- c(-6.75)  # y position of legend in the plot
# t.legend <- data.frame(x,y,texts)
color.limits <- c(0,28)

mymap <- get_map(location = c(lon = -81, lat = -5.5),
                 zoom = 8, maptype = 'satellite', color='bw')
map   <- ggmap(mymap)
map <- map +
  # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = .075) +
  geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Day), size = .7) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = color.limits, expression(Day)) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)') +
  # geom_text(data = t.legend, aes(x = x, y = y, label = texts), size = 5, colour = 'yellow', show.legend  = F) +
  coord_fixed(xlim = x.axis, ylim = y.axis, ratio = 2/2)+
  theme(axis.text.x = element_text(face='bold', color='black', 
                                   size=15, angle=0),
        axis.text.y = element_text(face='bold', color='black', 
                                   size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black', 
                                    size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black', 
                                    size=15, angle=90),
        legend.text  = element_text(size=15),
        legend.title = element_text(size=15))

print(pngfile); flush.console()
if(!is.null(pngfile3)) ggsave(filename = pngfile3, width = 9, height = 9) else map

