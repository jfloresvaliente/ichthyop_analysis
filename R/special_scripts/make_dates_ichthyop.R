
winds <- 'clim'
dat <- read.table(paste0(winds,'.csv'), sep = ';', header = T)
dat <- subset(dat, dat$Y %in% c(2009:2011) & dat$t_x %in% c(1,5,10))

ichthyop_date <- NULL
for(i in 1:dim(dat)[1]){
  # print(i)
  year  <-  dat$sim_year[i]
  
  month <-  dat$sim_month[i]
  if(month < 10){month <- paste0('0', month)}
  
  day   <-  dat$sim_day[i]
  if(day < 10){day <- paste0('0', day)}
  
  fecha <- paste0('<value>year '
                  ,year
                  ,' month '
                  ,month
                  ,' day '
                  ,day
                  ,' at 13:00</value>')
  
  ichthyop_date <- rbind(ichthyop_date, fecha)
}

write.table(x = ichthyop_date, file = paste0(winds, 'dates.csv'), row.names = F)

