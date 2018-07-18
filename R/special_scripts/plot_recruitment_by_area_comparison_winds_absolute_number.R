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

### NUEMERO DE LARVAS EN CADA ZONA
dat <- read.table('F:/TESIS/TESIS_MAESTRIA/concha_sechura_lobos.csv', sep = ';', header = T)

#----- Population in each zone---------------#
pop_sechura <- max(dat$Sechura_poblacion, na.rm = T) # millones de individuos
pop_lobos   <- mean(dat$Lobos_poblacion, na.rm = T)  # millones de individuos

#-------Number of Larvae in each zone-----------#
larvae_sechura <- 2 * 10^5 * pop_sechura * 10^6  # 4 * 10^6 Fecundity
larvae_lobos   <- 2 * 10^5 * pop_lobos   * 10^6  # 4 * 10^6 Fecundity

#### #### ###
# dat1 <- read.table(paste0(dirpath, 'clim_sechura_lobos.csv'), sep = '', header = T)
dat2 <- read.table(paste0(dirpath, 'daily_sechura_lobos.csv'), sep = '', header = T)
# dat1 <- recruitment_day(dat1); dat1 <- dat1[,1] * larvae_sechura; dat1 <- sum(dat1)
dat2 <- recruitment_day(dat2) ; dat2 <- dat2[,1] * larvae_sechura; dat2 <- sum(dat2)

# dat3 <- read.table(paste0(dirpath, 'clim_lobos_sechura.csv'), sep = '', header = T)
dat4 <- read.table(paste0(dirpath, 'daily_lobos_sechura.csv'), sep = '', header = T)
# dat3 <- recruitment_day(dat3) ; dat3 <- dat3[,1] * larvae_lobos; dat3 <- sum(dat3)
dat4 <-recruitment_day(dat4)  ; dat4 <- dat4[,1] * larvae_lobos; dat4 <- sum(dat4)

# dat5 <- read.table(paste0(dirpath, 'clim_sechura.csv'), sep = '', header = T)
dat6 <- read.table(paste0(dirpath, 'daily_sechura.csv'), sep = '', header = T)
# dat5 <- recruitment_day(dat5) ; dat5 <- dat5[,1] * larvae_sechura; dat5 <- sum(dat5)
dat6 <- recruitment_day(dat6) ; dat6 <- dat6[,1] * larvae_sechura; dat6 <- sum(dat6)

# dat7 <- read.table(paste0(dirpath, 'clim_lobos.csv'), sep = '', header = T)
dat8 <- read.table(paste0(dirpath, 'daily_lobos.csv'), sep = '', header = T)
# dat7 <- recruitment_day(dat7) ; dat7 <- dat7[,1] * larvae_lobos; dat7 <- sum(dat7)
dat8 <- recruitment_day(dat8) ; dat8 <- dat8[,1] * larvae_lobos; dat8 <- sum(dat8)

### 
sechura_lobos <- rbind(dat2)/10^9
lobos_sechura <- rbind(dat4)/10^9
sechura       <- rbind(dat6)/10^9
lobos         <- rbind(dat8)/10^9

# png(paste0(out_path, 'plot_recruitment_by_area_comparison_RUN2_absolute_number.png') ,width = 1050 , height = 850 , res=120)
### plot
par(mfrow = c(2,2))
col_bars <- c('grey20','grey80')
labels <- c('Daily Winds', 'Monthly Winds')

bars <- barplot(c(lobos, sechura_lobos, sechura, lobos_sechura),
        col = col_bars)
#-------Sechura - Lobos -------#
ymax <- 19000

sechura_lobos_plot <-  barplot(sechura_lobos[,1], xlab="" ,ylim = c(0,ymax),
                               axes = FALSE, axisnames = FALSE, col = col_bars)
mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# arrows(sechura_lobos_plot,100*(sechura_lobos[,2]+sechura_lobos[,3]),
#        sechura_lobos_plot,100*(sechura_lobos[,2]-sechura_lobos[,3]),
#        angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars, cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Transport', 'Sechura - Lobos')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)

