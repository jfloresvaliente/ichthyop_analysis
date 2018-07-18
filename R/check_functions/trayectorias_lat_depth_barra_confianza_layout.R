#===============================================================================
# Name   : Plot larval tracking from release_zone to recruitment_zone 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
# setwd("~/Documentos/ICHTHYOP/ichthyop-3.2/output/trayectorias/")
dirpath = "C:/Users/ASUS/Desktop/"

### Parametros de la grafica

# simulation  = "Transport Sechrua-Lobos"
simulation  = "clim_lobos_e_tracking.csv"
# release     = 0
# recruitment = 1
ylim        = c(-120,0)
lim_inf     = -120

meses= c("January","February","March","April","May","June","July",
         "August","September","October","November","December")

# mes= c("enero","febrero","marzo","abril","mayo","junio","julio",
#        "agosto","septiembre","octubre","noviembre","diciembre")

# leer = c(1:4,8:12)
# leer = c(1:2,5:7,9,11,12)
leer = 1:12

# png(paste0(simulation, ".png"), width = 1050, height = 1050, res=140)
for(i in leer) {
  data = read.csv(paste0(mes[i], ".csv"))
#   latis         = seq(-6.6, -5.7, 0.05)
  latis         = seq(-6.6, -5.1, 0.05)
  zona   = subset(data, release_zone == release & recruitment_zone == recruitment & depth <=0)
  traj   = cbind(zona$lat , zona$depth)
  
### Encontrar la media, limite superior e inferior y guardarlo en "mat"  
  mat = NULL
  for(j in 1:length(latis)-1){
    sub = subset(traj, traj[,1]>= latis[j] & traj[,1]< (latis[j]+0.05) & traj[,2]>= -120)
    sub = sub[,2]
    
    x  = sub; n  = length(x); m  = mean(x); s  = sd(x)
    a  = 0.05 # confianza 
    tt = -qt(a/2,n-1)
    ee = sd(x)/sqrt(n)  # error estandar, ES diferente a desviacion estandar
    e  = tt*ee          # margen de error
    d  = e/m            # error relativo, dice que el intervalo de confianza es un porcentaje del valor
    li = m-e            # limite superior
    ls = m+e            # limite inferior
    
    res = cbind(m , li , ls)
    mat = rbind(mat , res)
    mat[,3][mat[,3] >=0] = 0
    mat[,2][mat[,2] < lim_inf] = lim_inf
  }
  
  if(i == 1){
    mati <- matrix(c(1:9), 3, 3, byrow = TRUE)
#     nf <- layout(mati, widths = c(4.3, 4.3, 4.3), height = c(3.5,3.5,3.5), TRUE)
    nf <- layout(mati, widths = c(4.5, 4.5, 4.5), height = c(5,5,5), TRUE)
    
    par(mar=c(2.2,1.3,0.6,1))
    plot(1:length(mat[,1]),rev(mat[,1]), type="l", ylim = ylim ,axes=FALSE,
         xlab="", ylab="")
    arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
           code=3, angle=90, length=0.1)
    axis(1, at=seq(1,length(latis),4), labels = rev(latis[seq(1,length(latis),4)]),cex=1)
    axis(2, at=seq(0,lim_inf,-20), labels = seq(0,lim_inf,-20),cex=5)
    mtext(meses[i], 1, at= 7, line=-1)
    box()
    
  }else{
    par(mar=c(2.2,1.3,0.6,1))
    plot(1:length(mat[,1]),rev(mat[,1]), type="l", ylim = ylim ,axes=FALSE,
         xlab="", ylab="")
    arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
           code=3, angle=90, length=0.1)
    axis(1, at=seq(1,length(latis),4), labels = rev(latis[seq(1,length(latis),4)]),cex=1)
    axis(2, at=seq(0,lim_inf,-20), labels = seq(0,lim_inf,-20),cex=5)
    mtext(meses[i], 1, at= 7, line=-1)
    box()
  }

}
# dev.off()

