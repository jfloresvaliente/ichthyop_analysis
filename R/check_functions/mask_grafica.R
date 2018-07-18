setwd("G:/ROMS_SIMULATIONS/NoTides_ClimWind")
library(ncdf)
nc = open.ncdf("newperush_avg.Y2000.M2.extjflores.nc")

mask = get.var.ncdf(nc, "mask_rho")
mask = mask[272:311, 102:221]
data = mask

x <- (1:nrow(data))
y <- (1:ncol(data))

par(mar=c(3,3,1,1))
image(y, x, t(data), col = heat.colors(20), 
      axes=FALSE,xlab="",ylab="",srt=45)
grid = grid(nx=120,ny=40,col="black",lty="solid")
# image(mask, axes=FALSE)
# axis(1, at = 1:ncol(data), labels=colnames(data),srt=45,tick=FALSE)

# axis(2, at = 1:nrow(data), labels=rownames(data),srt=45,tick=FALSE)
axis(1, at = seq(0,ncol(data),5), labels=seq(0,ncol(data),5),srt=45,tick=FALSE)
axis(2, at = seq(0,nrow(data),5), labels=seq(0,nrow(data),5),srt=45,tick=FALSE)

