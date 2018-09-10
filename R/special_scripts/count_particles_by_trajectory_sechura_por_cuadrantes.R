library(Hmisc)
library(maps)
library(mapdata)
source(file = 'F:/GitHub/ichthyop_analysis/R/source/plot_traj_ggmap_depth.R')


dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'C:/Users/ASUS/Desktop/ich/'
# winds <- c('daily', 'clim')
winds <- c('daily')


i = winds
month <- 1

# Sechura
lonindex <- -81.25
latindex <- -5.525


ylimmap <- c(-6,-5)
xlimmap <- c(-82.5,-80.5)
xy <- read.table(file = 'C:/Users/ASUS/Desktop/coords.txt', header = F)

x11()
plot(xy[,1], xy[,2], type = 'l', ylim = ylimmap, xlim = xlimmap, axes = T)
abline(h = latindex, v = lonindex)

simu <- paste0(i,'_sechura')
csvfile <- paste0(dirpath,'traj_', simu, month, '.csv')
df <- read.csv(csvfile, header = T, sep = ';')
dim(df)


# PASO 1: Elegir los que dia 1 empiezan en el norte
sub1 <- subset(df, df$Lat >= latindex & df$Day ==1)
sub1 <- levels(as.factor(sub1$Drifter))
df <- subset(df, df$Drifter %in% sub1)


# Plot subset
for(i in 1:27){
  dfsub <- subset(df, df$Day == i)
  
  if(dim(dfsub) == 0) next()
  png(filename = paste0(out_path, 'M',month, '_',i, '.png'), width = 850, height = 950)
  
  # map('worldHires', add=F, fill=T, col='gray', ylim = ylimmap, xlim = xlimmap)
  plot(xy[,1], xy[,2], type = 'l', ylim = ylimmap, xlim = xlimmap, axes = F)
  box(lwd = 2)
  axis(side = 1, at = seq(xlimmap[1], xlimmap[2], 1), labels = seq(xlimmap[1],xlimmap[2], 1),
       lwd = 2, lwd.ticks = 2, font.axis=4)
  axis(side = 2, at = seq(ylimmap[1], ylimmap[2], 1), labels = seq(ylimmap[1], ylimmap[2], 1),
       lwd = 2, lwd.ticks = 2, font.axis=4, las = 2)
  points(x = dfsub$Lon, y = dfsub$Lat, pch = 19, cex = .1, col = 'blue')
  # lines(x = dfsub$Lon, y = dfsub$Lat, type = 'l', cex = .1, col = 'blue')
  mtext(text = paste('Month', month,'Day', i), side = 3, adj = 0.05, line = -1, font = 2)
  dev.off()
  
  
}







# # PASO 2: Cuadrante I: Fin
# sub2 <- subset(df, df$Lon >= lonindex & df$Lat >= latindex+0.03 & df$Day == 28)
# sub2 <- levels(as.factor(sub2$Drifter))
# df <- subset(df, df$Drifter %in% sub2)
# 
# # PASO 3: Elegir trayectorias solo a la derecha
# sub3 <- subset(df, df$Lon <= lonindex)
# sub3 <- levels(as.factor(sub3$Drifter))
# df <- subset(df, df$Drifter %nin% sub3)
# 
# # PASO 4: Elegir los que comienzan cerca a la isla en dia 1
# sub4 <- subset(df, df$Lon <= lonindex+0.03 & df$Day == 1)
# sub4 <- levels(as.factor(sub4$Drifter))
# df <- subset(df, df$Drifter %in% sub4)
# 
# # PASO 5: Elegir los que terminan cerca a la isla en dia 28
# sub5 <- subset(df, df$Lon <= lonindex+0.025 & df$Day == 28)
# sub5 <- levels(as.factor(sub5$Drifter))
# df <- subset(df, df$Drifter %in% sub5)






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

x11()
plot(xy[,1], xy[,2], type = 'l', ylim = ylimmap, xlim = xlimmap, axes = T)
# lines(day_mean[,1], day_mean[,2], type = 'l', col = 'blue')
abline(h = latindex, v = lonindex)
# abline(v = lonindex+0.025)


xlim = c(-82, -80.15)
ylim = c(-7,-5)
zlim = c(-60,0)
XY = c(-81,-6)
pngfile = NULL
title = ''


library(ggmap)
library(fields)

mymap <- get_map(location = c(lon = XY[1], lat = XY[2]), zoom = 8, maptype = 'satellite', color='bw')
map   <- ggmap(mymap)
map   <- map +
  # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = .075) +
  geom_path(data = day_mean, aes(x = Lon, y = Lat, colour = Depth), size = .5) +
  scale_colour_gradientn(colours = tim.colors(n = 64, alpha = 1), limits = zlim, expression(Depth)) +
  labs(x = 'Longitude (W)', y = 'Latitude (S)', title = title) +
  coord_fixed(xlim = xlimmap, ylim = ylimmap, ratio = 2/2) +
  theme(axis.text.x  = element_text(face='bold', color='black', size=15, angle=0),
        axis.text.y  = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.x = element_text(face='bold', color='black', size=15, angle=0),
        axis.title.y = element_text(face='bold', color='black', size=15, angle=90),
        plot.title   = element_text(face='bold', color='black', size=15, angle=0),
        legend.text  = element_text(face='bold', color='black', size=15),
        legend.title = element_text(face='bold', color='black', size=20),
        legend.position   = c(0.92, 0.9),
        legend.background = element_rect(fill=adjustcolor( 'red', alpha.f = 0), size=0.5, linetype='solid'))
map

# print(pngfile); flush.console()
# if(!is.null(pngfile)) ggsave(filename = pngfile, width = 9, height = 9) else map