#-------Lobos - Sechura -------#
ymax <- ymax
lobos_sechura_plot <-  barplot(lobos_sechura[,1], xlab="" ,ylim = c(0,ymax),
                               axes = FALSE, axisnames = FALSE, col = col_bars)
mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# arrows(lobos_sechura_plot,100*(lobos_sechura[,2]+lobos_sechura[,3]),
#        lobos_sechura_plot,100*(lobos_sechura[,2]-lobos_sechura[,3]),
#        angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Transport', 'Lobos - Sechura')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)

#-------Sechura -------#
ymax <- 460000
sechura_plot <-  barplot(sechura[,1], xlab="" ,ylim = c(0,ymax),
                         axes = FALSE, axisnames = FALSE, col = col_bars)
mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# arrows(sechura_plot,100*(sechura[,2]+sechura[,3]),
#        sechura_plot,100*(sechura[,2]-sechura[,3]),
#        angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Retention', 'Sechura Bay')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)

#-------Lobos -------#
ymax <- ymax
lobos_plot <-  barplot(lobos[,1], xlab="" ,ylim = c(0,ymax),
                       axes = FALSE, axisnames = FALSE, col = col_bars)
mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# arrows(lobos_plot,100*(lobos[,2]+lobos[,3]),
#        lobos_plot,100*(lobos[,2]-lobos[,3]),
#        angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Retention', 'Lobos de Tierra Island')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)

# dev.off()

