dirpath = "G:/ICHTHYOP/final/processed/output_2nd/"
setwd(dirpath)

firstdrifter = 1
lastdrifter  = 55
simu = "clim_sechura_lobos"

ylim = -65

particles = NULL
for(i in c(1,5,10)){
  
  dataset   = read.table(paste0("tracking_larval_", simu, "_t", i, ".csv"), header = T)
  particles = rbind(particles, dataset)
}

rm(dataset)
a = levels(particles$release_depth)

source("G:/ICHTHYOP/scripts/time_larval_depth.R")

level1 = subset(particles, particles$release_depth == a[1])
level2 = subset(particles, particles$release_depth == a[2])
level3 = subset(particles, particles$release_depth == a[3])

rm(particles)

depths1 = time_larval_depth(level1, firstdrifter , lastdrifter)
depths2 = time_larval_depth(level2, firstdrifter , lastdrifter)
depths3 = time_larval_depth(level3, firstdrifter , lastdrifter)

depths1 = depths1[seq(1, by = 2, length.out = 27),]
depths2 = depths2[seq(1, by = 2, length.out = 27),]
depths3 = depths3[seq(1, by = 2, length.out = 27),]

# x11()
# par(mfrow=c(3,1))
png(paste0(simu,"_depth.png") , width = 1050 , height = 850 , res=120)

mat <- matrix(c(1,2,3), 3, 1, byrow = TRUE)
nf <- layout(mat, widths = c(20), height = c(9,9,9), TRUE)

# days = seq(from=1,by=, length.out = 27)
days = seq(1,27,2)
length.arrow = 0.03
####

par(mar = c(3, 2, 1, 2) + 0.1)
plot(depths1[,1], type="l", ylab="", xlab="", ylim=c(ylim,0), axes=F)
arrows(x0 = 1:length(depths1[,1]) , y0= depths1[,2],
       x1 = 1:length(depths1[,1]) , y1= depths1[,3],
       code=3, angle=90, length=length.arrow)
mtext("Depth (m)", 2, line = 2.5)
axis(2)
axis(1, at = days, labels = days)
legend("topleft", legend = paste("Release Depth", a[1]), bty = "n")

####
par(mar = c(3, 2, 1, 2) + 0.1)
plot(depths2[,1], type="l", ylab="", xlab="", ylim=c(ylim,0), axes=F)
arrows(x0 = 1:length(depths2[,1]) , y0= depths2[,2],
       x1 = 1:length(depths2[,1]) , y1= depths2[,3],
       code=3, angle=90, length=length.arrow)
mtext("Depth (m)", 2, line = 2.5)
axis(2)
axis(1, at = days, labels = days)
legend("topleft", legend = paste("Release Depth", a[2]), bty = "n")

####
par(mar = c(3, 2, 1, 2) + 0.1)
plot(depths3[,1], type="l", ylab="", xlab="", ylim=c(ylim,0), axes=F)
arrows(x0 = 1:length(depths3[,1]) , y0= depths3[,2],
       x1 = 1:length(depths3[,1]) , y1= depths3[,3],
       code=3, angle=90, length=length.arrow)
mtext("Days" , 1, line = 2, cex= .8)
mtext("Depth (m)", 2, line = 2.5)
axis(2)
axis(1, at = days, labels = days)
legend("topleft", legend = paste("Release Depth", a[3]), bty = "n")
    
dev.off()

library(beepr)
beep(8, "EL TRABAJO FUE REALIZADO")


##########################

# min(dataset$depth)
# # dataset = as.data.frame(dataset$month, dataset$depth)
# 
# firstdrifter = 1
# lastdrifter  = 55
# 
# ### PLOT time_larval_depth  DAILY WINDS VS MONTHLY WINDS
# 
# depths = as.data.frame(time_larval_depth(particles, firstdrifter, lastdrifter))
# days = seq(from=1,by=2, length.out = 27)
# # plot(depths[days,1], type="l", ylim=c(-45,-15), main=paste("Sechura - Lobos / Montly winds"))
# plot(depths[days,1], type="l", ylim=c(-45,-15), main=paste("Sechura - Lobos / Daily winds"))
# 
# 
# 
# 
# 
# 
# 
# source("G:/ICHTHYOP/scripts/time_larval_depth.R")
# x11()
# par(mfrow=c(3,4))
# for(i in 7){
#   month = subset(dataset, dataset$month == i)
#   # if(dim(month) == NULL){
#   #   plot(1, type="n", axes=F, xlab="", ylab="")
#   # }else{
#     depths = as.data.frame(time_larval_depth(month, firstdrifter, lastdrifter))
#     days = seq(from=1,by=2, length.out = 27)
#     plot(depths[days,1], type="l", ylim=c(-70,0), main=paste("month", i))
#     # arrows(1:length(depths[days,1]) , y0= depths[days,2],
#     #        1:length(depths[days,1]) , y1= depths[days,3],
#     #        code=3, angle=90, length=0.05)
#   # }
# 
# }
# 
# 
# 
# 
# 
