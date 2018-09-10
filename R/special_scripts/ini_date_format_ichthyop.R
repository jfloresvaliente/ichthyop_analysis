dirpath <- '/home/marissela/Documents/ichthyop-3.2/cfg/'
dat <- read.table(paste0(dirpath,'timer_Ascat_daily.csv'), header = T, sep = ';')

dat <- subset(dat, dat$Y %in% c(2009:2011) & dat$t_x %in% c(1,5,10))

date_sim <- NULL
for(i in 1:dim(dat)[1]){
  dat2 <- dat[i,]
  
  year <- dat2$sim_year
  
  month <- dat2$sim_month
  if(month < 10) month <- paste0(0,month)
  
  day <- dat2$sim_day
  if(day < 10) day <- paste0(0,day)
  
  date_sim <- c(date_sim, paste('<value>year', year, 'month', month, 'day', day, 'at 13:00</value>'))
}

write.table(x = date_sim, file = paste0(dirpath,'dat_sim_daily.csv'), row.names = F, col.names = F)
