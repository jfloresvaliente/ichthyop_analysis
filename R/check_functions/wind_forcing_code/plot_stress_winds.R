#===============================================================================
# Name   : plot_stress_winds
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('code/get_stress_winds.R')
zone <- 'bay'
points_file <- paste0('C:/Users/ASUS/Desktop/contour_plots/',zone,'/',zone,'.txt')

# dat <- get_stress_winds(points_file)
# CLIM  <- dat[[1]]
# DAILY <- dat[[2]]
# save(CLIM, file = paste0('output/',zone,'_clim_stress.RData'))
# save(DAILY,file = paste0('output/',zone,'_daily_stress.RData'))

year_rep <- 5
ylim <- c(0,0.065)
########## ########## PLOT ########## ##########
## Get intensity winds
clim <- sqrt(CLIM[[1]]^2+CLIM[[2]]^2); clim <- rep(clim,year_rep)
daily<- sqrt(DAILY[[1]]^2+DAILY[[2]]^2)

dates <- seq(1,length(daily),30)
month_vec <- NULL
for(j in 1:(length(dates)-1)){
  month <- mean(daily[dates[j]:(dates[j]+29)])
  month_vec <- c(month_vec,month)
}
daily <- month_vec

winds <- list(clim,daily)

## CLIM VS DAILY
tiff(paste0('output/',zone,'_regime_winds.tiff'), width = 1250, height = 850, res = 120)
plot(1:(12*year_rep),type = 'n', ylim = ylim, xlab = '',ylab = '',
     xaxt = 'n')
title('Wind forcing intensity', line = -2)
abline(v = c(1,seq(12,(12*year_rep),12)), lty = 2)
axis(1, at = 1:(12*year_rep), labels = rep(1:12,year_rep))
mtext(2, text = expression('Intensity Winds ' ~N/m^2), line = 2)
mtext(1, text = 'Months', line = 2)

color <- 1
for(i in 1:length(winds)){
  lines(winds[[i]], col = color, lwd = 2)
  color <- color + 1
}
legend(x = 48, y = 0.065, c('montly winds','daily winds'), lty = c(1,1),
       col = c(1,2), bty = 'n', lwd = c(2,2))
text(x = seq(6,60,12), y = rep(0.001,5), labels = c('year 1','year 2','year 3','year 4','year 5'))
dev.off()

## CLIMATOLOGICAL PATTERN
new_clim  <- apply(matrix(clim [13:48], nrow = 3, byrow = T), MARGIN = c(2), mean)
new_daily <- apply(matrix(daily[13:48], nrow = 3, byrow = T), MARGIN = c(2), mean)
new_winds <- list(new_clim,new_daily)

tiff(paste0('output/',zone,'_pattern_winds.tiff'), width = 1250, height = 850, res = 120)
plot(1:length(new_daily),type = 'n', ylim = c(0,0.065),xlab = '',ylab = '',
     xaxt = 'n')
title('Wind forcing intensity', line = -2)
axis(1, at = 1:length(new_daily), labels = rep(1:12,1))
mtext(2, text = expression('Intensity Winds ' ~N/m^2), line = 2)
mtext(1, text = 'Months', line = 2)

color <- 1
for(i in 1:length(winds)){
  lines(new_winds[[i]], col = color, lwd = 2)
  color <- color + 1
}
legend(x = 9, y = 0.065, c('montly winds','daily winds'), lty = c(1,1),
       col = c(1,2), bty = 'n', lwd = c(2,2))
text(x = seq(6,length(new_daily),12), y = rep(0.001,1), labels = c('climatological year'))
dev.off()


