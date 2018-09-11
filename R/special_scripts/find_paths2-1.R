#=============================================================================#
# Name   : find_paths2-1 : Especial para rutas de transporte
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Paso 2: Busqueda por seleccion de particulas
# URL    : 
#=============================================================================#
library(ggmap)
library(fields)
library(ncdf4)
library(fields)

nc <- nc_open('F:/ichthyop_output_analysis/RUN2/cfg/newperush_grd.nc')
mask <- ncvar_get(nc, 'mask_rho')
lon <- ncvar_get(nc, 'lon_psi')-360
lat <- ncvar_get(nc, 'lat_psi')

# # Sechura coords
# ylimmap <- c(-6.25,-5)
# xlimmap <- c(-82,-80.7)

# # Lobos coords
# ylimmap <- c(-7.2,-5.8)
# xlimmap <- c(-81.5,-80.2)

# Sechura - Lobos
ylimmap <- c(-7.2,-5)
xlimmap <- c(-81.5,-80.2)

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'C:/Users/ASUS/Desktop/ich/daily_lobos_sechura/'
winds <- c('daily')
simu <- paste0(winds,'_lobos_sechura')

df <- NULL
drifin <- 0
for(month in 1:12){
  csvfile <- paste0(dirpath,'traj_', simu, month, '.csv')
  dfsub <- read.table(csvfile, header = T, sep = ';')
  if(dfsub$Lon[1] == 999) next()
  drifin <- drifin + max(dfsub$Drifter)
  df <- rbind(df, dfsub)
}
df$Drifter <- rep(1:drifin, each = 28)
print(paste('# Inicial de Particulas:',length(levels(factor(df$Drifter)))))


# pLOT CON ITERATOR MAP
x11()
day_interval <- c(1:5, seq(10,25,5), 28)
for(i in day_interval){
  sub_day <- subset(df, df$Day == i)
  
  image.plot(lon, lat, mask, xlim = xlimmap, ylim = ylimmap)
  points(sub_day$Lon, sub_day$Lat, pch = 20, cex = .1)
  legend('topleft', legend = paste('Day', i), bty = 'n')
  
  xy <- locator(n = 4, type = 'p', col = 'yellow')
  xy <- cbind(xy$x, xy$y)
  
  maxX <- xy[4,1]
  minX <- xy[2,1]
  maxY <- xy[1,2]
  minY <- xy[3,2]
  
  sub1 <- subset(sub_day, sub_day$Lon <= maxX &
                   sub_day$Lon >= minX &
                   sub_day$Lat <= maxY &
                   sub_day$Lat >= minY)
  sub1 <- levels(factor(sub1$Drifter))
  df <- subset(df, df$Drifter %in% sub1)
  print(paste('# Particulas ...', length(sub1)))
}
dev.off()

xlim <- xlimmap
ylim <- ylimmap
zlim <- c(0,28)
title <- ''

pngfile <- paste0(out_path, simu, '_selected_traj.png')
mymap <- get_map(location = c(lon = sum(xlimmap/2), lat = sum(ylimmap/2)), zoom = 8, maptype = 'satellite', color='bw')
map   <- ggmap(mymap)
map   <- map +
  # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = .075) +
  geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Day), size = .5) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = zlim, expression(Day)) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)', title = title) +
  coord_fixed(xlim = xlim, ylim = ylim, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black', size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=15, angle=90),
        plot.title   = element_text(face='bold', color='black', size=15, angle=0),
        legend.text  = element_text(face='bold', color='black', size=15),
        legend.title = element_text(face='bold', color='black', size=20),
        legend.position   = c(0.92, 0.9),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.5, linetype='solid'))

if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map
write.table(x = df, file = paste0(out_path, simu, '_selected_traj.csv'), sep = ';', row.names = F)

# Paso 6: Promedio de trayectoria
days <- levels(factor(df$Day))
day_mean <- NULL
for(j in days){
  df3 <- subset(df, df$Day == j)
  lon <- mean(df3$Lon)
  lat <- mean(df3$Lat)
  depth <- mean(df3$Depth)
  
  dat <- c(lon,lat, depth)
  day_mean <- rbind(day_mean, dat)
  # print(j)
}
colnames(day_mean) <- c('Lon', 'Lat', 'Depth')
day_mean <- as.data.frame(day_mean)

pngfile <- paste0(out_path, simu, '_mean_path.png')
zlim <- c(-60,0)
mymap <- get_map(location = c(lon = sum(xlimmap/2), lat = sum(ylimmap/2)), zoom = 8, maptype = 'satellite', color='bw')
map   <- ggmap(mymap)
map   <- map +
  # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = .075) +
  geom_path(data = day_mean, aes(x = Lon, y = Lat, colour = Depth), size = 1) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = zlim, expression(Depth)) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)', title = title) +
  coord_fixed(xlim = xlim, ylim = ylim, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black', size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=15, angle=90),
        plot.title   = element_text(face='bold', color='black', size=15, angle=0),
        legend.text  = element_text(face='bold', color='black', size=15),
        legend.title = element_text(face='bold', color='black', size=20),
        legend.position   = c(0.92, 0.9),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.5, linetype='solid'))

if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map
write.table(x = day_mean, file = paste0(out_path, simu, '_mean_path.csv'), sep = ';', row.names = F)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#