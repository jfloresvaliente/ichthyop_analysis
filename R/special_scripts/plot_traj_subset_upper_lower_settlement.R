#===============================================================================
# Name   : ----
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('source/plot_traj_ggmap_depth.R')

dirpath     <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path    <- 'F:/ichthyop_output_analysis/RUN2/figures/subset_particles/'

winds <- 'daily'
simu <- 'lobos'

numParticles <- array(data = NA, dim = c(12,2))
for(i in 1:12){
  csvfile <- paste0(dirpath,'traj_', winds,'_', simu, i, '.csv')
  dat <- read.table(csvfile, header = T)
  
  dat2 <- subset(dat, dat$Day == 28)
  
  texts <- paste('Release Month', i)
  levelDepth <- -30
  latLimit <- -6.43
  
  upperSettle <- subset(dat, dat$Day == 28 & dat$Depth >= levelDepth & dat$Lat >= latLimit)
  upperSettle <- as.numeric(levels(factor(upperSettle$Drifter)))
  numUpper <- length(upperSettle)
  upperSettle <- subset(dat, dat$Drifter %in% upperSettle)
  pngfile <- paste0(out_path, 'upperSettle_',winds,'_', simu, i, '.png')
  plot_traj_ggmap_depth(df = upperSettle, color.limits = c(-60,0), pngfile = pngfile, texts = texts)
  
  
  lowerSettle <- subset(dat, dat$Day == 28 & dat$Depth < levelDepth & dat$Lat < latLimit)
  lowerSettle <- as.numeric(levels(factor(lowerSettle$Drifter)))
  numLower <- length(lowerSettle)
  lowerSettle <- subset(dat, dat$Drifter %in% lowerSettle)
  pngfile <- paste0(out_path, 'lowerSettle_',winds,'_', simu, i, '.png')
  plot_traj_ggmap_depth(df = lowerSettle, color.limits = c(-60,0), pngfile = pngfile, texts = texts)
  
  nums <- c(numUpper, numLower)
  numParticles[i,] <- nums
}

save(numParticles, file = paste0(out_path,'numParticles.RData'))
barplot(t(numParticles), beside = T)

