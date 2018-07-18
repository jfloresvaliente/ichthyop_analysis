#===============================================================================
# Name   : main_plot_traj_Ichthyop_v3_ggmap
# Author : Lett; modified by Jorge Flores
# Date   : 
# Version:
# Aim    : Set parameters for plot_traj_Ichthyop_v3_ggmap function
# URL    : 
#===============================================================================

# The netcdf input file
dirpath = 'D:/ICHTHYOP/final/output_2nd/daily_lobos_t1/'
filename = 'daily_lobos_ichthyop-run201701271043_s292.nc'

setwd(dirpath)

ncfile= paste0(dirpath, filename)
nc = nc_open(ncfile)

firsttime <- 1
lasttime  <- 55
# Name of the simulation
simulation = 'sechura_lobos'

firstdrifter  <- 1
lastdrifter   <- as.numeric(ncatt_get(nc, 0, 'release.zone.number_particles')$value)
# lastdrifter   <- 250
pngfile=NULL

source('D:/ICHTHYOP/scripts/plot_traj_Ichthyop_v3_ggmap.R')
x11()
plot_traj_Ichthyop_v3_ggmap(ncfile, firstdrifter, lastdrifter,
                            firsttime, lasttime, pngfile)
