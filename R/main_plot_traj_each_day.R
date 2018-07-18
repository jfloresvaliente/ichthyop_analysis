#===============================================================================
# Name   : main_plot_traj_each_day
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')
dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/traj_byday/'

simu <- 'daily_sechura_lobos'

# ylim <- -65 
color.limits <- c(-65,0) # 65 para lobos ; 120 para sechura - lobos

for(i in 1:12){
  df <- read.table(paste0(dirpath,'traj_', simu, i, '.csv'),header = T)
  
  if(!is.na(df[1,])){
    month <- i
    
    # texts <- paste('Release Month', i)
    texts <- '' # For the empty legend
    
    for(j in 1:28){
      df2 <- subset(df, df$Day == j)
      pngfile <- paste0(out_path,simu,'_traj_month_',i,'_day_',j,'.png')
      plot_traj_ggmap_depth(df2,color.limits,pngfile,texts)
    }
  }
}

#===============================================================================
# END OF PROGRAM
#===============================================================================
