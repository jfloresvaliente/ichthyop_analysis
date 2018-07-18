#===============================================================================
# Name   : save_pictures_v3
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : Save figures from ICHTHYOP outputs
#===============================================================================

### Set working directory
# setwd("G:/ICHTHYOP/final/processed/csv")
# dirpath = "G:/ICHTHYOP/final/processed/csv/sechura_lobos/"
filename = "lobos_e"

file = "G:/ICHTHYOP/final/processed/csv/sechura_lobos/daily_sechura_lobos_e_t1.csv"
  
t_x = 10
id = "daily"
# days = 25
#===============================================================================
### DON'T CHANGE ANYTHING AFTER HERE

meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# data  = read.csv(paste0(dirpath , filename , ".csv"),sep=",")
dataset  = read.csv(file , sep=",")
# dataset = subset(dataset, dataset[,4]==2009|dataset[,4]==2010|dataset[,4]==2011)
# dataset = subset(data, data$t_x == 1 & data$id == "clim") 

years = 1:4
ymax = 0.3

if(dataset$Release_zone[1] == dataset$Recruitment_zone[1]){
  ylab = 'Larval Retention (%)'
  }else{
  ylab = 'Larval Transport Success(%)'
}

# CALCULO DE RECLUTAMIENTO ------------------------------------------------

# Computa el porcentaje (%) de reclutas por cada release area, year, day, depth, age and behavior
dataarea     <- 100*tapply(as.numeric(dataset[,2]),dataset[,3],sum)/tapply(as.numeric(dataset[,1]),dataset[,3],sum)
datayear     <- 100*tapply(as.numeric(dataset[,2]),dataset[,4],sum)/tapply(as.numeric(dataset[,1]),dataset[,4],sum)
dataday      <- 100*tapply(as.numeric(dataset[,2]),dataset[,5],sum)/tapply(as.numeric(dataset[,1]),dataset[,5],sum)
datadepth    <- 100*tapply(as.numeric(dataset[,2]),dataset[,6],sum)/tapply(as.numeric(dataset[,1]),dataset[,6],sum)
dataage      <- 100*tapply(as.numeric(dataset[,2]),dataset[,7],sum)/tapply(as.numeric(dataset[,1]),dataset[,7],sum)
databehavior <- 100*tapply(as.numeric(dataset[,2]),dataset[,10],sum)/tapply(as.numeric(dataset[,1]),dataset[,10],sum)
datatemp     <- 100*tapply(as.numeric(dataset[,2]),dataset[,11],sum)/tapply(as.numeric(dataset[,1]),dataset[,11],sum)

# An inner function that computes statistics of recruitment for a given factor
compute_recruitment_stats <- function(released,recruited,factor){
  mean <- tapply(recruited,factor,sum)/tapply(released,factor,sum)
  var <- tapply(recruited^2,factor,sum)/tapply(released^2,factor,sum)-mean^2
  sem <- sqrt(var/table(factor))
  return(cbind(mean,sem))
}

# COMPUTE STATS -----------------------------------------------------------
# Computes stats (mean, std error of the mean) of recruitment for every release area, year, day, and depth

dataarea_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,3]))
dataarea_mean     = dataarea_stats[,1]
dataarea_sem      = dataarea_stats[,2]

datayear_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,4]))
datayear_mean     = datayear_stats[,1]
datayear_sem      = datayear_stats[,2]

dataday_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,5]))
dataday_mean      = dataday_stats[,1]
dataday_sem       = dataday_stats[,2]

datadepth_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),dataset[,6])
datadepth_mean    = datadepth_stats[,1]
datadepth_sem     = datadepth_stats[,2]

dataage_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,7]))
dataage_mean      = dataage_stats[,1]
dataage_sem       = dataage_stats[,2]

databehavior_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,10]))
databehavior_mean = databehavior_stats[,1]
databehavior_sem  = databehavior_stats[,2]

datatemp_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),dataset[,11])
datatemp_mean     = datatemp_stats[,1]
datatemp_sem      = datatemp_stats[,2]

# PLOTEAR RESULTADOS ------------------------------------------------------

# variable.number = 3

# 3 = mes de desove, profundidad de desove, edad minima de asentamiento

