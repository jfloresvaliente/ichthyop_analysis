start.time <- Sys.time()
dirpath = 'D:/ICHTHYOP/final/processed/trajectories/'
# dirpath = '/run/media/marissela/JORGE_OLD/ICHTHYOP/final/processed/trajectories/'
source('D:/ICHTHYOP/scripts/plot_traj_ggmap.R')
# source('/run/media/marissela/JORGE_OLD/ICHTHYOP/scripts/plot_traj_ggmap.R')
## TO PLOT EACH MONTH SECHURA --> LOBOS

## Prepare dataset
winds = 'daily'
simu = 'sechura_lobos'

# Limits for color path
color.limits <- c(-100,0) # for depth
# color.limits <- c(1,28) # for days

# Release 0 == off release depth
release = 0

## PLOT TRAJECTORIES FOR EACH MONTH
for(i in 5:5){
  
  dat = read.table(paste0(dirpath, 'traj_', winds,'_', simu, i,'.csv'),header = T)
  days = rep(1:28, times = length(dat[,1])/28)
  dat = cbind(dat, days)
  # dat = subset(dat, dat$drifter %in% seq(1, length(dat[,1]), by=10))
  
  ini_pos = subset(dat, dat$lat > -5.65)
  ini_pos = subset(ini_pos, ini_pos$days == 1)
  
  fin_par = ini_pos$drifter; length(fin_par)
  
  
  for(j in fin_par){
    dat2 = subset(dat, dat$drifter == j)
    plot_traj_each_drifter(df = dat2,color.limits = color.limits,release = release,
                           month = i, pngfile = paste0(dirpath, '/particle/particle_month_',i,'_', j,'.jpeg'))
  }
  
  # plot_traj_ggmap(df = dat,color.limits = color.limits,release = release,
  #                 month = i, pngfile = paste0(dirpath, 'traj_depth_', winds,'_', simu, i,'.jpeg'))

}


### Plot a specific particle

color.limits = c(-69,-4)
particle = 345
dat2 = subset(dat, dat$drifter == particle)
plot_traj_each_drifter(df = dat2,color.limits = color.limits,release = release,
                       month = i, pngfile = paste0(dirpath, '/particle/particle_month_',i,'_', particle,'.jpeg'))

lon = dat2$lon[1]
lat = dat2$lat[2]


for(i in 5:5){
  
  dat = read.table(paste0(dirpath, 'traj_', winds,'_', simu, i,'.csv'),header = T)
  days = rep(1:28, times = length(dat[,1])/28)
  dat = cbind(dat, days)
  # dat = subset(dat, dat$drifter %in% seq(1, length(dat[,1]), by=10))
  
  ini_pos = subset(dat, dat$lon > -81.1 & dat$lat < -5.65)
  ini_pos = subset(ini_pos, ini_pos$days == 1)
  
  fin_par = ini_pos$drifter; length(fin_par)
  
  
  for(j in fin_par){
    dat2 = subset(dat, dat$drifter == fin_par)
    dat2[1,2] = lon
    dat2[1,3] = lat
    plot_traj_each_drifter(df = dat2,color.limits = color.limits,release = release,
                           month = i, pngfile = paste0(dirpath, '/particle/particle_month_',i,'_', j,'.jpeg'))
  }
  
  # plot_traj_ggmap(df = dat,color.limits = color.limits,release = release,
  #                 month = i, pngfile = paste0(dirpath, 'traj_depth_', winds,'_', simu, i,'.jpeg'))
  
}


# end.time <- Sys.time()
# time.taken <- end.time - start.time
# print(time.taken)
# rm(list=ls())|


# library(beepr)
# beep(8, "EL TRABAJO FUE REALIZADO")