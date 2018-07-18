#===============================================================================
# Name   : plot_layout_both_winds
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
source_path <- 'D:/ICHTHYOP/scripts/'
source(paste0(source_path, 'recruitment_day.R'))

simu = 'lobos'
graph.type = 0  # 0 = .png ; 1 = .wmf

# Don't change anything after here
if(simu == 'lobos'){
  ymax = 9     # 8 para retencion  ; # 0.22 para transporte
  ylab = 1        # 0 = larval transport ; 1 = larval retention
}else{
  ymax = 0.2     # 8 para retencion  ; # 0.22 para transporte
  # ymax = 0.005     # 8 para retencion  ; # 0.22 para transporte
  ylab = 0        # 0 = larval transport ; 1 = larval retention
}

legend = 1      # 0 = off legend ; 1 = on legend
legend.cex = 1

meses = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')

if(ylab == 1){
  ylab = 'Larval Retention (%)'
}else{
  ylab = 'Larval Transport Success (%)'
}

if(graph.type == 1){
  win.metafile(paste0(out_path,simu,'_winds.wmf'), width = 9, height = 5)
}else{
  png(paste0(out_path,simu,'_winds.png'), width = 1050 , height = 650 , res=120)
}

### PLOT AS FUNCTION OF SPAWNING MONTH

mat <- matrix(c(1,2), 1, 2, byrow = TRUE)
nf <- layout(mat, widths = c(8,8), height = c(8), TRUE)

### CLIM WINDS
data = read.csv(paste0(dirpath,'clim_', simu, '.csv'), header = T, sep = '')
data = subset(data, data$Year %in% c(2009:2011))
dataday = recruitment_day(data)
# par(mar=c(4 , 5 , 1.5 , 0.3))
par(mar=c(3,3.5,0.5,1.5))
dayplot   <- barplot(dataday[,1], xlab='', ylab= '' ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(dayplot,100*(dataday[,2]+dataday[,3]),dayplot,100*(dataday[,2]-dataday[,3]),angle=90,code=3,length=0.05)
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par('usr')[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext('Month of spawning', side=1, line=2. , cex=0.9)
# mtext(paste('Total = ', round(sum(dataday[,1]),digits = 3), '%'), side = 3, line = -3, cex = 0.75, adj = 1)

if(legend == 1){
  legend('topright', 'Monthly winds', bty = 'n', cex = legend.cex)
}
print(dataday[,1])
print(paste('sum CLIM', simu,sum(dataday[,1])))

### DAILY WINDS
data = read.csv(paste0(dirpath,'daily_', simu,'.csv'), header = T, sep = '')
data = subset(data, data$Year %in% c(2009:2011))
dataday = recruitment_day(data)
# par(mar=c(4 , 3 , 1.5 , 0.3))
par(mar=c(3,3.5,0.5,1.5))
dayplot   <- barplot(dataday[,1], xlab='', ylab= '' ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(dayplot,100*(dataday[,2]+dataday[,3]),dayplot,100*(dataday[,2]-dataday[,3]),angle=90,code=3,length=0.05)
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par('usr')[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext('Month of spawning', side=1, line=2. , cex=0.9)
# mtext(paste('Total = ', round(sum(dataday[,1]),digits = 3), '%'), side = 3, line = -3, cex = 0.75,adj = 1)

if(legend == 1){
  legend('topright', 'Daily winds', bty = 'n', cex = legend.cex)
}
print(dataday[,1])
print(paste('sum DAILY',simu, sum(dataday[,1])))
dev.off()
