#===============================================================================
# Name   : ------
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : -----
# URL    : 
#===============================================================================
library(abind)
directory <- 'F:/ichthyop_output_analysis/RUN2/csv_files/tracking_mean_depth/'
out_path  <- 'F:/ichthyop_output_analysis/RUN2/figures/tracking_mean_depth/'

ylim <- c(-60,0)
xlim <- c(-82,-80.6)
winds <- 'clim'
simu <- 'lobos'

if(winds == 'daily') a <- 'Daily' else a <- 'Clim'
if(simu == 'lobos')  b <- 'Lobos' else b <- 'SechuraLobos'

recruited <- paste0('Traj',a,b,'Recruited')#'TrajDailyLobosRecruited'
nonrecruited <- paste0('Traj',a,b,'NonRecruited')#'TrajDailyLobosNonRecruited'

# figname <- paste0('Traj', a,b,d)
figname <- paste0(a, b,'_lonVsDepth')

### Reclutados
depthMean1 <- array(data = NA, dim = c(28,3,3,12))
for(i in 1:12){
  # csvfile <- paste0(directory, recruited, i, '.csv')
  csvfile <- paste0('F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
                    , 'traj_',winds,'_', simu, i, '.csv')
  dat <- read.table(csvfile, header = T)
  print(csvfile)
  
  if(i == 1){Releases <- levels(factor(dat$ReleaseDepth))}
  
  depth <- NULL
  for(m in Releases){
    dat2 <- subset(dat, dat$ReleaseDepth == m)
    if(dim(dat2)[1]==0)
    {a <- array(NA, dim = c(28,3))  
    }else{
      lon <- tapply(dat2$Lon, list(dat2$Day), mean, na.rm = T)
      lat <- tapply(dat2$Lat, list(dat2$Day), mean, na.rm = T)
      prof <- tapply(dat2$Depth, list(dat2$Day), mean, na.rm = T)
      a <- cbind(lon, lat, prof)
      # a = tapply(dat2$Depth, list(dat2$Day), mean, na.rm = T)
    }
    depth <- abind(depth,a, along = 3)
  }
  depthMean1[,,,i] <- depth
}
depthMean1 <- apply(depthMean1, c(1,2,3), mean, na.rm = T)

### No reclutados
depthMean2 <- array(data = NA, dim = c(28,3,3,12))
for(i in 1:12){
  csvfile <- paste0(directory, nonrecruited, i, '.csv')
  dat <- read.table(csvfile, header = T)
  print(csvfile)
  
  if(i == 1){Releases <- levels(factor(dat$ReleaseDepth))}
  
  depth <- NULL
  for(m in Releases){
    dat2 <- subset(dat, dat$ReleaseDepth == m)
    if(dim(dat2)[1]==0)
    {a <- array(NA, dim = c(28,3))  
    }else{
      lon <- tapply(dat2$Lon, list(dat2$Day), mean, na.rm = T)
      lat <- tapply(dat2$Lat, list(dat2$Day), mean, na.rm = T)
      prof <- tapply(dat2$Depth, list(dat2$Day), mean, na.rm = T)
      a <- cbind(lon, lat, prof)
      # a = tapply(dat2$Depth, list(dat2$Day), mean, na.rm = T)
    }
    depth <- abind(depth,a, along = 3)
  }
  depthMean2[,,,i] <- depth
}
depthMean2 <- apply(depthMean2, c(1,2,3), mean, na.rm = T)


#### #### Plot #### #### ####
png(paste0(out_path, figname, '.png'), width = 850, height = 650, res = 120)
par(mar = c(3,3,1,1))
plot(depthMean1[,1,1], depthMean1[,3,1], type = 'n',ylim = ylim, xlim = xlim, ylab = '', xlab = '', axes = F)
mtext('Longitude', side = 1, line = 2)
mtext('Depth', side = 2, line = 2)
axis(1)
axis(2)
axis(4)
box()

lty = c('dashed','dotted','dotdash')
for(i in 1:3){
  lines(depthMean1[,1,i], depthMean1[,3,i], lty = lty[i], col = 'red' , lwd = c(2,2,2))
  points(depthMean1[1,1,i], depthMean1[1,3,i], col = 'red', cex = 3.)
  
  lines(depthMean2[,1,i], depthMean2[,3,i], lty = lty[i], col = 'blue', lwd = c(2,2,2))
  points(depthMean2[1,1,i], depthMean2[1,3,i], col = 'blue', cex = 3.)
}
legend('bottomright', legend = c(Releases,Releases), bty = 'n', title = 'Release Depths',
       lty =c(lty,lty), lwd = rep(2,6), col = c(rep('red',3),rep('blue',3)), ncol = 2, cex = .85)
dev.off()

