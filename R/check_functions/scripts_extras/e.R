
dirpath = 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'

# source('D:/ICHTHYOP/scripts/plot_traj_ggmap.R')

## Prepare dataset
vientos = c('clim', 'daily')
simu = 'sechura_lobos'

List = list()
for(j in vientos){
  winds = j
  
  zones = NULL
  for(i in 1:12){
    
    dat = read.table(paste0(dirpath, 'traj_', winds,'_', simu, i,'.csv'),header = T)
    if(i == 1) labs = c(levels(dat$release_depth)) 
    
    lev1 = subset(dat, dat$release_depth == levels(dat$release_depth)[1]); lev1 = dim(lev1)[1]/28
    lev2 = subset(dat, dat$release_depth == levels(dat$release_depth)[2]); lev2 = dim(lev2)[1]/28
    lev3 = subset(dat, dat$release_depth == levels(dat$release_depth)[3]); lev3 = dim(lev3)[1]/28
    
    prop = c(lev1, lev2, lev3)
    zones = rbind(zones, prop)
  }
  
  total = rep(sum(zones), times = dim(zones)[1])
  zones = cbind(zones, total)
  zones[,1] = (zones[,1] * 100 / total)
  zones[,2] = (zones[,2] * 100 / total)
  zones[,3] = (zones[,3] * 100 / total)
  
  row.names(zones) = 1:12
  List[[length(List)+1]] = zones
  
}


# png(paste0(dirpath,'particles_reteined_bydepth.png'),width = 1050, height = 950, res = 120)
x11()
par(mfrow = c(1,2))
ylim = 32
for(p in 1:length(List)){
  zones = List[[p]][,1:3]
  total = List[[p]][1,3]
  barplot(t(zones), beside = T, ylim = c(0,ylim), ylab = '% of particles reteined',yaxt ='n',
          col = c('green','blue','red'))
  axis(2, at = seq(0,ylim,2), labels = seq(0,ylim,2), las = 2)
  labs_legend = c(paste(labs[1],'  ',round(sum(zones[,1]),3),'%'),
                  paste(labs[2],'  ',round(sum(zones[,2]),3),'%'),
                  paste(labs[3],'  ',round(sum(zones[,3]),3),'%'))
  legend('topright', legend = labs_legend,
         fill = c('green','blue','red'), bty = 'n', cex = 0.75)
  abline(h=.5, lty = 2)
  labels = c(paste('Total paricles reteined', total), paste( toupper(vientos[p]), 'WINDS'))
  # labels = c(paste('Total paricles transported', total), paste( toupper(vientos[p]), 'WINDS'))
  text(x = c(17,17), y = c(12,11.5), labels = labels, cex = 0.75, adj = 0)
  
}


# dev.off()

