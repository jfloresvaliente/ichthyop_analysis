#===============================================================================
# Name   : plot_layout_depth_levels_line
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
  win.metafile(paste0(simu,"_release_depths_lines.wmf"), width = 9, height = 5)
}else{
  png(paste0(simu,"_release_depths_lines.png"), width = 1050 , height = 650 , res=120)
}

mat <- matrix(c(1,2), 1, 2, byrow = TRUE)
nf <- layout(mat, widths = c(8,8), height = c(8), TRUE)
# days = numeric(length=20); days[c(1,5,10)] = c(1,10,20)

### CLIM WINDS
data = read.csv(paste0("clim_", simu, ".csv"), header = T, sep = ",")
depths = levels(data$Depth)

par(mar=c(4 , 5 , 1.5 , 0.3))
plot(1:12, type = "n",xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE)
axis(1, at=1:12, labels = meses, tick = T)
mtext(ylab, side=2, line=2.5 , cex=.9)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)

for(i in 1:3){
  
  dataset = subset(data, data$Depth == depths[i])
  dataday = recruitment_day(dataset)
  
  lines(dataday[,1], type="l",col=i)
  arrows(1:12,100*(dataday[,2]+dataday[,3]),1:12,100*(dataday[,2]-dataday[,3]),
         angle=90,code=3,length=0.05, col=i)
  
}

legend("topright", c(depths[1],depths[2],depths[3]), bty = "n",
       cex = legend.cex, col=c(1:3),lty=c(1,1,1),x.intersp=0.1, y.intersp=0.8)
legend("topleft", "Monthly winds", bty = "n", cex = legend.cex)


### DAILY WINDS
data = read.csv(paste0("daily_", simu, ".csv"), header = T, sep = ",")
depths = levels(data$Depth)

par(mar=c(4 , 5 , 1.5 , 0.3))
plot(1:12, type = "n",xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE)
axis(1, at=1:12, labels = meses, tick = T)
mtext(ylab, side=2, line=2.5 , cex=.9)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)

for(i in 1:3){
  
  dataset = subset(data, data$Depth == depths[i])
  dataday = recruitment_day(dataset)
  
  lines(dataday[,1], type="l",col=i)
  arrows(1:12,100*(dataday[,2]+dataday[,3]),1:12,100*(dataday[,2]-dataday[,3]),
         angle=90,code=3,length=0.05, col=i)
  
}

legend("topright", c(depths[1],depths[2],depths[3]), bty = "n",
       cex = legend.cex, col=c(1:3),lty=c(1,1,1),x.intersp=0.1, y.intersp=0.8)
legend("topleft", "Daily winds", bty = "n", cex = legend.cex)

dev.off()
