
winds = 'daily'
lat_lim = -6.3

a = count_limit_lat_trajectorie(1 ,winds, -6.3)
b = count_limit_lat_trajectorie(5 ,winds, -6.3)
c = count_limit_lat_trajectorie(10,winds, -6.3)

d = rbind(a,b,c)

write.csv(d, paste0('passed_particles_', winds, '_sechura_lobos_', -100*(lat_lim),'.csv'), row.names = F)


########################### plot ##################


winds = c('clim','daily')

depths = c('0.0-10.0','10.0-20.0','20.0-30.0')
dirpath = '/run/media/marissela/JORGE_OLD/ICHTHYOP/final/processed/output_2nd/passed_particles_'


List <- list()
for(i in 1:length(depths)){
  months <- NULL
  for(j in 1:length(winds)){
    
    dat <- read.csv(paste0(dirpath,winds[j],'_sechura_lobos_', -100*(lat_lim), '.csv'), header = T)
    dat <- subset(dat, dat$Release_Depth == depths[i])
    
    a <- tapply(dat$NumberPassed, list(dat$Month), sum, na.rm = T)
    months <- rbind(months, a)
  }
  List[[length(List)+1]] <- months
}

############ PLOT ###################

ylim <- c(0,5E5)/1E6
for(i in 1:length(List)){
  png(paste0('passed_particles_',depths[i],'.png'), width = 950, height = 950, res = 120)
  dat <- List[[i]]/1E6
  barplot(dat, beside = T, ylim = ylim, ylab = paste('Particles passed LAT', lat_lim,'(10^6)'),
          col = c('red','blue'))
  legend('topright',winds, fill = c('red','blue'), bty = 'n',
         title = paste('Release Depth', depths[i]))
  dev.off()
}


ylim <- c(0,15E5)/1E6
png(paste0('passed_all_particles_.png'), width = 950, height = 950, res = 120)
dat <- (List[[1]] + List[[2]] + List[[3]])/1E6
barplot(a, beside = T, ylim = ylim,ylab = paste('Particles passed LAT', lat_lim, '(10^6)'),
        col = c('red','blue'))
legend('topright',winds, fill = c('red','blue'), bty = 'n',
       title = paste('All particles'))
dev.off()
  