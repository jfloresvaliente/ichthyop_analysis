#===============================================================================
# Name   : Save figures from ICHTHYOP outputs
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================

### Path of .csv files
dirpath = "G:/ICHTHYOP/final/processed/csv/"
filename = "sechura_lobos_e"
# t_x = 1
# id = "daily"
# days = 25

meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

dataset = read.csv(paste0(dirpath , filename , ".csv"),sep=",")

# dataset = subset(dataset, dataset[,4]==2009|dataset[,4]==2010|dataset[,4]==2011)
# dataset = subset(dataset, dataset$t_x==1 & dataset$id=="daily")

years = 1:4
ymax = .35

if(dataset$Release_zone[1] == dataset$Recruitment_zone[1]){
  ylab = 'Larval Retention (%)'
}else{
  ylab = 'Larval Transport Success(%)'
}


compute_recruitment_graph <- function(dataset, name_sim, cex=.8){
  # CALCULO DE RECLUTAMIENTO ------------------------------------------------
  dataset = dataset
  # Computa el porcentaje (%) de reclutas por cada release area, year, day, depth, age and behavior
  # dataarea     <- 100*tapply(as.numeric(dataset[,2]),dataset[,3],sum)/tapply(as.numeric(dataset[,1]),dataset[,3],sum)
  # datayear     <- 100*tapply(as.numeric(dataset[,2]),dataset[,4],sum)/tapply(as.numeric(dataset[,1]),dataset[,4],sum)
  dataday      <- 100*tapply(as.numeric(dataset[,2]),dataset[,5],sum)/tapply(as.numeric(dataset[,1]),dataset[,5],sum)
  # datadepth    <- 100*tapply(as.numeric(dataset[,2]),dataset[,6],sum)/tapply(as.numeric(dataset[,1]),dataset[,6],sum)
  # dataage      <- 100*tapply(as.numeric(dataset[,2]),dataset[,7],sum)/tapply(as.numeric(dataset[,1]),dataset[,7],sum)
  # databehavior <- 100*tapply(as.numeric(dataset[,2]),dataset[,10],sum)/tapply(as.numeric(dataset[,1]),dataset[,10],sum)
  # datatemp     <- 100*tapply(as.numeric(dataset[,2]),dataset[,11],sum)/tapply(as.numeric(dataset[,1]),dataset[,11],sum)
  
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
  
  dataday_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,5]))
  dataday_mean      = dataday_stats[,1]
  dataday_sem       = dataday_stats[,2]
  
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
  
  
  ######## STAR PLOT ########
  
  # png(filename=paste0(filename,"_", id, t_x , ".png") , width = 700 , height = 750 , res=120)
  # mat <- matrix(c(1,2,3,4), 2, 2, byrow = TRUE)
  # nf <- layout(mat, widths = c(8,8,8,8), height = c(8,8), TRUE)
  
  cex = cex
  ### GRAFICO EN FUNCION DEL MES DE DESOVE
  mane_sim = name_sim
  par(mar=c(4 , 5 , 1.5 , 0.3))
  dayplot   <- barplot(dataday, xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
  arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)
  axis(1, at=dayplot, labels = FALSE, tick = FALSE)
  axis(2, lwd = 3, cex.axis = 1.4)
  text(dayplot, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
  mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
  # mtext(ylab, side=2, line=2.5 , cex=1.2)
  legend("topright", name_sim, bty = "n", cex = cex)
  
}
  


data1 = subset(dataset, dataset$t_x==1 & dataset$id=="daily")
data2 = subset(dataset, dataset$t_x==5 & dataset$id=="daily")
data3 = subset(dataset, dataset$t_x==10 & dataset$id=="daily")

data4 = subset(dataset, dataset$t_x==1 & dataset$id=="clim")
data5 = subset(dataset, dataset$t_x==5 & dataset$id=="clim")
data6 = subset(dataset, dataset$t_x==10 & dataset$id=="clim")

# x11()
png("sechura_lobos_transport.png" , width = 1200 , height = 750 , res=120)
mat <- matrix(c(1,2,3,4,5,6), 2, 3, byrow = TRUE)
nf <- layout(mat, widths = c(8,8,8), height = c(8,8), TRUE)

compute_recruitment_graph(data1, "daily winds-release day 1", cex = 1)
compute_recruitment_graph(data2, "daily winds-release day 10", cex = 1)
compute_recruitment_graph(data3, "daily winds-release day 20", cex = 1)
compute_recruitment_graph(data4, "montly winds-release day 1", cex = 1)
compute_recruitment_graph(data5, "montly winds-release day 10", cex = 1)
compute_recruitment_graph(data6, "montly winds-release day 20", cex = 1)

dev.off()
