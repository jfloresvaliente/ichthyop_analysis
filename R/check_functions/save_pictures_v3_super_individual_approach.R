#===============================================================================
# Name   : Save figures from ICHTHYOP outputs
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================

### Set working directory
# setwd("C:/JORGE_FLORES/ICHTHYOP_OUTPUT/")
# dirpath = "C:/JORGE_FLORES/ICHTHYOP_OUTPUT/output/"
# filename = "superindividuo_lobos"
# days = 25
#===============================================================================
### DON'T CHANGE ANYTHING AFTER HERE

meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# dataset = data
dataset = read.csv(paste0(dirpath , filename , ".csv"),sep=",")

dataset = read.csv("sechura_lobos.csv")
# dataset = subset(dataset, dataset$Age == days)
# dataset=data
# if(dataset$Release_zone[1] == dataset$Recruitment_zone[1]){
#   ylab = 'Larval Retention (%)'
# }else{
#   ylab = 'Larval Transport Success(%)'
# }

# 151654.4


if(dataset$Release_zone[1] == dataset$Recruitment_zone[1]){
  ylab = 'Larval Retention (10^6)'
}else{
  ylab = 'Larval Transport Success(10^6)'
}

# CALCULO DE RECLUTAMIENTO ------------------------------------------------

# Computa el porcentaje (%) de reclutas por cada release area, year, day, depth, age and behavior
# dataarea     <- 100*tapply(as.numeric(dataset[,13]),dataset[,3],sum)/tapply(as.numeric(dataset[,14]),dataset[,3],sum)
# datayear     <- 100*tapply(as.numeric(dataset[,13]),dataset[,4],sum)/tapply(as.numeric(dataset[,14]),dataset[,4],sum)
# dataday      <- 100*tapply(as.numeric(dataset[,13]),dataset[,5],sum)/tapply(as.numeric(dataset[,14]),dataset[,5],sum)
# datadepth    <- 100*tapply(as.numeric(dataset[,13]),dataset[,6],sum)/tapply(as.numeric(dataset[,14]),dataset[,6],sum)
# dataage      <- 100*tapply(as.numeric(dataset[,13]),dataset[,7],sum)/tapply(as.numeric(dataset[,14]),dataset[,7],sum)
# databehavior <- 100*tapply(as.numeric(dataset[,13]),dataset[,10],sum)/tapply(as.numeric(dataset[,14]),dataset[,10],sum)
# datatemp     <- 100*tapply(as.numeric(dataset[,13]),dataset[,11],sum)/tapply(as.numeric(dataset[,14]),dataset[,11],sum)

# Computa el valor absoluto de reclutas por cada release area, year, day, depth, age and behavior
dataarea     <- tapply(as.numeric(dataset[,13]),dataset[,3],sum)/10^6
datayear     <- tapply(as.numeric(dataset[,13]),dataset[,4],sum)/10^6
dataday      <- tapply(as.numeric(dataset[,13]),dataset[,5],sum)/10^6
datadepth    <- tapply(as.numeric(dataset[,13]),dataset[,6],sum)/10^6
dataage      <- tapply(as.numeric(dataset[,13]),dataset[,7],sum)/10^6
databehavior <- tapply(as.numeric(dataset[,13]),dataset[,10],sum)/10^6
datatemp     <- tapply(as.numeric(dataset[,13]),dataset[,11],sum)/10^6


# An inner function that computes statistics of recruitment for a given factor
compute_recruitment_stats <- function(released,recruited,factor){
  mean <- tapply(recruited,factor,sum)/tapply(released,factor,sum)
  var <- tapply(recruited^2,factor,sum)/tapply(released^2,factor,sum)-mean^2
  sem <- sqrt(var/table(factor))
  return(cbind(mean,sem))
}

# COMPUTE STATS -----------------------------------------------------------
# Computes stats (mean, std error of the mean) of recruitment for every release area, year, day, and depth

# dataarea_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,3]))
# dataarea_mean     = dataarea_stats[,1]
# dataarea_sem      = dataarea_stats[,2]
# 
# datayear_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,4]))
# datayear_mean     = datayear_stats[,1]
# datayear_sem      = datayear_stats[,2]
# 
# dataday_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,5]))
# dataday_mean      = dataday_stats[,1]
# dataday_sem       = dataday_stats[,2]
# 
# datadepth_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),dataset[,6])
# datadepth_mean    = datadepth_stats[,1]
# datadepth_sem     = datadepth_stats[,2]
# 
# dataage_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,7]))
# dataage_mean      = dataage_stats[,1]
# dataage_sem       = dataage_stats[,2]
# 
# databehavior_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,10]))
# databehavior_mean = databehavior_stats[,1]
# databehavior_sem  = databehavior_stats[,2]
# 
# datatemp_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),dataset[,11])
# datatemp_mean     = datatemp_stats[,1]
# datatemp_sem      = datatemp_stats[,2]

# PLOTEAR RESULTADOS ------------------------------------------------------

# variable.number = 3

# 3 = mes de desove, profundidad de desove, edad minima de asentamiento

