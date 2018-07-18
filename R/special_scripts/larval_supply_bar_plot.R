#===============================================================================
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
source('source/recruitment_day.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/recruited/'

dat <- read.table('F:/TESIS/TESIS_MAESTRIA/ARTICULO_SCALLOP/biomasa_poblacion/Sechura_Lobos.csv', sep = ';', header = T)
dat <- dat[-c(1:31),] # Elegir years 2008-2015
# dat <- subset(dat, dat[,2] < 10000)

winds <- 'daily'
transport_csv <- 'sechura_lobos'
retention_csv <- 'lobos'
#-------------------------------------------------------------------------------#
transport <- read.table(paste0(dirpath, winds,'_',transport_csv, '.csv'), header = T)
transport <- recruitment_day(transport)

retention <- read.table(paste0(dirpath, winds,'_',retention_csv, '.csv'), header = T)
retention <- recruitment_day(retention)

##----##
# Larval_supply_lobos1.png Usando el promedio de ambas series
# Larval_supply_lobos2.png Usando el promedio de ambas series entre 2008-2015
# Larval_supply_lobos3.png Usando status quo year 2015
# Larval_supply_lobos4.png Usando el maximo en Sechura y el promedio en Lobos
# Larval_supply_lobos5.png Años altos en biomasa > 10 000 T
# Larval_supply_lobos6.png Años altos en biomasa < 10 000 T


#----- Population in each zone---------------#
pop_sechura <- mean(dat[,3], na.rm = T) # millones de individuos
pop_lobos   <- mean(dat[,5], na.rm = T)  # millones de individuos

# pop_sechura <- dat[dim(dat)[1],3] # millones de individuos
# pop_lobos   <- dat[dim(dat)[1],5]  # millones de individuos

#-------Larvae number in each zone-----------#
larvae_sechura <- 2 * 10^5 * pop_sechura * 10^6  # 4 * 10^6 Fecundity
larvae_lobos   <- 2 * 10^5 * pop_lobos   * 10^6  # 4 * 10^6 Fecundity

#--------Transport and retention depend on direction of flux-------#
if(transport_csv == 'sechura_lobos'){
  abs_transport <- (transport[,1] * larvae_sechura)/10^9 # BILLIONS
  abs_retention <- (retention[,1] * larvae_lobos)/10^9 # BILLIONS
  main <- 'Larval Supply to Lobos de Tierra'
  pngfile <- paste0(out_path, 'Larval_supply_lobos.png')
  # ylim <- c(0 , 2.5*10^5)
  ylim <- c(0 , 4.5*10^5)
}else{
  abs_transport <- (transport[,1] * larvae_lobos)/10^9 # BILLIONS
  abs_retention <- (retention[,1] * larvae_sechura)/10^9 # BILLIONS
  main <- 'Larval Supply to Sechura'
  pngfile <- paste0(out_path, 'Larval_supply_sechura.png')
  ylim <- c(0 , 1.2*10^6)
}

bar_data <- rbind(abs_transport, abs_retention)
supply_area <- sum(bar_data)

#---Percentage of transport and retention for larvae supply -----#
percent_transport <- (sum(bar_data[1,]) * 100) / supply_area
percent_retention <- (sum(bar_data[2,]) * 100) / supply_area

# #-------PLOT-----#
# png(filename = pngfile, width = 650, height = 650, res = 120)
# barplot(bar_data, beside = T, col = c('grey80','grey20'),
#         main = main,
#         ylab = '',
#         ylim = ylim,
#         xlab = '')
# mtext(text = 'Months', side = 1, line = 2, font = 2)
# mtext(text = 'Billions of larvae', side = 2, line = 2, font = 2)
# legend('topright', legend = c(paste('Larval Transport -', round(percent_transport,2), '%'),
#                               paste('Larval Retention -', round(percent_retention,2), '%')),
#                               bty = 'n', fill = c('grey80','grey20'))
# dev.off()
#===============================================================================
# END OF PROGRAM
#===============================================================================