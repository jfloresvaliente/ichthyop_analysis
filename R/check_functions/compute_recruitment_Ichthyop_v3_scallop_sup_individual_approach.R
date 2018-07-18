#===============================================================================
# Name   : compute_recruitment_Ichthyop_v3_scallop_sup_individual_approach
# Author : Lett; modified by Jorge Flores
# Date   : 
# Version:
# Aim    : Compute recruitment from ICHTHYOP simulations
# URL    : 
#===============================================================================
compute_recruitment_Ichthyop_v3_scallop_sup_individual_approach <- function(){
  
  library(ncdf)
  library(XML)
  library(stringr)
  
  # The directory that contains the series of netcdf input files
#   dirpath = "C:/JORGE_FLORES/ICHTHYOP_OUTPUT/output/scallop_lobos/"
  dirpath = "F:/ICHTHYOP/ichthyop_scallop/output/lobos_sechura/"
  
  # If you want to read the 'xml' files from a directory different to original directory
  old.path = "/home/jtam/Documentos/JORGE_FLORES/ichthyop-3.2_scallop/cfg/"
  new.path = "F:/ICHTHYOP/ichthyop_scallop/cfg/"

# In case one wishes to consider only a subset of all drifters
  # Index of the first and last drifters
  firstdrifter  <- 1
  lastdrifter   <- 20000
  
  # The time record at which to compute recruitment
  computeattime <- 55
  # The number of release zones
  nbreleasezones  <- 1
  # The index of the recruitment zone for which recruitment is computed
  recruitmentzone <- 1
  
  adult = 50 * 10^6
  egg   = 8   * 10^6
  
  # The maximum value of the transport success plot (in %)
  ymax <- 0.2
  
  # An inner function that computes recruitment for one file
  compute_recruitment_file <- function(filename){
    
    # An inner function that computes year and day from time in seconds
    compute_yearday <- function(time){
      nbdays  = 1 + time/86400
      year    = 1 + as.integer(nbdays/360)
      day     = as.integer(nbdays-360*(year-1))
      #if (day < 10) day <- paste('0',day,sep='')
      #if (as.numeric(day) < 100) day <- paste('0',day,sep='')
      return(c(year,day))
    }
    
    nc <- open.ncdf(filename)
    
    # Gets the value of time of release
    t0 <- get.var.ncdf(nc,'time',1,1)
    
    # Computes year and day of release
    yearday <- compute_yearday(t0)
    
    #Reads zonefile, gets the values of min and max depth of release and concatenates them
    filezone <- att.get.ncdf(nc,0,'release.zone.zone_file')$value
    filezone <- gsub(pattern = old.path, replacement = new.path, filezone)
    
    mindepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[["zone"]][["thickness"]][["upper_depth"]])
    maxdepth <- xmlValue(xmlRoot(xmlTreeParse(filezone))[["zone"]][["thickness"]][["lower_depth"]])
    depth <- paste(mindepth,maxdepth,sep='-')
    
    # Gets the mane of the "release zone"       SECHURA = 1 , LOBOS = 0
    release_zone <- xmlValue(xmlRoot(xmlTreeParse(filezone))[["zone"]][["key"]])
    if (grepl("sechura" , release_zone) == TRUE){
      release_zone = 1
    }else{
      release_zone = 0
    }
    
    # Gets the mane of the "recruitment zone"
    filezone2 <- att.get.ncdf(nc,0,'action.recruitment.zone.zone_file')$value
    filezone2 <- gsub(pattern = old.path,replacement = new.path, filezone2)
    
    recruitment_zone <- xmlValue(xmlRoot(xmlTreeParse(filezone2))[["zone"]][["key"]])
    if (grepl("lobos" , recruitment_zone) == TRUE){
      recruitment_zone = 0
    }else{
      recruitment_zone = 1
    }
    
    #Gets the value for "Cold Lethal Temperature" for larvae
    temp_min <- att.get.ncdf(nc,0,'action.lethal_temp.cold_lethal_temperature_larva')$value
    
    #Gets the value for "Age minimal recruitment"
    age <- att.get.ncdf(nc , 0 , 'action.recruitment.zone.limit_age')$value      
    
    #Gets the value for "coastline_behavior"
    coast_behavior <- att.get.ncdf(nc , 0 , 'app.transport.coastline_behavior')$value
    
    nbdrifter <- lastdrifter-firstdrifter
    
    # Gets the value of recruited for the recruitment zone considered for all drifters at time of computation
    recruited <- get.var.ncdf(nc,'recruited_zone',c(recruitmentzone,firstdrifter,computeattime),c(1,nbdrifter,1))
    
    # Gets the value of release zone for all drifters
    releasezone <- get.var.ncdf(nc,'zone',c(1,firstdrifter,1),c(1,nbdrifter,1))
    releasezone <- releasezone + 1
    
    # Calculates the number of recruits from every release zone
    recruitnb <- hist(recruited*releasezone,seq(0,nbreleasezones+1)-0.5,plot=FALSE)$counts[2:(nbreleasezones+1)]
    
    ########################
    ########################
#     nc = open.ncdf("sechura_ichthyop-run201608051326_s164.nc")
    super_ind = get.var.ncdf(nc, 'recruited_zone')
    
#     hist(super_ind[,1])
#     which (super_ind == 1 , arr.ind = T)
    days = seq(18,348,30)
    a = which(days == yearday[2])
    set.seed(12)
    IG = runif(12, min=0,max=1)
    IGS = IG[a]
    
    N0 = (adult*egg*IGS)/lastdrifter
    
    
    # N0 = 5 * 10^6  # numero inicial de individuos
    # M = 0.1339     # tasa de mortalidad (day -1) Rumnil
    # M = 0.412 # Winkler-stevez
    M = 0.266 # Autor que aun no encuentro el paper
    ind = NULL
    for(i in 1:lastdrifter){
      
      if (any(super_ind[i,] == 1)){
        a = min(which(super_ind[i,] == 1))
        t = round(a/2 ,1)  # tiempo en dias
        Nt = N0 * exp(-M * t)
        ind = rbind(ind, Nt)
      }
    }
    
    super_individuo = sum(ind)
    N0tot = N0 * 20000
    
#     rm(list=c(""))
    ########################
    ########################    
    
    
    # Calculates the number of released from every release zone
    releasenb <- hist(releasezone,seq(0,nbreleasezones+1)-0.5,plot=FALSE)$counts[2:(nbreleasezones+1)]
    
    #Gets the name of the '.nc' file
    #     name_file = nc$file
    nchar_max = nchar(nc$file)
    
    if(nchar(nc$file == nchar_max)){
      name_file = substr(nc$file , start = nchar(nc$file)-5 , stop = nchar(nc$file)-3)  
    }else if (nc$file == nchar_max-1){
      name_file = substr(nc$file , start = nchar(nc$file)-4 , stop = nchar(nc$file)-3)
    }else if (nc$file == nchar_max-2){
      name_file = substr(nc$file , start = nchar(nc$file)-3 , stop = nchar(nc$file)-3)
    }
    
    
    close.ncdf(nc)
    # returns a collage of columns, i.e., a table, that looks like the following
    # releasenb1 recruitnb1 1 year day depth
    # releasenb2 recruitnb2 2 year day depth
    # releasenb3 recruitnb3 3 year day depth
    # ...
    return(cbind(releasenb,recruitnb,seq(1,nbreleasezones),rep(yearday[1],nbreleasezones),
                 rep(yearday[2],nbreleasezones),rep(depth,nbreleasezones), rep(age,nbreleasezones),
                 rep(release_zone,nbreleasezones),rep(recruitment_zone,nbreleasezones),
                 rep(coast_behavior,nbreleasezones), rep(temp_min,nbreleasezones), rep(name_file, nbreleasezones),
                 rep(super_individuo, nbreleasezones), rep(N0tot, nbreleasezones)))
  }
  
  # An inner function that computes statistics of recruitment for a given factor
  compute_recruitment_stats <- function(released,recruited,factor){
    mean <- tapply(recruited,factor,sum)/tapply(released,factor,sum)
    var <- tapply(recruited^2,factor,sum)/tapply(released^2,factor,sum)-mean^2
    sem <- sqrt(var/table(factor))
    return(cbind(mean,sem))
  }
  
  # Gets filenames of all files in the dirpath directory 
