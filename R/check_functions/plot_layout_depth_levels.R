#===============================================================================
# Name   : plot_layout_depth_levels
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
dirpath = "G:/ICHTHYOP/final/processed/output_2nd/"
setwd(dirpath)
source("G:/ICHTHYOP/scripts/recruitment_day.R")

simu = "lobos"
graph.type = 0  # 0 = .png ; 1 = .wmf

# Don't change anything after here
if(simu == "lobos"){
  ymax = 16     # 16 para retencion  ; # 0.55 para transporte
  ylab = 1        # 0 = larval transport ; 1 = larval retention
}else{
  ymax = .55     # 8 para retencion  ; # 0.22 para transporte
  ylab = 0        # 0 = larval transport ; 1 = larval retention
}

legend = 1      # 0 = off legend ; 1 = on legend
legend.cex = .8

meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

if(ylab == 1){
  ylab = 'Larval Retention (%)'
}else{
  ylab = 'Larval Transport Success (%)'
}

if(graph.type == 1){
  win.metafile(paste0(simu,"_release_depths.wmf"), width = 9, height = 5)
}else{
  png(paste0(simu,"_release_depths.png"), width = 1050 , height = 650 , res=120)
}

mat <- matrix(c(1:6), 2, 3, byrow = TRUE)
nf <- layout(mat, widths = c(9,9,9), height = c(8,8), TRUE)
# days = numeric(length=20); days[c(1,5,10)] = c(1,10,20)

### CLIM WINDS
data = read.csv(paste0("clim_", simu, ".csv"), header = T, sep = ",")
depths = levels(data$Depth)

for(i in 1:3){
  
  dataset = subset(data, data$Depth == depths[i])
  dataday = recruitment_day(dataset)
  
  par(mar=c(4 , 5 , 1.5 , 0.3))
  dayplot   <- barplot(dataday[,1], xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
  arrows(dayplot,100*(dataday[,2]+dataday[,3]),dayplot,100*(dataday[,2]-dataday[,3]),angle=90,code=3,length=0.05)
  axis(1, at=dayplot, labels = FALSE, tick = FALSE)
  mtext(ylab, side=2, line=2.5 , cex=.9)
  axis(2, lwd = 3, cex.axis = 1.4)
  text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
  mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
  legend("topright", paste("Monthly winds", "release depth", depths[i]), bty = "n", cex = legend.cex)
}

### DAILY WINDS
data = read.csv(paste0("daily_", simu, ".csv"), header = T, sep = ",")
depths = levels(data$Depth)

for(i in 1:3){
  
  dataset = subset(data, data$Depth == depths[i])
  dataday = recruitment_day(dataset)
  
  par(mar=c(4 , 5 , 1.5 , 0.3))
  dayplot   <- barplot(dataday[,1], xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
  arrows(dayplot,100*(dataday[,2]+dataday[,3]),dayplot,100*(dataday[,2]-dataday[,3]),angle=90,code=3,length=0.05)
  axis(1, at=dayplot, labels = FALSE, tick = FALSE)
  mtext(ylab, side=2, line=2.5 , cex=.9)
  axis(2, lwd = 3, cex.axis = 1.4)
  text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
  mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
  legend("topright", paste("Daily winds", "release depth", depths[i]), bty = "n", cex = legend.cex)
}

dev.off()