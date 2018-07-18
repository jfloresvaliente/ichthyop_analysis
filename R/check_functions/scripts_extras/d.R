
dirpath = 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'

# source('D:/ICHTHYOP/scripts/plot_traj_ggmap.R')

## Prepare dataset
vientos = c('clim', 'daily')
simu = 'sechura_lobos'

# i = 5
# dat = read.table(paste0(dirpath, 'traj_', winds,'_', simu, i,'.csv'),header = T)
# days = rep(1:28, times = length(dat[,1])/28)
# dat = cbind(dat, days)
# 
# ini_pos = subset(dat, dat$days == 1)
# 
# color.limits = c(-64,-4)
# release = 0
# 
# 
# plot_traj_each_drifter(df = ini_pos,color.limits = color.limits,release = release,
#                        month = i, pngfile = paste0(dirpath, '/particle/pos_ini' , '.jpeg'))


List = list()
for(j in vientos){
  winds = j
  
  mid = -5.55
  zones = NULL
  for(i in 1:12){
    
    dat = read.table(paste0(dirpath, 'traj_', winds,'_', simu, i,'.csv'),header = T)
    north = subset(dat, dat$lat >= mid); north = dim(north)[1]/28
    south = subset(dat, dat$lat <  mid); south = dim(south)[1]/28
    
    prop = c(north, south)
    zones = rbind(zones, prop)
  }
  
  
  total = rep(sum(zones), times = dim(zones)[1])
  zones = cbind(zones, total)
  zones[,1] = (zones[,1] * 100 / total)
  zones[,2] = (zones[,2] * 100 / total)

  row.names(zones) = 1:12
  

  List[[length(List)+1]] = zones
}

# png(paste0(dirpath,'particles_transported.png'),width = 1050, height = 950, res = 120)
x11()
par(mfrow = c(1,2))
for(p in 1:length(List)){
  zones = List[[p]][,1:2]
  total = List[[p]][1,3]
  barplot(t(zones), beside = T, ylim = c(0,40), ylab = '% of particles transported successfully',yaxt ='n')
  axis(2, at = seq(0,40,2), labels = seq(0,40,2), las = 2)
  legend_labels = c(paste('North path', round(sum(zones[,1]),3),'%'), paste('South path',round(sum(zones[,2]),3),'%'))
  legend('topright', legend = legend_labels,
         fill = c('black', 'grey'), bty = 'n', cex = 0.75)
  abline(h= c(0.5,5), lty = 2)
  labels = c(paste('Total paricles transported', total), paste(toupper(vientos[p]), 'WINDS'))
  text(x = c(14,14), y = c(35,34), labels = labels, cex = 0.75, adj = 0)
  
}

# dev.off()

