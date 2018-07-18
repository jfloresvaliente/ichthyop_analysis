
dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'

winds <- c('clim','daily')

# x11()
vec <- NULL
vec_abs <- NULL
vec_sd <- NULL
par(mfrow=c(1,2))
for(i in winds){
  dat <- read.table(paste0(dirpath,'passed_particles_',i,'_sechura_lobos_635.csv'),header = T)
  # dat <- subset(dat,dat$Month %in% c(1:5,10:12))
  prop <- (dat[,2]*100)/dat[,1]
  dat <- cbind(dat,prop)
  byfactor <- tapply(dat$prop, list(dat$Month),mean, na.rm=T)
  sdfactor <- tapply(dat$prop, list(dat$Month),sd, na.rm=T)
  vec <- cbind(vec,byfactor)
  abs_num <- sum(dat$NumberPassed)
  vec_abs <- c(vec_abs,abs_num)
  vec_sd <- cbind(vec_sd, sdfactor)
  barplot(byfactor, names.arg= c(1:12),ylim = c(0,60))
}

### Particulas que pasaron la latitud minima (plot)
png(paste0(out_path,'passed_particles.png'), width = 850, height = 850, res = 120)
par(mar = c(3.5,3.5,1.5,1.5))
plot(1:12, type = 'n', ylim = c(0,60), xlab = '', ylab = '',
     xaxt = 'n')
mtext('Months', side = 1, line = 2)
mtext('% Particles that passed lat limit (-6.35°)',side = 2, line = 2)
axis(1, at = 1:12, labels = 1:12)
lines(vec[,1], col = 'red', lwd = 4)
lines(vec[,2], col = 'blue', lwd = 4)

legend('topright', legend = c('Montly winds','Daily winds'),
       col = c('red','blue'), lwd = c(4,4), lty = c(1,1), bty = 'n')
dev.off()

### Particulas que pasaron la latitud minima (barplot)
png(paste0(out_path,'passed_particles_barplot.png'), width = 850, height = 850, res = 120)
par(mar = c(3.5,3.5,1.5,1.5))
draf <- barplot(t(vec), beside = T, ylim = c(0,60), xlab = '', ylab = '',
                xaxt = 'n', col = c('red','blue'))
mtext('Months', side = 1, line = 2)
mtext('% Particles that passed lat limit (-6.35°)',side = 2, line = 2)
axis(1, at = (draf[1,]+draf[2,])/2, labels = 1:12)
legend('topright', legend = c('Montly winds','Daily winds'),
       fill = c('red','blue'), bty = 'n')
dev.off()

