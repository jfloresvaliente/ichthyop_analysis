library(ggmap)
library(fields)
library(raster)

# # Sechura coords
# ylimmap <- c(-6.25,-5)
# xlimmap <- c(-82,-80.7)

# Lobos coords
ylimmap <- c(-6.7,-6.2)
xlimmap <- c(-81,-80.5)

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'C:/Users/ASUS/Desktop/ich/'
winds <- c('daily')
simu <- paste0(winds,'_','lobos')

final <- NULL
for(month in 1:12){
  csvfile <- paste0(dirpath,'traj_', simu, month, '.csv')
  dfsub <- read.table(csvfile, header = T, sep = ';')
  
  if(dfsub$Lon[1] == 999) next()
  
  finalday <- subset(dfsub, dfsub$Day == 28)
  finalday <- cbind(finalday$Lon, finalday$Lat)
  final <- rbind(final, finalday)
  print(csvfile)
}

# Contar la grilla
x <- final[,1]
y <- final[,2]
z <- rep(1, times = dim(final)[1])

# # Especial para Retencion en Sechura
# z <- 1:dim(final)[1]
# xyz <- cbind(x,y,z)
# xyz_ind <- subset(xyz, xyz[,1] < -81.045 & xyz[,2] < -5.75)
# indx <- xyz_ind[,3]
# 
# xyz <- xyz[-c(indx),]
# 
# xyz[,3] <- rep(1, time = dim(xyz)[1])
# 
# xyz <- subset(xyz, xyz[,2] < -5.25)
# 
# x <- xyz[,1]
# y <- xyz[,2]
# z <- xyz[,3]

# Especial para Retencion en Lobos
z <- 1:dim(final)[1]
xyz <- cbind(x,y,z)
xyz_ind <- subset(xyz, xyz[,2] > -6.35)
indx <- xyz_ind[,3]

xyz <- xyz[-c(indx),]

xyz[,3] <- rep(1, time = dim(xyz)[1])

# xyz <- subset(xyz, xyz[,2] < -5.25)

x <- xyz[,1]
y <- xyz[,2]
z <- xyz[,3]

####################### --
xy <- matrix(c(x,y), ncol = 2)
r <- raster(xmn=xlimmap[1], xmx=xlimmap[2], ymn=ylimmap[1], ymx=ylimmap[2], res = 1/48) # 1/48° = 2.2km
r[] <- 0
tab <- table(cellFromXY(r, xy))

# Transformar los valores absolutos a relativos
tab2 <- (tab*100)/sum(tab)

r[as.numeric(names(tab))] <- tab2
d <- data.frame(coordinates(r), count=r[])
d <- subset(d, d$count != 0)

df <- d
colnames(df) <- c('Lon', 'Lat', 'Dens')

# Plot in ggmap
xlim <- xlimmap
ylim <- ylimmap
zlim <- c(0,ceiling(range(df$Dens)[2]))
title <- ''

pngfile <- paste0(out_path, simu, '_larvaedensity.png')
mymap <- get_map(location = c(lon = sum(xlimmap/2), lat = sum(ylimmap/2)), zoom = 8, maptype = 'satellite', color='bw')
map   <- ggmap(mymap)
map   <- map +
  geom_point(data = df, aes(x = Lon, y = Lat, colour = Dens), size = 4) +
  # geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Dens), size = .5) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = zlim, expression(Density)) +
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
write.table(x = df, file = paste0(out_path, simu, '_larvaedensity.csv'), sep = ';', row.names = F)

# rm(list = ls())