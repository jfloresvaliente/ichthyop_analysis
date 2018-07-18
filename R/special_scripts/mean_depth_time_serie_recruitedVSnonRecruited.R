#===============================================================================
# Name   : mean_depth_time_serie_recruitedVSnonRecruited
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute recruitment for ICHTHYOP model outputs (from any folder)
# URL    : 
#===============================================================================
source('source/error_bar.R')

# The directory that contains the series of netcdf input files
dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/tracking_mean_depth/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/depth_time_serie/'

# winds <- 'daily'
simu <- 'clim_sechura_lobos'
# x11()
png(filename = paste0(out_path, simu,'_meanDepthTimeSerie_non-recruited.png'), width = 1250, height = 750, res = 120)
par(mfrow = c(4,3), mar = c(3,3,1,1))
for(month in 1:12){ # loop para cada mes
  csvfile <- paste0(dirpath,'traj_',simu, month , '.csv')
  dat <- read.table(csvfile, header = T, sep = '')
  print(csvfile)
  if(month == 1){release_depths <- levels(factor(dat$ReleaseDepth))}
  
  # Serie promedio
  depth_serie_mean <- NULL
  for(i in release_depths){
    dat2 <- subset(dat, dat$ReleaseDepth == i)
    if(dim(dat2)[1] == 0){
      depth_mean = rep(NA, times = 28)
    }else{
      depth_mean <- tapply(dat2$Depth, list(dat2$Day), mean)  
    }
    
    depth_serie_mean <- rbind(depth_serie_mean,depth_mean)
  }
  ylim = c(-65,0)
  # ylim = c(-200,0)
  plot(1:28, type = 'n', ylim = ylim, ylab = '', xlab = '', xaxt='n')
  mtext(side = 1, text = 'Days after released', line = 2, cex = 0.75)
  mtext(side = 2, text = 'Depth', line = 2,cex = 0.75)
  axis(1, at = 1:28, labels = 0:27)
  col <- c('black','red','green')
  for(i in 1:dim(depth_serie_mean)[1]){
    # print(i)
    lines(depth_serie_mean[i,], type = 'l', col = col[i])
    # col <- col + 1
  }
  legend('topright', legend = c(release_depths), lty = c(1,1,1),
         col = col, bty = 'n', title = 'Release Depth', cex = 0.75)
  legend('topleft', legend = paste('Release Month', month), bty = 'n', cex = 0.75)
}
dev.off()
