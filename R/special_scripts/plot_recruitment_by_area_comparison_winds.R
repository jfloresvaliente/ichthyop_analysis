
source('source/recruitment_area.R')

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/figures/recruited/'

dat1 <- read.table(paste0(dirpath, 'clim_sechura_lobos.csv'), sep = '', header = T)
dat2 <- read.table(paste0(dirpath, 'daily_sechura_lobos.csv'), sep = '', header = T)
dat1 <- recruitment_area(dat1)
dat2 <-recruitment_area(dat2)

dat3 <- read.table(paste0(dirpath, 'clim_lobos_sechura.csv'), sep = '', header = T)
dat4 <- read.table(paste0(dirpath, 'daily_lobos_sechura.csv'), sep = '', header = T)
dat3 <- recruitment_area(dat3)
dat4 <-recruitment_area(dat4)

dat5 <- read.table(paste0(dirpath, 'clim_sechura.csv'), sep = '', header = T)
dat6 <- read.table(paste0(dirpath, 'daily_sechura.csv'), sep = '', header = T)
dat5 <- recruitment_area(dat5)
dat6 <- recruitment_area(dat6)

dat7 <- read.table(paste0(dirpath, 'clim_lobos.csv'), sep = '', header = T)
dat8 <- read.table(paste0(dirpath, 'daily_lobos.csv'), sep = '', header = T)
dat7 <- recruitment_area(dat7)
dat8 <- recruitment_area(dat8)

### 
sechura_lobos <- rbind(dat2, dat1)
lobos_sechura <- rbind(dat4, dat3)
sechura       <- rbind(dat6, dat5)
lobos         <- rbind(dat8, dat7)

# png(paste0(out_path, 'plot_recruitment_by_area_comparison_RUN2.png') ,width = 1050 , height = 850 , res=120)
### plot
x11()
col_bars <- c('grey20','grey80')
ymax = 0.04
labels <- c('Daily Winds', 'Monthly Winds')
par(mfrow = c(2,2))

sechura_lobos_plot <-  barplot(sechura_lobos[,1], xlab="", ylab= "" ,ylim = c(0,ymax),
                               axes = FALSE, axisnames = FALSE, col = col_bars)
arrows(sechura_lobos_plot,100*(sechura_lobos[,2]+sechura_lobos[,3]),
       sechura_lobos_plot,100*(sechura_lobos[,2]-sechura_lobos[,3]),
       angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
# mtext(ylab, side=2, line=2.5 , cex=1.2)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars, cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Transport', 'Sechura - Lobos')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 0)

##############
lobos_sechura_plot <-  barplot(lobos_sechura[,1], xlab="", ylab= "" ,ylim = c(0,ymax),
                               axes = FALSE, axisnames = FALSE, col = col_bars)
arrows(lobos_sechura_plot,100*(lobos_sechura[,2]+lobos_sechura[,3]),
       lobos_sechura_plot,100*(lobos_sechura[,2]-lobos_sechura[,3]),
       angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Transport', 'Lobos - Sechura')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 0)

###############

ymax = 3
sechura_plot <-  barplot(sechura[,1], xlab="", ylab= "" ,ylim = c(0,ymax),
                               axes = FALSE, axisnames = FALSE, col = col_bars)
arrows(sechura_plot,100*(sechura[,2]+sechura[,3]),
       sechura_plot,100*(sechura[,2]-sechura[,3]),
       angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Retention', 'Sechura Bay')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 0)

########

lobos_plot <-  barplot(lobos[,1], xlab="", ylab= "" ,ylim = c(0,ymax),
                         axes = FALSE, axisnames = FALSE, col = col_bars)
arrows(lobos_plot,100*(lobos[,2]+lobos[,3]),
       lobos_plot,100*(lobos[,2]-lobos[,3]),
       angle=90,code=3,length=0.05)
axis(1, at=sechura_lobos_plot, labels = labels, tick = FALSE)
axis(2, lwd = 3, cex.axis = 1.4)
# legend('topright', legend = c('Daily Winds', 'Monthly Winds'), bty = 'n', fill = col_bars,cex = 0.5)
# bquote  aprender esta funcion
Lines <- list('Larval Retention', 'Lobos de Tierra Island')
mtext(do.call(expression, Lines), side=3, line=0:1 , cex=0.9, adj = 0)

# dev.off()
