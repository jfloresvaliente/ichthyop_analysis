source('R/source/recruitment_year.R')
source('R/source/recruitment_day.R')
source('R/source/recruitment_depth.R')
source('R/source/recruitment_age.R')
source('R/source/recruitment_area.R')

dirpath  <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/'

winds <- 'daily'
simu  <- 'lobos'
simulacion <- paste0(winds,'_',simu)
file <- paste0(dirpath, simulacion, '.csv')

ylab = 'Larval Retention (%)'
# ylab = 'Local Retention (%)'

ymax = 8  # 9 para retencion  ; # 0.2 para transporte

dataset <- read.csv(file , sep='')
dataset <- subset(dataset, dataset$Year %in% c(2009:2011))

# datayear  <- recruitment_year (dataset)
dataday   <- recruitment_day  (dataset)

x <- 1:12
y <- dataday[,1]

months = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')
igs <- read.table('F:/SCALLOP_ARTICLE/csv_files/igs.csv', sep = ',', header = T)
igs <- igs$igs_prom

png(filename = 'F:/SCALLOP_ARTICLE/submitted/figures/IGS_larvalretention.png', width = 650, height = 650, res = 120)

par(mar = c(4,5,2,5))
graf = plot(x, y, type='l',axes=F, ylim=c(0,ymax), xlab='', ylab='',col='black',main='', lwd = 2)
axis(side = 1, at = 1:12, labels = months, lwd=2,line=0, col='black',col.axis = 'black', font = 2, las = 2)
axis(side = 2, lwd=2,line=0, col='black',col.axis = 'black',font = 2)
mtext(ylab, side=2, line=3. , cex=1.2, font = 2)

par(new=T)
plot(x, igs, axes=F, ylim = c(12,20), xlab="", ylab="", 
     type="l",lty=2, main="",lwd=2 , col="red")
axis(side=4, ylim=c(10,20),lwd=2,line=0, col='red',col.axis = 'red', font = 2)
mtext(text = 'Gonadosomatic Index', side = 4, col = 'red', font = 2, line = 3., cex = 1.2)

dev.off()

rm(list = ls())
