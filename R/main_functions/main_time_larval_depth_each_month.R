dirpath <- 'D:/ICHTHYOP/final/processed/output_2nd/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_plots/'
source_path <- 'D:/ICHTHYOP/scripts/'

# setwd(dirpath)

firstdrifter = 1
lastdrifter  = 55
simu = "daily_sechura_lobos"

ylim = -65 # 65 para lobos ; 120 para sechura - lobos

particles = NULL
for(i in c(1,5,10)){

  dataset   = read.table(paste0(dirpath,"tracking_larval_", simu, "_t", i, ".csv"), header = T)
  dataset = subset(dataset, dataset$year %in% c(2009:2011))
  particles = rbind(particles, dataset)
  print(paste0(dirpath,"tracking_larval_", simu, "_t", i, ".csv ", format(Sys.time(), '%H:%M:%S')))
}

rm(dataset)
particles$month = as.factor(particles$month)
a = levels(particles$month)

source(paste0(source_path,'time_larval_depth.R'))
days = seq(1,27,2)
length.arrow = 0.03
####


png(paste0(simu,"_depth_layout.png") , width = 1250 , height = 850 , res=120)
mat <- matrix(c(1:12), 3, 4, byrow = TRUE)
nf <- layout(mat, widths = c(9,8.5,8.5,8.5), height = c(9,9,9), TRUE)

for(i in 1:length(a)){
  
  if(i == 1 | i == 5 | i == 9){
    
    level = subset(particles, particles$month == a[i])
    depths1 = time_larval_depth(level, firstdrifter , lastdrifter)
    depths1 = depths1[seq(1, by = 2, length.out = 27),]
    par(mar=c(4,1.3,0.6,1))
    plot(depths1[,1], type="l", ylab="", xlab="", ylim=c(ylim,0), axes=F)
    arrows(x0 = 1:length(depths1[,1]) , y0= depths1[,2],
           x1 = 1:length(depths1[,1]) , y1= depths1[,3],
           code=3, angle=90, length=length.arrow)
    mtext("Depth (m)", 2, line = 2.5)
    axis(2)
    axis(1, at = days, labels = days)
    legend("topleft", legend = paste("Month", a[i]), bty = "n")
    
    if(i == 9){
      mtext("Days", 1, line = 2.)
    }
    
  }else{
    
    level = subset(particles, particles$month == a[i])
    depths1 = time_larval_depth(level, firstdrifter , lastdrifter)
    depths1 = depths1[seq(1, by = 2, length.out = 27),]
    par(mar=c(4,1.3,0.6,1))
    plot(depths1[,1], type="l", ylab="", xlab="", ylim=c(ylim,0), axes=F)
    arrows(x0 = 1:length(depths1[,1]) , y0= depths1[,2],
           x1 = 1:length(depths1[,1]) , y1= depths1[,3],
           code=3, angle=90, length=length.arrow)
    # mtext("Depth (m)", 2, line = 2.5)
    axis(2, labels = FALSE)
    axis(1, at = days, labels = days)
    legend("topleft", legend = paste("Month", a[i]), bty = "n")
    
    if(i == 10 | i == 11 | i == 12){
      mtext("Days", 1, line = 2.)
    }
  }

}

dev.off()