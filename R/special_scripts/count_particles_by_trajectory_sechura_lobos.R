#===============================================================================
# Name   : count_particles_by_trajectory_sechura_lobos
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : -------
# URL    : 
#===============================================================================
library(Hmisc)
source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
winds <- c('daily', 'clim')

#### ##### PARTICLES LABELS #### ##### #
# Path 1 = East Island
# Path 2 = West Island
# Path 3 = Northward
#### ##### PARTICLES LABELS #### ##### #

List_wind <- list()
for(i in winds){ # Loop para cada tipo de forzante de viento
  simu <- paste0(i,'_sechura_lobos')  # Para rutas Sechura --> Lobos
  
  path_all_month <- NULL
  for(month in 1:12){ # Loop para cada mes
    csvfile <- paste0(dirpath,'traj_', simu, month, '.csv')
    df <- read.table(csvfile, header = T)
    
    # Identificar particulas con ruta: Hacia el norte, luego hacia el sur
    northward <- subset(df,
                        df$Lat >= -5.75 &
                        df$Lat <= -5.50 &
                        df$Lon <= -81.25)
    # Indices de particulas con ruta northward
    northwardIndex <- as.numeric(levels(factor(northward$Drifter)))
    path3 <- rep(3, times = length(northwardIndex))
    norMonth <- rep(month, times = length(northwardIndex))
    path3 <- cbind(norMonth,northwardIndex, path3)
    
    # Indices de particulas con ruta southward
    # Luego se evalua si entraron por el norte o sur de la isla
    southward <- subset(df, df$Drifter %nin% northwardIndex)
    southwardIndex <- as.numeric(levels(factor(southward$Drifter)))
    southward <- subset(df, df$Drifter %in% southwardIndex)
    
    # paths <- NULL
    path_particle_all <- NULL
    for(j in southwardIndex){ # Loop para evaluar cada particula restante que fue directo al sur
      particle <- subset(southward, southward$Drifter == j)
      
      # Entrada East Island
      m <- which(particle$Lat > -6.45 & particle$Lon > -80.85)
      m <- min(m)
      
      # Entrada West Island
      n <- which(particle$Lat < -6.45 & particle$Lon < -80.85)
      n <- min(n)
      
      if(m < n) path <- 1 else path <- 2
      path_particle <- c(month,j, path)
      path_particle_all <- rbind(path_particle_all, path_particle)
    }
    # Unir rutas northward con east-island y west-island
    all_paths <- rbind(path_particle_all, path3)
    path_all_month <- rbind(path_all_month, all_paths)
    colnames(path_all_month) <- c('Month','Drifter','Path')
    print(csvfile)
  }
  List_wind[[length(List_wind)+1]] <- path_all_month
}

# Save results in csv file
daily_paths <- as.data.frame(List_wind[[1]])
write.table(x = daily_paths, file = paste0(out_path, 'daily_sechura_lobos_index_paths.csv'), row.names = F, sep = ',')

clim_paths <- as.data.frame(List_wind[[2]])
write.table(x = clim_paths, file = paste0(out_path, 'clim_sechura_lobos_index_paths.csv'), row.names = F, sep = ',')


## Plot para confirmar trayectorias - Daily winds
# daily_paths <- as.data.frame(List_wind[[1]])
# counts <- rep(1, times = dim(daily_paths)[1])
# daily_paths <- cbind(daily_paths, counts)

# for(month in 1:12){
#   df <- read.table(paste0(dirpath,'traj_daily_sechura_lobos', month, '.csv'),header = T)
#   for(i in 1:3){
#     drifter <- subset(daily_paths, daily_paths[,1] == month & daily_paths[,3] == i)
#     paths <- subset(df, df$Drifter %in% drifter[,2])
#     if(dim(paths)[1] != 0){
#       plot_traj_ggmap_depth(df = paths,
#                             color.limits = c(-65,0),
#                             pngfile = paste0(out_path, 'daily_M',month, '_path',i,'.png'),texts = '')
#     }
#   }
# }

## Plot para confirmar trayectorias - Clim winds
# clim_paths <- as.data.frame(List_wind[[2]])
# counts <- rep(1, times = dim(clim_paths)[1])
# clim_paths <- cbind(clim_paths, counts)

# for(month in 1:12){
#   df <- read.table(paste0(dirpath,'traj_clim_sechura_lobos', month, '.csv'),header = T)
#   for(i in 1:3){
#     drifter <- subset(daily_paths, daily_paths[,1] == month & daily_paths[,3] == i)
#     paths <- subset(df, df$Drifter %in% drifter[,2])
#     # if(dim(paths)[1] != 0){
#     #   plot_traj_ggmap_depth(df = paths,
#     #                         color.limits = c(-65,0),
#     #                         pngfile = paste0(out_path, 'clim_M',month, '_path',i,'.png'),texts = '')
#     # }
#   }
# }


## Barplot de trayectorias
# daily <- tapply(daily_paths$counts, list(daily_paths$Month, daily_paths$Path), sum, na.rm = TRUE)
# clim <-  tapply(clim_paths$counts, list(clim_paths$Month, clim_paths$Path), sum, na.rm = TRUE)
# 
# cols <- c('grey30', 'grey60', 'grey90')
# mes <- c('Jan','Feb','Mar','Apr','May','Jun',
#          'Jul','Aug','Sep','Oct','Nov','Dic')
# ylab <- 'Number of particles transported'
# legend = c('path i','path ii','path iii')
# ylim = 1370


## BARPLOT 1
## BARPLOT 2
# bar2 <- barplot(t(clim), beside = T, ylim = c(0,1370), col = cols, xaxt = 'n', yaxt = 'n')
# axis(1, at = apply(bar2, MARGIN = c(2), mean), labels = mes, cex.axis = 0.75, las = 2)
# axis(2, at = seq(0,ylim,200), labels = seq(0,ylim,200), cex.axis = 0.75)
# mtext(text = 'Monthly Winds', side = 3)
# legend('topright', legend = legend, bty = 'n', fill = cols, cex = .85)
# 
# dev.off()
# 
