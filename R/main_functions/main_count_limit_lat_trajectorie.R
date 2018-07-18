#===============================================================================
# Name   : main_count_limit_lat_trajectorie
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    :
# URL    : 
#===============================================================================

dirpath <- 'D:/ICHTHYOP/final/processed/cfg/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
source('D:/ICHTHYOP/scripts/count_limit_lat_trajectorie.R')

winds <- 'daily'
dates <- paste0(dirpath,'timer_Ascat_', winds, '.csv') # this file must be consistent with the type of simulation
dates <- read.table(dates, header = T, sep = ';')
# dates <- subset(dates, dates[,1] %in% c(2009:2011))

filenames <- read.table(paste0(dirpath,winds,'_sechura_lobos_files.csv'))
filenames <- subset(filenames, filenames$V1 %in% c(2009:2011))
# filenames <- subset(filenames, filenames$V2 %in% c(1:5,10:12))
filenames <- as.vector(filenames[,3])

lat_limit <- -6.35
dat <- count_limit_lat_trajectorie(dates,filenames,lat_limit)

write.table(dat,paste0(out_path, 'passed_particles_',winds,'_sechura_lobos.csv'),
            row.names = F)

