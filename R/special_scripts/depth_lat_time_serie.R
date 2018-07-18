library(abind)
dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/depth_time_serie/'

simu <- 'clim_lobos'
mes_index <- 12

# xlim = c(-6.7, -5.2)
# ylim = c(-80,0)

xlim = c(-6.65, -6.25)
ylim = c(-60,0)
## ## ## ## ## 
getMeanDepthLat <- function(df){
  MeanDepth <- tapply(df$Depth, list(df$Day), mean)
  MeanLat   <- tapply(df$Lat, list(df$Day), mean)
  return(cbind(MeanLat, MeanDepth))
}

xyMonth <- NULL
for(i in 1:mes_index){
  dat <- read.table(paste0(dirpath, 'traj_', simu, i, '.csv'), header = T)
  xy <- getMeanDepthLat(dat)
  xyMonth <- abind(xyMonth, xy, along = 3)
}

png(filename = paste0(out_path, simu,'_meanDepthLat.png'), width = 1250, height = 750, res = 120)
par(mfrow = c(4,3), mar = c(3,3,1,1))
for(i in 1:mes_index){
  xy <- xyMonth[,,i]
  plot(xy[,1], xy[,2], type = 'l',xlim = xlim, ylim = ylim, xlab = '', ylab = '')
  abline(v = xy[1,1])
  mtext(side = 1, text = 'Latitude', line = 2, cex = 0.75)
  mtext(side = 2, text = 'Depth', line = 2,cex = 0.75)
  legend('topright', legend = paste('Month of Release', i), bty = 'n', cex = .75)
}
dev.off()