### El valor maximo para el reclutamiento (in %) [ylim]
# ymax = max(dataarea , datayear , dataday , datadepth , dataage , databehavior , datatemp) 
# ymax = ymax + 0.4 * (ymax)
ymax = 26000
ymax = 1.5*10^6 #  1014779
# png(filename=paste0(filename , ".png") , width = 1050 , height = 350 , res=120) 
# mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
# nf <- layout(mat, widths = c(8,8,8), height = c(8), TRUE)
# 
# ### GRAFICO EN FUNCION DEL MES DE DESOVE
# 
# par(mar=c(4 , 5 , 1.5 , 0.3))
# dayplot   <- barplot(dataday, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
# arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)  
# axis(1, at=dayplot, labels = FALSE, tick = FALSE)
# axis(2, lwd = 3, cex.axis = 1.4)
# text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
# mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
# mtext(ylab           , side=2, line=2.5 , cex=1.2)
# legend("topleft", "A)", bty = "n", cex = 2)
# 
# ### GRAFICO EN FUNCION DE LA PROFUNDIDAD DE DESOVE
# par(mar=c(4 , 4 , 1.5 , 0.3))
# depthplot <- barplot(datadepth, xlab="", ylab="", ylim = c(0,ymax), axes = FALSE, cex.names=1.2)
# arrows(depthplot,100*(datadepth_mean+datadepth_sem),depthplot,100*(datadepth_mean-datadepth_sem),angle=90,code=3,length=0.05)
# axis(2, lwd = 3, cex.axis = 1.4)
# mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
# legend("topleft", "B)", bty = "n", cex = 2)
# 
# ### GRAFICO EN FUNCION DE LA EDAD MINIMA DE RECLUTAMIENTO
# 
# par(mar=c(4 , 4 , 1.5 , 1))
# ageplot   <- barplot(dataage, xlab="",ylab= "", ylim = c(0,ymax), axes = FALSE, cex.names=1.2)
# arrows(ageplot,100*(dataage_mean+dataage_sem),ageplot,100*(dataage_mean-dataage_sem),angle=90,code=3,length=0.05)
# axis(2, lwd = 3, cex.axis = 1.4)
# mtext("Age minimum to settlement (d)", side=1, line=2.5, cex=0.9)
# legend("topleft", "C)", bty = "n", cex = 2)
# 
# # dev.off()



x11()
# png(filename=paste0(filename ,"_superindividuo_", days, "days", ".png") , width = 700 , height = 750 , res=120) 
# png(filename=paste0(filename , ".png") , width = 700 , height = 750 , res=120) 
mat <- matrix(c(1,2,3,4), 2, 2, byrow = TRUE)
nf <- layout(mat, widths = c(8,8,8,8), height = c(8,8), TRUE)

### GRAFICO EN FUNCION DEL AÑO
par(mar=c(4 , 5 , 1.5 , 0.3))
yearplot   <- barplot(datayear, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
# arrows(yearplot,100*(datayear_mean+datayear_sem),yearplot,100*(datayear_mean-datayear_sem),angle=90,code=3,length=0.05)  
axis(1, at=yearplot, labels = FALSE, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
text(yearplot, par("usr")[3], labels = 1:4, srt = 0, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Year simulation", side=1, line=2.5 , cex=0.9)
mtext(ylab, side=2, line=2.5 , cex=1.2)
legend("topleft", "A)", bty = "n", cex = 2)

### GRAFICO EN FUNCION DEL MES DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
dayplot   <- barplot(dataday, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
# arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)  
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
legend("topleft", "B)", bty = "n", cex = 2)

### GRAFICO EN FUNCION DE LA PROFUNDIDAD DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
depthplot <- barplot(datadepth, xlab="", ylab="", ylim = c(0,ymax), axes = FALSE, cex.names=1.2)
# arrows(depthplot,100*(datadepth_mean+datadepth_sem),depthplot,100*(datadepth_mean-datadepth_sem),angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
mtext(ylab, side=2, line=2.5 , cex=1.2)
legend("topleft", "C)", bty = "n", cex = 2)

### GRAFICO EN FUNCION DE LA EDAD MINIMA DE RECLUTAMIENTO

par(mar=c(4 , 5 , 1.5 , 1))
ageplot   <- barplot(dataage, xlab="",ylab= "", ylim = c(0,ymax), axes = FALSE, cex.names=1.2)
# arrows(ageplot,100*(dataage_mean+dataage_sem),ageplot,100*(dataage_mean-dataage_sem),angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Age minimum to settlement (d)", side=1, line=2.5, cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
legend("topleft", "D)", bty = "n", cex = 2)

# dev.off()












# par(mfrow = c(2,2))
# barplot(sechura_lobos, ylim = c(0,0.15))
# barplot(lobos_sechura, ylim = c(0,0.15))
# barplot(sechura, ylim = c(0,8))
# barplot(lobos, ylim = c(0,8))
# 
# 
# sec_lob = sechura_lobos
# sec_lob = as.numeric(sec_lob)
# 
# lob_sec = lobos_sechura
# lob_sec = as.numeric(lob_sec)
# 
# sec_lob= sec_lob[sec_lob >= 0.000001]
# lob_sec= lob_sec[lob_sec >= 0.000001]
# 
# 
# wilcox.test(sec_lob, lob_sec)