## El valor maximo para el reclutamiento (in %) [ylim]
# ymax = max(dataarea , datayear , dataday , datadepth , dataage , databehavior , datatemp)
# ymax = ymax + 0.4 * (ymax)
# ymax = .25
# png(filename=paste0(filename , ".png") , width = 1050 , height = 350 , res=120)
# mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
# nf <- layout(mat, widths = c(8,8,8), height = c(8), TRUE)

### GRAFICO EN FUNCION DEL MES DE DESOVE

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

# dev.off()

png(filename=paste0(filename,"_", id, t_x ,"_3" , ".png") ,width = 1050 , height = 350 , res=120)

# png(filename=paste0(filename , ".png") , width = 1050 , height = 350 , res=120)
# x11()
mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
nf <- layout(mat, widths = c(8,8,8), height = c(8), TRUE)

### GRAFICO EN FUNCION DEL MES DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
dayplot   <- barplot(dataday, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "B)", bty = "n", cex = cex)

### GRAFICO EN FUNCION DE LA PROFUNDIDAD DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
depthplot <- barplot(datadepth, xlab="", ylab="", ylim = c(0,ymax), axes = FALSE, cex.names=.8)
arrows(depthplot,100*(datadepth_mean+datadepth_sem),depthplot,100*(datadepth_mean-datadepth_sem),angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "C)", bty = "n", cex = cex)

### GRAFICO EN FUNCION DE LA EDAD MINIMA DE RECLUTAMIENTO

par(mar=c(4 , 5 , 1.5 , 1))
ageplot   <- barplot(dataage, xlab="",ylab= "", ylim = c(0,ymax), axes = FALSE, cex.names=.8)
arrows(ageplot,100*(dataage_mean+dataage_sem),ageplot,100*(dataage_mean-dataage_sem),angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Age minimum to settlement (d)", side=1, line=2.5, cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "D)", bty = "n", cex = cex)

dev.off()

######## STAR PLOT ########

png(filename=paste0(filename,"_", id, t_x ,"_4", ".png") , width = 700 , height = 750 , res=120)
mat <- matrix(c(1,2,3,4), 2, 2, byrow = TRUE)
nf <- layout(mat, widths = c(8,8,8,8), height = c(8,8), TRUE)

cex = 0.8
### GRAFICO EN FUNCION DEL AÑO
par(mar=c(4 , 5 , 1.5 , 0.3))
yearplot   <- barplot(datayear, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(yearplot,100*(datayear_mean+datayear_sem),yearplot,100*(datayear_mean-datayear_sem),angle=90,code=3,length=0.05)
axis(1, at=yearplot, labels = FALSE, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
text(yearplot, par("usr")[3], labels = years, srt = 0, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Year simulation", side=1, line=2.5 , cex=0.9)
mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "A)", bty = "n", cex = cex)

### GRAFICO EN FUNCION DEL MES DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
dayplot   <- barplot(dataday, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)
axis(1, at=dayplot, labels = FALSE, tick = FALSE)
# axis(2, lwd = 3, cex.axis = 1.4)
text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "B)", bty = "n", cex = cex)

### GRAFICO EN FUNCION DE LA PROFUNDIDAD DE DESOVE

par(mar=c(4 , 5 , 1.5 , 0.3))
depthplot <- barplot(datadepth, xlab="", ylab="", ylim = c(0,ymax), axes = FALSE, cex.names=.8)
arrows(depthplot,100*(datadepth_mean+datadepth_sem),depthplot,100*(datadepth_mean-datadepth_sem),angle=90,code=3,length=0.05)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "C)", bty = "n", cex = cex)

### GRAFICO EN FUNCION DE LA EDAD MINIMA DE RECLUTAMIENTO

par(mar=c(4 , 5 , 1.5 , 1))
ageplot   <- barplot(dataage, xlab="",ylab= "", ylim = c(0,ymax), axes = FALSE, cex.names=.8)
arrows(ageplot,100*(dataage_mean+dataage_sem),ageplot,100*(dataage_mean-dataage_sem),angle=90,code=3,length=0.05)
# axis(2, lwd = 3, cex.axis = 1.4)
mtext("Age minimum to settlement (d)", side=1, line=2.5, cex=0.9)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
# legend("topleft", "D)", bty = "n", cex = cex)

dev.off()

# ######## END PLOT ########
#
#
#
#
#
#
#
#
#

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






