#===============================================================================
# Name   : main_traj_subset_to_choose_particles
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')
dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/csv_files/trajectoy/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/figures/subset_particles/'

simu <- 'clim_sechura_lobos'

# ylim <- -65 
color.limits <- c(-120,0) # 65 para lobos ; 120 para sechura - lobos

for(i in 1:12){
  df <- read.table(paste0(dirpath,'traj_', simu, i, '.csv'),header = T)
  
  drifter <- as.numeric(levels(factor(df$Drifter)))
  
  sub_sample <- 20 # Número de particulas por cada imagen
  drif_ini <- seq(from = 1, to = length(drifter), by = sub_sample); # drif_ini <- drif_ini[-length(drif_ini)]
  drif_out <- drif_ini + sub_sample - 1
  
  
  for(j in 1:length(drif_ini)){
      df2 <- subset(df, df$Drifter %in% c(drif_ini[j]:drif_out[j]))
      texts <- paste('Month', i, '/ Particles', drif_ini[j], '-', drif_out[j])
      # texts <- '' # For the empty legend
      
      pngfile <- paste0(out_path,simu,'_traj_month_',i,'Particles', drif_ini[j], '-', drif_out[j],'.png')
      plot_traj_ggmap_depth(df2,color.limits,pngfile,texts)
  }
}