#   filenames <- list.files(path = dirpath, full.names = TRUE)
  filenames <- list.files(path = dirpath, full.names = TRUE, pattern = ".nc")
  # Computes recruitment for the first file 
  dataset <- compute_recruitment_file(filenames[1])
  
  # Computes recruitment for all subsequent files 
  if (length(filenames) >1){
    for (i in seq(2, length(filenames))){
      # Shows name of opened file on the console
      print(filenames[i])
      flush.console()
      # Computes recruitment data for file i
      data <- compute_recruitment_file(filenames[i])
      # Adds recruitment data computed for file i to those computed from all previous files
      dataset <- rbind(dataset,data)
    }
  }
  
  # Computes stats (mean, std error of the mean) of recruitment for every release area, year, day, and depth
  
  dataarea_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,3]))
  dataarea_mean=dataarea_stats[,1]
  dataarea_sem=dataarea_stats[,2]
  
  datayear_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,4]))
  datayear_mean=datayear_stats[,1]
  datayear_sem=datayear_stats[,2]
  
  dataday_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),as.numeric(dataset[,5]))
  dataday_mean=dataday_stats[,1]
  dataday_sem=dataday_stats[,2]
  
  datadepth_stats=compute_recruitment_stats(as.numeric(dataset[,1]),as.numeric(dataset[,2]),dataset[,6])
  datadepth_mean=datadepth_stats[,1]
  datadepth_sem=datadepth_stats[,2]
  
  # Makes the corresponding plots
  x11() ; par(mfrow=c(2,2))
  
  areaplot <- barplot(100*dataarea_mean,xlab='Release area',ylab='Transport success (%)',ylim = c(0,ymax))
  arrows(areaplot,100*(dataarea_mean+dataarea_sem),areaplot,100*(dataarea_mean-dataarea_sem),angle=90,code=3,length=0.05)
  
  dayplot <- barplot(100*dataday_mean,xlab='Release day',ylab='Transport success (%)',ylim = c(0,ymax))
  arrows(dayplot,100*(dataday_mean+dataday_sem),dayplot,100*(dataday_mean-dataday_sem),angle=90,code=3,length=0.05)
  
  yearplot <- barplot(100*datayear_mean,xlab='Release year',ylab='Transport success (%)',ylim = c(0,ymax))
  arrows(yearplot,100*(datayear_mean+datayear_sem),yearplot,100*(datayear_mean-datayear_sem),angle=90,code=3,length=0.05)
  
  depthplot <- barplot(100*datadepth_mean,xlab='Release depth (m)',ylab='Transport success (%)',ylim = c(0,ymax))
  arrows(depthplot,100*(datadepth_mean+datadepth_sem),depthplot,100*(datadepth_mean-datadepth_sem),angle=90,code=3,length=0.05)
  
  recruitprop <- 100*as.numeric(dataset[,2])/as.numeric(dataset[,1])
  dataset <- as.data.frame(cbind(dataset , recruitprop))
  
  colnames(dataset) <- c('NumberReleased','NumberRecruited','ReleaseArea','Year','Day',
                         'Depth','Age', 'Release_zone','Recruitment_zone','Coast_Behavior',
                         'Temp_min','name_file', 'super_individuo', 'N0tot','Recruitprop')


  return (dataset)
  #mod <- lm(recruitprop ~ factor(ReleaseArea) + factor(Day) + factor(Year) + factor(Depth)
  #			+ factor(ReleaseArea):factor(Day) + factor(ReleaseArea):factor(Year) + factor(ReleaseArea):factor(Depth)
  #			+ factor(Day):factor(Year) + factor(Day):factor(Depth) + factor(Year):factor(Depth), data = dataset)
  #aov <- anova(mod)
  #print(aov)
  #print(100 * aov[2] / sum(aov[2]))
  #interaction.plot(dataset$Day,dataset$ReleaseArea,recruitprop,fixed=TRUE,xlab='Release day',ylab='Transport success (%)',lty=1,col=seq(1,length(areaplot)))
  #interaction.plot(dataset$Depth,dataset$ReleaseArea,recruitprop,fixed=TRUE,xlab='Release depth (m)',ylab='Transport success (%)',lty=1,col=seq(1,length(areaplot)))
  #interaction.plot(dataset$Day,dataset$Year,recruitprop,fixed=TRUE,xlab='Release day',ylab='Transport success (%)',lty=1,col=seq(1,length(yearplot)))
}

#===============================================================================
# END OF PROGRAM
#===============================================================================