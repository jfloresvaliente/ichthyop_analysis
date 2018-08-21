#===============================================================================
# Name   : main_plots_ichthyop_byfactor
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('R/source/recruitment_year.R')
source('R/source/recruitment_day.R')
source('R/source/recruitment_depth.R')
source('R/source/recruitment_age.R')
source('R/source/recruitment_area.R')
source('R/source/plot_layout_3.R')
source('R/source/plot_layout_4.R')

dirpath  <- 'F:/ichthyop_output_analysis/CONCIMAR2018/'
out_path <- 'F:/ichthyop_output_analysis/CONCIMAR2018/'

winds <- 'clim'
simu  <- 'sechura'
simulacion <- paste0(winds,'_',simu)
file <- paste0(dirpath, simulacion, '.csv')

fig_name  <- paste0(out_path, simulacion, '_L3')
fig_name2 <- paste0(out_path, simulacion, '_L4')

# Don't change anything after here
if(simu == 'lobos' | simu == 'sechura'){
  ymax = 9    # 9 para retencion  ; # 0.2 para transporte
  ylab = 1    # 0 = larval transport ; 1 = larval retention
}else{
  ymax = 0.2  # 9 para retencion  ; # 0.2 para transporte
  ylab = 0    # 0 = larval transport ; 1 = larval retention
}
ymax <- 3
legend <- 0  # legend == 1 turn on legend, if 0, legned turn off
legend.cex <- 1 # size of the legend inside the plot

dataset <- read.csv(file , sep='')
dataset <- subset(dataset, dataset$Year %in% c(2009:2011))

datayear  <- recruitment_year (dataset)
dataday   <- recruitment_day  (dataset)
datadepth <- recruitment_depth(dataset)
dataage   <- recruitment_age  (dataset)
dataarea  <- recruitment_area (dataset)

# plot_layout_3(fig_name, ymax, ylab, legend, legend.cex)
# plot_layout_4(fig_name2, ymax, ylab, legend, legend.cex)

print(round(as.vector(dataday[,1]), digits = 4))
print(round(as.vector(datadepth[,1]), digits = 4))
print(round(as.vector(dataage[,1]), digits = 4))
print(round(as.vector(dataarea[,1]), digits = 4))
#===============================================================================
# END OF PROGRAM
#===============================================================================