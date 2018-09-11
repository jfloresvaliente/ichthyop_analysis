#=============================================================================#
# Name   : find_paths1
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Paso 1 para buscar trayectorias: Plotear todas las particulas
# URL    : 
#=============================================================================#
library(ggmap)
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

# Sechura <--> Lobos
ylimmap <- c(-7.2,-5)
xlimmap <- c(-81.5,-80.2)

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'C:/Users/ASUS/Desktop/ich/daily_lobos_sechura/'

winds <- c('daily')
simu <- paste0(winds,'_','lobos_sechura')

for(i in 1:12){

  csvfile <- paste0(dirpath,'traj_', simu,i, '.csv')
  df <- read.table(csvfile, header = T, sep = ';')
  
  xlim <- xlimmap
  ylim <- ylimmap
  zlim <- c(0,28)
  title <- ''
  
  pngfile <- paste0(out_path, simu, i, '.png')
  
  mymap <- get_map(location = c(lon = sum(xlimmap/2), lat = sum(ylimmap/2)), zoom = 8, maptype = 'satellite', color='bw')
  map   <- ggmap(mymap)
  map   <- map +
    # geom_point(data = df, aes(x = Lon, y = Lat, colour = Depth), size = .075) +
    geom_path(data = df, aes(group = Drifter, x = Lon, y = Lat, colour = Day), size = .1) +
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
}
rm(list = ls())
#=============================================================================#
# END OF PROGRAM
#=============================================================================#