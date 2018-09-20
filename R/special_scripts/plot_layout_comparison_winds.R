#===============================================================================
# Name   : plots_layout_comparison_winds
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : This plot a layout [1 , 2 , 3]
#===============================================================================
source('R/source/recruitment_year.R')
source('R/source/recruitment_day.R')
source('R/source/recruitment_depth.R')
source('R/source/recruitment_age.R')
source('R/source/plot_layout_3.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/recruited/'

simu  <- 'sechura'

# Don't change anything after here
if(simu == 'lobos'){
  ymax = 9    # 9 para retencion  ; # 0.2 para transporte
  ylab = 1    # 0 = larval transport ; 1 = larval retention
}else{
  ymax = 0.2  # 9 para retencion  ; # 0.2 para transporte
  ylab = 0    # 0 = larval transport ; 1 = larval retention
}

if(ylab == 1){
  ylab = 'Local Retention (%)'
}else{
  ylab = 'Transport Success(%)'
}

meses = c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

legend <- 0  # legend == 1 turn on legend, if 0, legned turn off
# legend.cex <- 1 # size of the legend inside the plot

daily_data <- read.csv(paste0(dirpath, 'daily_', simu, '.csv') , sep='')
daily_data <- subset(daily_data, daily_data$Year %in% c(2009:2011))

clim_data <- read.csv(paste0(dirpath, 'clim_', simu, '.csv') , sep='')
clim_data <- subset(clim_data, clim_data$Year %in% c(2009:2011))

daily_datayear  <- recruitment_year (daily_data)
daily_dataday   <- recruitment_day  (daily_data)
daily_datadepth <- recruitment_depth(daily_data)
daily_dataage   <- recruitment_age  (daily_data)

clim_datayear  <- recruitment_year (clim_data)
clim_dataday   <- recruitment_day  (clim_data)
clim_datadepth <- recruitment_depth(clim_data)
clim_dataage   <- recruitment_age  (clim_data)

### DATAYEAR
datayear       <- cbind(daily_datayear[,1],clim_datayear[,1])

year_mean <- NULL
for(i in 1:dim(datayear)[1]){
  a <- daily_datayear[i,2]
  b <- clim_datayear[i,2]
  d <- c(a,b)
  year_mean <- c(year_mean, d)
}

year_sem <- NULL
for(i in 1:dim(datayear)[1]){
  a <- daily_datayear[i,2]
  b <- clim_datayear[i,3]
  d <- c(a,b)
  year_sem <- c(year_sem, d)
}

### DATADAY
dataday        <- cbind(daily_dataday[,1],clim_dataday[,1])

day_mean <- NULL
for(i in 1:dim(dataday)[1]){
  a <- daily_dataday[i,2]
  b <- clim_dataday[i,2]
  d <- c(a,b)
  day_mean <- c(day_mean, d)
}

day_sem <- NULL
for(i in 1:dim(dataday)[1]){
  a <- daily_dataday[i,2]
  b <- clim_dataday[i,3]
  d <- c(a,b)
  day_sem <- c(day_sem, d)
}

### DATADEPTH
datadepth        <- cbind(daily_datadepth[,1],clim_datadepth[,1])

depth_mean <- NULL
for(i in 1:dim(datadepth)[1]){
  a <- daily_datadepth[i,2]
  b <- clim_datadepth[i,2]
  d <- c(a,b)
  depth_mean <- c(depth_mean, d)
}

depth_sem <- NULL
for(i in 1:dim(datadepth)[1]){
  a <- daily_datadepth[i,2]
  b <- clim_datadepth[i,3]
  d <- c(a,b)
  depth_sem <- c(depth_sem, d)
}

### DATAAGE
dataage        <- cbind(daily_dataage[,1],clim_dataage[,1])

age_mean <- NULL
for(i in 1:dim(dataage)[1]){
  a <- daily_dataage[i,2]
  b <- clim_dataage[i,2]
  d <- c(a,b)
  age_mean <- c(age_mean, d)
}

age_sem <- NULL
for(i in 1:dim(dataage)[1]){
  a <- daily_dataage[i,2]
  b <- clim_dataage[i,3]
  d <- c(a,b)
  age_sem <- c(age_sem, d)
}

## PLOT ##
col_bars <- c('grey20','grey80')
png(paste0(out_path, simu,'_plot_layout_comparison.png') ,width = 1050 , height = 350 , res=120)

mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
nf <- layout(mat, widths = c(8,8,8), height = c(8), TRUE)

### PLOT AS FUNCTION OF MONTH OF SPAWNING
par(mar=c(4 , 5 , 1.5 , 0.3))
dayplot   <- barplot(t(dataday[,c(1,2)]), beside = T, xlab="", ylab= "" ,ylim = c(0,ymax),
                     axes = FALSE, axisnames = FALSE, col = col_bars)
arrows(dayplot[1,],100*(daily_dataday[,2]+daily_dataday[,3]),
       dayplot[1,],100*(daily_dataday[,2]-daily_dataday[,3]),
       angle=90,code=3,length=0.025)
arrows(dayplot[2,],100*(clim_dataday[,2]+clim_dataday[,3]),
       dayplot[2,],100*(clim_dataday[,2]-clim_dataday[,3]),
       angle=90,code=3,length=0.025)
at <- (dayplot[1,] + dayplot[2,])/2
axis(1, at=at, labels = FALSE, tick = FALSE)
mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
text(at, par("usr")[3], labels = meses, srt = 45, adj = c(1.1,1.1), xpd = TRUE, cex=0.9)
mtext("Month of spawning", side=1, line=2.5 , cex=0.9)
legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars)

