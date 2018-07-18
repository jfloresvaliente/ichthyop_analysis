#===============================================================================
# Name   : get_stress_winds
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
get_stress_winds <- function(points_file){
  library(ncdf4)
  points <- read.table(points_file)
  var_names <- c('sustr','svstr')
  
  ## MONTLY WINDS
  CLIM <- list()
  for(ii in var_names){
    nc_file <- 'input/newperush_frc_ascatclim_2008_2012.nc'
    nc <- nc_open(nc_file)
    vari <- ncvar_get(nc, ii); dim(vari)
    
    serie_day <- NULL
    for(jj in 1:dim(vari)[3]){
      D2 <- vari[,,jj]; dim(D2)
      
      D2_vec <- NULL
      for(kk in 1:dim(points)[1]){
        poin <- D2[points[kk,2],points[kk,1]]
        D2_vec <- c(D2_vec,poin)
      }
      D2_vec <- mean(D2_vec)
      serie_day <- c(serie_day,D2_vec)
      print(paste(nc_file,ii,'month',jj,format(Sys.time(),'%H:%M:%S' )))
    }
    CLIM[[length(CLIM)+1]] <- serie_day
  }
  
  ## DAILY WINDS
  DAILY <- list()
  for(ii in var_names){
    
    serie_year <- NULL
    for(year in 2008:2012){
      nc_file <- paste0('input/newperush_frc_ascatdaily_',year,'.nc')
      nc <- nc_open(nc_file)
      vari <- ncvar_get(nc, ii); dim(vari)
      
      serie_day <- NULL
      for(jj in 1:dim(vari)[3]){
        D2 <- vari[,,jj]; dim(D2)
        
        D2_vec <- NULL
        for(kk in 1:dim(points)[1]){
          poin <- D2[points[kk,2],points[kk,1]]
          D2_vec <- c(D2_vec,poin)
        }
        D2_vec <- mean(D2_vec)
        serie_day <- c(serie_day,D2_vec)
      }
      serie_year <- c(serie_year,serie_day)
      print(paste(nc_file,ii,format(Sys.time(),'%H:%M:%S' )))
    }
    DAILY[[length(DAILY)+1]] <- serie_year
  }
  return(list(CLIM,DAILY))
}
#===============================================================================
# END OF PROGRAM
#===============================================================================
