#===============================================================================
# Name   : ------
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : -----
# URL    : 
#===============================================================================
source('source/error_bar.R')
directory <- 'F:/ichthyop_output_analysis/RUN2/csv_files/max_distance/'
out_path  <- 'F:/ichthyop_output_analysis/RUN2/figures/maxDistance/'

winds <- 'daily'
simu <- 'lobos'
ylim <- c(0,100)

dat <- read.table(paste0(directory, winds,'_', simu, '_distance.csv'), header = T, sep = '')

stat_all <- NULL
for(i in 1:12){
  month <- subset(dat, dat$Month == i)
  vec <- month$MaxDistFromBeginning
  stat <- error_bar(vec)
  stat_all <- rbind(stat_all, stat)
}
colnames(stat_all) <- c('mean', 'lower', 'upper')
rownames(stat_all) <- 1:12
mean(stat_all[,1])
dayplot <- barplot(stat_all[,1], names.arg = 1:12)

# dayplot   <- barplot(dataday[,1], xlab="", ylab= "" ,ylim = c(0,ymax), axes = FALSE, axisnames = FALSE)
arrows(dayplot,stat_all[,2],dayplot,stat_all[,3],angle=90,code=3,length=0.05)

mod <- lm(MaxDistFromBeginning~ factor(Month)+factor(ReleaseDepth)+factor(Age), data = dat)
aov = anova(mod)
print(aov)

filename <- paste0(out_path, 'maxDistance', winds,simu, '.png')
png(paste0(filename,".png") ,width = 1050 , height = 350 , res=120)
par(mfrow = c(1,3), mar=c(3.5 , 3. , 1.5 , 0.3))

graph1 <- boxplot(MaxDistFromBeginning~Month, data = dat, ylim = ylim, ylab= '')
mtext(text = 'maximum distance (km)', side = 2, line = 2, cex = .7)
mtext(text = 'Release Month', side = 1, line = 2, cex = .7)

graph2 <- boxplot(MaxDistFromBeginning~ReleaseDepth, data = dat,ylim = ylim, ylab= '')
mtext(text = 'maximum distance (km)', side = 2, line = 2, cex = .7)
mtext(text = 'Release Depth', side = 1, line = 2, cex = .7)

graph3 <- boxplot(MaxDistFromBeginning~Age, data = dat, ylim = ylim, ylab= '')
mtext(text = 'maximum distance (km)', side = 2, line = 2, cex = .7)
mtext(text = 'Age minimun to settlement', side = 1, line = 2, cex = .7)

dev.off()