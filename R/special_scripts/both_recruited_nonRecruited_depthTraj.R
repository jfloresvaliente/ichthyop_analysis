#===============================================================================
# Name   : ------
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : -----
# URL    : 
#===============================================================================
directory <- 'F:/ichthyop_output_analysis/RUN2/csv_files/tracking_mean_depth/'
out_path  <- 'F:/ichthyop_output_analysis/RUN2/figures/tracking_mean_depth/'

ylim <- c(-60,0)
winds <- 'clim'
simu <- 'lobos'

if(winds == 'daily') a <- 'Daily' else a <- 'Clim'
if(simu == 'lobos')  b <- 'Lobos' else b <- 'SechuraLobos'

recruited <- paste0('Traj',a,b,'Recruited')#'TrajDailyLobosRecruited'
nonrecruited <- paste0('Traj',a,b,'NonRecruited')#'TrajDailyLobosNonRecruited'

# figname <- paste0('Traj', a,b,d)

figname <- paste0(a, b)

### Reclutados
depthMean1 <- array(data = NA, dim = c(28,3,12))
for(i in 1:12){
  csvfile <- paste0(directory, recruited, i, '.csv')
  dat <- read.table(csvfile, header = T)
  print(csvfile)
  
  if(i == 1){Releases <- levels(factor(dat$ReleaseDepth))}
  
  depth <- NULL
  for(m in Releases){
    dat2 <- subset(dat, dat$ReleaseDepth == m)
    if(dim(dat2)[1]==0)
      {a = rep(NA, times = 28)
      }else{
       a = tapply(dat2$Depth, list(dat2$Day), mean, na.rm = T)
      }
    depth = cbind(depth,a)
  }
  # depth <- tapply(dat$Depth, list(dat$Day, dat$ReleaseDepth), mean)
  # if(length(eval(colnames(depth))) < 3){
  depthMean1[,,i] <- depth
}

depthMean1 <- apply(depthMean1, c(1,2), mean, na.rm = T)

### No reclutados
depthMean2 <- array(data = NA, dim = c(28,3,12))
for(j in 1:12){
  csvfile <- paste0(directory, nonrecruited, j, '.csv')
  dat <- read.table(csvfile, header = T)
  print(csvfile)
  depth <- tapply(dat$Depth, list(dat$Day, dat$ReleaseDepth), mean, na.rm = T)
  depthMean2[,,j] <- depth
}
depthMean2 <- apply(depthMean2, c(1,2), mean, na.rm = T)



#### #### Plot #### #### ####
png(paste0(out_path, figname, '.png'), width = 850, height = 650, res = 120)
par(mar = c(3,3,1,1))
plot(1:28, type = 'n',ylim = ylim, ylab = '', xlab = '', axes = F)
mtext('Days after Spawning', side = 1, line = 2)
mtext('Depth', side = 2, line = 2)
axis(1, at = 1:28, labels = 0:27)
axis(2)
axis(4)
box()

lty = c('dashed','dotted','dotdash')
for(i in 1:3){
  lines(depthMean1[,i], lty = lty[i], col = 'red' , lwd = c(2,2,2))
  lines(depthMean2[,i], lty = lty[i], col = 'blue', lwd = c(2,2,2))
}
legend('bottomright', legend = c(Releases,Releases), bty = 'n', title = 'Release Depths',
       lty =c(lty,lty), lwd = rep(2,6), col = c(rep('red',3),rep('blue',3)), ncol = 2, cex = .85)
dev.off()

