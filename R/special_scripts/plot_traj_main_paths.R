#===============================================================================
# Name   : plot_traj_main_paths
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute recruitment for ICHTHYOP model outputs (from any folder)
# URL    : 
#===============================================================================
source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')
dirpath <- 'F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/trajectory/samples100/'

df <- read.csv(paste0(dirpath,'daily_lobos_sechura_index_paths.csv'), sep = '', header = T)

color.limits <- c(-50,0) # 65 para lobos ; 120 para sechura - lobos
# texts <- paste('Release Month', i)
texts <- c(1,2) # For the empty legend
pngfile <- paste0(out_path,'daily_sechura_lobos_3paths.png')
plot_traj_ggmap_depth(df,color.limits,pngfile,texts)