#---- back up ---------#
# source('source/recruitment_day.R')
# 
# dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
# out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/recruited/'
# 
# ### NUEMERO DE LARVAS EN CADA ZONA
# dat <- read.table('F:/TESIS/TESIS_MAESTRIA/concha_sechura_lobos.csv', sep = ';', header = T)
# 
# #----- Population in each zone---------------#
# pop_sechura <- max(dat$Sechura_poblacion, na.rm = T) # millones de individuos
# pop_lobos   <- mean(dat$Lobos_poblacion, na.rm = T)  # millones de individuos
# 
# #-------Larvae number in each zone-----------#
# larvae_sechura <- 2 * 10^5 * pop_sechura * 10^6  # 4 * 10^6 Fecundity
# larvae_lobos   <- 2 * 10^5 * pop_lobos   * 10^6  # 4 * 10^6 Fecundity
# 
# #### #### ###
# dat1 <- read.table(paste0(dirpath, 'clim_sechura_lobos.csv'), sep = '', header = T)
# dat2 <- read.table(paste0(dirpath, 'daily_sechura_lobos.csv'), sep = '', header = T)
# dat1 <- recruitment_day(dat1); dat1 <- dat1[,1] * larvae_sechura; dat1 <- sum(dat1)
# dat2 <-recruitment_day(dat2) ; dat2 <- dat2[,1] * larvae_sechura; dat2 <- sum(dat2)
# 
# dat3 <- read.table(paste0(dirpath, 'clim_lobos_sechura.csv'), sep = '', header = T)
# dat4 <- read.table(paste0(dirpath, 'daily_lobos_sechura.csv'), sep = '', header = T)
# dat3 <- recruitment_day(dat3) ; dat3 <- dat3[,1] * larvae_lobos; dat3 <- sum(dat3)
# dat4 <-recruitment_day(dat4)  ; dat4 <- dat4[,1] * larvae_lobos; dat4 <- sum(dat4)
# 
# dat5 <- read.table(paste0(dirpath, 'clim_sechura.csv'), sep = '', header = T)
# dat6 <- read.table(paste0(dirpath, 'daily_sechura.csv'), sep = '', header = T)
# dat5 <- recruitment_day(dat5) ; dat5 <- dat5[,1] * larvae_sechura; dat5 <- sum(dat5)
# dat6 <- recruitment_day(dat6) ; dat6 <- dat6[,1] * larvae_sechura; dat6 <- sum(dat6)
# 
# dat7 <- read.table(paste0(dirpath, 'clim_lobos.csv'), sep = '', header = T)
# dat8 <- read.table(paste0(dirpath, 'daily_lobos.csv'), sep = '', header = T)
# dat7 <- recruitment_day(dat7) ; dat7 <- dat7[,1] * larvae_lobos; dat7 <- sum(dat7)
# dat8 <- recruitment_day(dat8) ; dat8 <- dat8[,1] * larvae_lobos; dat8 <- sum(dat8)
# 
# ### 
# sechura_lobos <- rbind(dat2, dat1)/10^9
# lobos_sechura <- rbind(dat4, dat3)/10^9
# sechura       <- rbind(dat6, dat5)/10^9
# lobos         <- rbind(dat8, dat7)/10^9
# 
# # png(paste0(out_path, 'plot_recruitment_by_area_comparison_RUN2_absolute_number.png') ,width = 1050 , height = 850 , res=120)
# ### plot
# par(mfrow = c(2,2))
# col_bars <- c('grey20','grey80')
# labels <- c('Daily Winds', 'Monthly Winds')
# 
# #-------Sechura - Lobos -------#
# ymax <- 19000
# 
# sechura_lobos_plot <-  barplot(sechura_lobos[,1], xlab="" ,ylim = c(0,ymax),
#                                axes = FALSE, axisnames = FALSE, col = col_bars)
# mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# # arrows(sechura_lobos_plot,100*(sechura_lobos[,2]+sechura_lobos[,3]),
# #        sechura_lobos_plot,100*(sechura_lobos[,2]-sechura_lobos[,3]),
# #        angle=90,code=3,length=0.05)
# axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# # mtext(ylab, side=2, line=2.5 , cex=1.2)
# axis(2, lwd = 3, cex.axis = 1.4)
# # legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars, cex = 0.5)
# # bquote  aprender esta funcion
# Lines <- list('Larval Transport', 'Sechura - Lobos')
# mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)
# 
# #-------Lobos - Sechura -------#
# ymax <- ymax
# lobos_sechura_plot <-  barplot(lobos_sechura[,1], xlab="" ,ylim = c(0,ymax),
#                                axes = FALSE, axisnames = FALSE, col = col_bars)
# mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# # arrows(lobos_sechura_plot,100*(lobos_sechura[,2]+lobos_sechura[,3]),
# #        lobos_sechura_plot,100*(lobos_sechura[,2]-lobos_sechura[,3]),
# #        angle=90,code=3,length=0.05)
# axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# axis(2, lwd = 3, cex.axis = 1.4)
# # legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# # bquote  aprender esta funcion
# Lines <- list('Larval Transport', 'Lobos - Sechura')
# mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)
# 
# #-------Sechura -------#
# ymax <- 460000
# sechura_plot <-  barplot(sechura[,1], xlab="" ,ylim = c(0,ymax),
#                          axes = FALSE, axisnames = FALSE, col = col_bars)
# mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# # arrows(sechura_plot,100*(sechura[,2]+sechura[,3]),
# #        sechura_plot,100*(sechura[,2]-sechura[,3]),
# #        angle=90,code=3,length=0.05)
# axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# axis(2, lwd = 3, cex.axis = 1.4)
# # legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# # bquote  aprender esta funcion
# Lines <- list('Larval Retention', 'Sechura Bay')
# mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)
# 
# #-------Lobos -------#
# ymax <- ymax
# lobos_plot <-  barplot(lobos[,1], xlab="" ,ylim = c(0,ymax),
#                        axes = FALSE, axisnames = FALSE, col = col_bars)
# mtext(text = 'Billions of larvae', side = 2, lwd = 3, line = 2.3)
# # arrows(lobos_plot,100*(lobos[,2]+lobos[,3]),
# #        lobos_plot,100*(lobos[,2]-lobos[,3]),
# #        angle=90,code=3,length=0.05)
# axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# axis(2, lwd = 3, cex.axis = 1.4)
# # legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# # bquote  aprender esta funcion
# Lines <- list('Larval Retention', 'Lobos de Tierra Island')
# mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 1)
# 
# # dev.off()

#===============================================================================
# END OF PROGRAM
#===============================================================================
