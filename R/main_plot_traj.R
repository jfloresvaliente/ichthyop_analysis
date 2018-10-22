#=============================================================================#
# Name   : main_plot_traj
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#=============================================================================#
source('source/plot_traj_ggmap_depth.R')
source('source/plot_traj_ggmap_day.R')
dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/'

simu <- 'daily_lobos_sechura'

xlim  <- c(-82, -80.15)
ylim  <- c(-7,-5)
zlim  <- c(-65,0) # 65 para lobos ; 120 para sechura - lobos
zlim2 <- c(0,28)

samples <- NULL
for(i in 2:2){
  df <- read.table(paste0(dirpath,'traj_', simu, i, '.csv'),header = T)
  
  # parti_100 <- tail(df)$Drifter[1]
  # parti_100 <- sample(x = 1:parti_100, size = 100, replace = T)
  # samples <- cbind(samples, parti_100)
  # 
  # df <- subset(df, df$Drifter %in% parti_100)
  
  if(!is.na(df[1,1])){
    month <- i
    
    title <- paste('Release Month', i)
    # title <- '' # For the empty title in map
    
    pngfile1 <- paste0(out_path,simu,'_traj_month_Depth',i,'.png')
    pngfile2 <- paste0(out_path,simu,'_traj_month_Days',i,'.png')
    plot_traj_ggmap_depth(df = df, xlim = xlim, ylim = ylim, zlim = zlim, pngfile = pngfile1, title = title)
    plot_traj_ggmap_day(df = df, xlim = xlim, ylim = ylim, zlim = zlim2, pngfile = pngfile2, title = title)
  }
}
# write.table(x = samples, file = paste0(out_path, simu,'_samples.csv'), row.names = F, col.names = F, sep = ',')
#=============================================================================#
# END OF PROGRAM
#=============================================================================#