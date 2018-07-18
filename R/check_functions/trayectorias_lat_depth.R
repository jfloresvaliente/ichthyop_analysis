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
simulation  = "clim_lobos_e_tracking"

#release_depth // 1 = menos profundo, 2 = profundidad media, 3 = mas profundo
release_depth = c(1,2,3)
data = read.csv(paste0(dirpath,simulation,".csv"))

lim_inf     = -100

## ------- DON'T CHANGE ANYTHING AFTER HERE ------ ##


ylim  = c(lim_inf,0)
meses = c("January","February","March","April","May","June","July",
          "August","September","October","November","December")
mes   = 1:12 ; year  = 1:4
x11()
# if(simulation == "trajectories_sechura_lobos"){
if(simulation == simulation){
  latis = seq(-6.6, -5.1, 0.05)
}else{
  latis = seq(-6.6, -5.1, 0.05)  
}

# png(paste0(simulation, "_" ,release_depth,".png"), width = 1250, height = 1050, res=140)
# png(paste0(simulation,".png"), width = 1250, height = 1050, res=140)
for(i in mes){
  
#   zona   = subset(data, depth <=0, release_depth == release_depth)
zona =data
  traj   = cbind(zona$lat , zona$depth, zona$month, zona$release_depth)
  
  ### Encontrar la media, limite superior e inferior y guardarlo en "mat"  
  mat = NULL
  for(j in 1:length(latis)-1){
    sub = subset(traj, traj[,1]>= latis[j] & traj[,1]< (latis[j]+0.05) & traj[,2]>= lim_inf & traj[,3]==mes[i] & traj[,4]==release_depth)
    sub = sub[,2]
    
    x  = sub ; n = length(x) ; m = mean(x) ; s = sd(x)
    a  = 0.05           # confianza 
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
  
  if(i == mes[1]){
    mati <- matrix(c(1:12), 3, 4, byrow = TRUE)
    nf <- layout(mati, widths = c(4.7, 4.7, 4.7, 4.7), height = c(5,5,5), TRUE)
  }
  
  if(i == mes[1] | i == mes[5] | i == mes[9]){
    par(mar=c(2.9, 1.8, 0.6, 0.7))
    plot(1:length(mat[,1]),rev(mat[,1]), type="l", ylim = ylim ,axes=FALSE,
         xlab="", ylab="")
    arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
           code=3, angle=90, length=0.1)
    axis(1, at=seq(1,length(latis),4), labels = rev(latis[seq(1,length(latis),4)]),cex=1)
    axis(2, at=seq(0,lim_inf,-20), labels = seq(0,lim_inf,-20),cex=5, line=-1, tick=FALSE)
    mtext(meses[i], 1, at= 7, line=-1)
    box()
    
  }else{
    par(mar=c(2.9, 1.8, 0.6, 0.7))
    plot(1:length(mat[,1]),rev(mat[,1]), type="l", ylim = ylim ,axes=FALSE,
         xlab="", ylab="")
    arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
           code=3, angle=90, length=0.1)
    axis(1, at=seq(1,length(latis),4), labels = rev(latis[seq(1,length(latis),4)]),cex=1)
    axis(2, at=seq(0,lim_inf,-20), labels = seq(0,lim_inf,-20),cex=5, line=-1, tick=FALSE)
    mtext(meses[i], 1, at= 7, line=-1)
    box()
  }
}
# dev.off()

