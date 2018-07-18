
setwd("~/Documentos/ICHTHYOP/ichthyop-3.2/output/trayectorias/")

### Parametros de la grafica

simulation  = "Transporte Sechrua-Lobos"
# simulation  = "Transporte Lobos-Sechura"
release     = 1
recruitment = 0
ylim        = c(-120,0)

mes= c("enero","febrero","marzo","abril","mayo","junio","julio",
         "agosto","septiembre","octubre","noviembre","diciembre")

# mat <- matrix(c(1:12), 3, 4, byrow = TRUE)
# nf <- layout(mat, widths = c(4, 4, 4 ,4), height = c(3,3,3), TRUE)

  mes           = mes[12]
  data          = read.csv(paste0(mes, ".csv"))
#   latis         = seq(-6.6, -5.7, 0.05)
  latis         = seq(-6.6, -5.1, 0.05)
  zona   = subset(data, release_zone == release & recruitment_zone == recruitment & depth <=0)
  traj   = cbind(zona$lat , zona$depth)
  
  mat = NULL
  for(j in 1:length(latis)-1){
    sub = subset(traj, traj[,1]>= latis[j] & traj[,1]< (latis[j]+0.05))# & traj[,2]>= -80)
    sub = sub[,2]
    
    x  = sub
    n  = length(x)
    m  = mean(x)
    s  = sd(x)
    a  = 0.05
    tt = -qt(a/2,n-1)
    ee = sd(x)/sqrt(n)  # error estandar, ES diferente a desviacion estandar
    e  = tt*ee          # margen de error
    d  = e/m            # error relativo, dice que el intervalo de confianza es un porcentaje del valor
    li = m-e            # limite superior
    ls = m+e            # limite inferior
    
    res = cbind(m , li , ls)
    mat = rbind(mat , res)
    mat[,3][mat[,3] >=0] = 0
    mat[,2][mat[,2] < (-120)] = -120
    
  }

# x11()
mat <- matrix(c(1:9), 3, 3, byrow = TRUE)
nf <- layout(mat, widths = c(4, 4, 4), height = c(3,3,3), TRUE)

png(paste0(simulation, "_",mes, ".png"), width = 780, height = 580, res=100)

  par(mar=c(5,4,1,1))
  plot(1:length(mat[,1]),rev(mat[,1]), type="l", ylim = ylim ,axes=FALSE,
         xlab="", ylab="")
  arrows(1:length(mat[,1]) , y0= rev(mat[,2]), 1:length(mat[,1]), y1=rev(mat[,3]),
         code=3, angle=90, length=0.1)
  axis(1, at=seq(1,length(latis),3), labels = rev(latis[seq(1,length(latis),3)]),cex=2)
  axis(2)
  mtext("Latitud (S°)", 1, line=2)
  mtext("Profundidad (m)", 2, line=2)
  mtext(paste0(simulation," ",mes), 1, at= 7, line=-1)
#   mtext("Sentido del transporte ( <=== )",1, at=15.5, line=-1)
  mtext("Sentido del transporte ( ===> )",1, at=25, line=-1)
dev.off()
