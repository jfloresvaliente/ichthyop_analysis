#===============================================================================
# Name   : plots_layout_3
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : This plot a layout [1 , 2 , 3]
#===============================================================================

plot_layout_3 = function(fig_name, ymax, ylab, legend, legend.cex){
  #============ ============ Arguments ============ ============#
  
  # fig_name = Name of the png file to save plot
  # ymax = max value for 'Y' axis
  # ylab = label for 'Y' axis
  # legend = if 1 a legend in the form of a letter is added to each sub-splot
  # legend.cex = size of legend
  
  #============ ============ Arguments ============ ============#
  
  if(ylab == 1){
    ylab = 'Local Retention (%)'
  }else{
    ylab = 'Transport Success (%)'
  }
  
  months = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
  
  png(paste0(fig_name,'.tiff'), width = 1050, height = 350, res=120)
  
  mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
  nf <- layout(mat, widths = c(8,8,8), height = c(8), TRUE)
  
  ### PLOT AS FUNCTION OF MONTH OF SPAWNING
  par(mar=c(4 , 5.5 , 1.5 , 0.15))
  dayplot   <- barplot(dataday[,1], xlab='', ylab= '' ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
  arrows(dayplot,100*(dataday[,2]+dataday[,3]),dayplot,100*(dataday[,2]-dataday[,3]),angle=90,code=3,length=0.05)
  axis(1, at=dayplot, labels = FALSE, tick = FALSE)
  mtext(ylab, side=2, line=3.5 , cex=1.2)
  axis(2, lwd = 3, cex.axis = 1.4, las = 2)
  text(dayplot, par('usr')[3], labels = months, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
  mtext('Spawning Month', side=1, line=2.5 , cex=0.9)
  
  if(legend == 1) legend('topleft', 'A)', bty = 'n', cex = legend.cex)
  
  ### PLOT AS FUNCTION OF SPAWNING DEPTH
  par(mar=c(4 , 1.5 , 1.5 , 0.15))
  depthplot <- barplot(datadepth[,1], xlab='', ylab='', ylim = c(0,ymax), axes = FALSE, cex.names=.8)
  arrows(depthplot,100*(datadepth[,2]+datadepth[,3]),depthplot,100*(datadepth[,2]-datadepth[,3]),angle=90,code=3,length=0.05)
  axis(2, lwd = 3, cex.axis = 1.4, las = 2, labels = FALSE)
  mtext('Spawning depth (m)', side=1, line=2.5, cex=0.9)
  # mtext(ylab, side=2, line=2.5 , cex=1.2)
  
  if(legend == 1) legend('topleft', 'B)', bty = 'n', cex = legend.cex)
  
  ### PLOT AS FUNCTION OF AGE MINIMUN TO SETTLEMENT
  par(mar=c(4 , 1.5 , 1.5 , 0.15))
  ageplot   <- barplot(dataage[,1], xlab='',ylab= '', ylim = c(0,ymax), axes = FALSE, cex.names=.8)
  arrows(ageplot,100*(dataage[,2]+dataage[,3]),ageplot,100*(dataage[,2]-dataage[,3]),angle=90,code=3,length=0.05)
  axis(2, lwd = 3, cex.axis = 1.4, las = 2, labels = FALSE)
  mtext('Minimum age to settlement (d)', side=1, line=2.5, cex=0.9)
  # mtext(ylab, side=2, line=2.5 , cex=1.2)
  
  if(legend == 1) legend('topleft', 'C)', bty = 'n', cex = legend.cex)

  dev.off()
}
#===============================================================================
# END OF PROGRAM
#===============================================================================