if(legend == 1){
  legend("topleft", "A)", bty = "n", cex = legend.cex)
}

### PLOT AS FUNCTION OF SPAWNING DEPTH
par(mar=c(4 , 5 , 1.5 , 0.3))
depthplot <- barplot(t(datadepth[,c(1,2)]), beside = T, xlab="", ylab="", ylim = c(0,ymax),
                     axes = FALSE, cex.names=.8, col = col_bars)
arrows(depthplot[1,],100*(daily_datadepth[,2]+daily_datadepth[,3]),
       depthplot[1,],100*(daily_datadepth[,2]-daily_datadepth[,3]),
       angle=90,code=3,length=0.025)
arrows(depthplot[2,],100*(clim_datadepth[,2]+clim_datadepth[,3]),
       depthplot[2,],100*(clim_datadepth[,2]-clim_datadepth[,3]),
       angle=90,code=3,length=0.025)
axis(2, lwd = 3, cex.axis = 1.4)
mtext("Spawning depth (m)", side=1, line=2.5, cex=0.9)
legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars)
# mtext(ylab, side=2, line=2.5 , cex=1.2)

if(legend == 1){
  legend("topleft", "B)", bty = "n", cex = legend.cex)
}

### PLOT AS FUNCTION OF AGE MINIMUN TO SETTLEMENT
par(mar=c(4 , 5 , 1.5 , 1))

ageplot   <- barplot(t(dataage[,c(1,2)]), beside = T, xlab="",ylab= "", ylim = c(0,ymax),
                     axes = FALSE, cex.names=.8, col = col_bars)
arrows(ageplot[1,],100*(daily_dataage[,2]+daily_dataage[,3]),
       ageplot[1,],100*(daily_dataage[,2]-daily_dataage[,3]),
       angle=90,code=3,length=0.025)
arrows(ageplot[2,],100*(clim_dataage[,2]+clim_dataage[,3]),
       ageplot[2,],100*(clim_dataage[,2]-clim_dataage[,3]),
       angle=90,code=3,length=0.025)
axis(2, lwd = 3, cex.axis = 1.4)
mtext('Minimum age to settlement (d)', side=1, line=2.5, cex=0.9)
legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars)
# mtext(ylab, side=2, line=2.5 , cex=1.2)

if(legend == 1){
  legend("topleft", "C)", bty = "n", cex = legend.cex)
}
dev.off()

#===============================================================================
# END OF PROGRAM
#===============================================================================