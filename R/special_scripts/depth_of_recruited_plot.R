#===============================================================================
# Name   : depth_of_recruited_plot
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('source/error_bar.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited_depth/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/recruited_depth/'

simu <- 'clim_lobos'

df <- read.table(paste0(dirpath, simu, '_depth_of_recruited', '.csv'),header = T, sep = ',')

# plot para cada mes
png(filename = paste0(out_path,simu, '_depth_of_recruited_plot.png'), width = 850, height = 450, res = 120)
par(mfrow = c(1,2), mar=c(4,4,1,1))
dataday <- NULL
for(i in 1:12){
  month <- subset(df, df$Month == i)
  depths <- month$Depth
  stat <- error_bar(depths)
  dataday <- rbind(dataday, stat)
}


ylim <- c(-60,0)
ylab <- 'Depth of recruited'
meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

dayplot   <- barplot(dataday[,1], xlab="", ylab= "" ,ylim = ylim, axes = FALSE, axisnames = FALSE)
arrows(dayplot,dataday[,2],dayplot,dataday[,3],angle=90,code=3,length=0.05)
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)

# plot para cada profundidad de liberacion
depths_levels <- levels(factor(df$ReleaseDepth))
datadepth <- NULL
for(i in depths_levels){
  month <- subset(df, df$ReleaseDepth == i)
  depths <- month$Depth
  stat <- error_bar(depths)
  datadepth <- rbind(datadepth, stat)
}


depthplot <- barplot(datadepth[,1], xlab="", ylab="", ylim = ylim, axes = FALSE, cex.names=.8,axisnames = FALSE)
arrows(depthplot,datadepth[,2],depthplot,datadepth[,3],angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
text(depthplot, par("usr")[3], labels = depths_levels, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext(ylab, side=2, line=2.5 , cex=1.2)

dev.off()
