#=============================================================================#
# Name   : main_compute_recruitment_winds
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Compute recruitment ICHTHYOP outputs (from any folder)
#          Special script for simulatios made by different forcing winds
# URL    : 
#=============================================================================#
library(ncdf4)
source('R/source/compute_recruitment_ichthyop_winds.R')

# This directory contains directories with nc output files stored
directory <- 'G:/ICHTHYOP/final/output_4th/'
outPath  <- 'F:/ichthyop_output_analysis/CONCIMAR2018/'

# To read 'xml' files from a directory different to original directory
old_path <- '/run/media/lmoecc/JORGE_NEW/ICHTHYOP/ichthyop-3.2/cfg/'  # path written in each ncdf input file
new_path <- 'F:/ichthyop_output_analysis/RUN4/cfg/'                      # path where '.xml' files are stored

winds <- 'clim'
simu <- 'sechura'

# The number of release zones
nbreleasezones <- 1

# The index of the recruitment zone for which recruitment is computed
# RUN 2 <- 1 = WEST , 2 = EAST, 3 = SECHURA
# RUN 4 <- 1 = LOBOS, 2 = SECHURA
recruitmentzone <- 2

# The maximum value of the larval retention/transport success for ylabel in the plot (in %)
ymax <- 8

#============ Do not change anything from here, unless you know what you do. ============#
dirpath <- paste0(directory, winds, '_', simu)
time_ini <- Sys.time()
outFileCsv <- paste0(winds, '_', simu)

# In case one wishes to consider only a subset of all drifters
firstdrifter <- 1         #Index of first drifter to be compued
lastdrifter  <- 20000     #Index of last drifter to be computed

# The time record at which to compute recruitment
computeattime <- 61
dates <- paste0('timer_Ascat_', winds, '.csv')

dataset <- compute_recruitment_ichthyop_winds(
  dirpath,
  firstdrifter,
  lastdrifter,
  computeattime,
  nbreleasezones,
  recruitmentzone,
  ymax,
  old_path,
  new_path,
  dates)

## Choose only three years fron the simulation
dataset <- subset(dataset, dataset$Year %in% c(2009:2011))
write.table(dataset, file = paste0(outPath,outFileCsv, '.csv'), row.names = F, sep = ';')
# write.table(dataset, file = paste0(outPath, 'clim_lobos_sechura.csv'), row.names = F)

time_end <- Sys.time()
print(time_end - time_ini)
#=============================================================================#
# END OF PROGRAM
#=============================================================================#