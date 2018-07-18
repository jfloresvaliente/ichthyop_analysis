#===============================================================================
# Name   : Vertical Profile
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Make vertical profiles from ROMS files in a specific point (lon-lat),
#          you can choose the "variable to plot"
# URL    : 
#===============================================================================

setwd("C:/Users/richards/Desktop/pics")
# Directory where open input-files and where save pictures
  dirpath  = "F:/ROMS_SIMULATIONS/NoTides_ClimWind/"  #input location
  dirpath2 = "F:/"        #output location

  meses.names= c("JAN","FEB","MAR","ABR","MAY","JUN","JUL",
                  "AUG","SEP","OCT","NOV","DIC")

  year  = 8       # you can change the year simulation
  days  = seq(from=18, by=30, length.out = 12) # initialization day of ROMS
  
  library(ncdf)
  filenames <- list.files(path = dirpath, full.names = TRUE,pattern = "years")

# An inner function that computes year and day from time in seconds
  compute_yearday <- function(time){
    nbdays = 1+time/86400
    year   = 1+as.integer(nbdays/360)
    day    = as.integer(nbdays-360*(year-1))
    return(c(year,day))
  }

  files_to_plot = NULL
    
for (i in 1:length(filenames)){
    nc <- open.ncdf(filenames[i])

    # Gets the value of initialization of ROMS
    t0 <- get.var.ncdf(nc,'time',1,1)
  
    # Computes year and day initialization of ROMS
    yearday <- compute_yearday(t0)
    close(nc)
    
    if(yearday[1] == year){
      file_name = filenames[i]
#     years  = as.numeric(as.character(yearday[1])) 
#     month  = as.numeric(as.character(yearday[2]))
      years  = year 
#       month  = which(yearday[2] == days)
      month  = yearday[2]
      files  = c(file_name, years, month)
    }else{
      file_name = NULL
      years  = NULL
      month  = NULL
      files  = NULL
    }
      files_to_plot = rbind(files_to_plot, files, deparse.level = 0)
}

files_to_plot = c("4years_M2.nc","4years_M3.nc","4years_M4.nc","4years_M5.nc",
                  "4years_M6.nc","4years_M7.nc","4years_M8.nc","4years_M9.nc",
                  "4years_M10.nc","4years_M11.nc","4years_M12.nc","4years_M1.nc")

###########################################
###########################################
var = "v"
ind2 = 80    # 80, 47
ind1 = 12    # 12, 16

# xlim=c(-0.15,0.15)
xlim=c(-0.3,0.3)
if (var == "u"){
  var_name = "Zonal Velocity (m/s)"
}else{
  var_name = "Meridional Velocity (m/s)"
}
# png(paste0(dirpath2,"bahia_", var, ".png"), width = 1050, height = 1250, res=120)
# mat <- matrix(c(1:12), 3, 4, byrow = TRUE)
# nf <- layout(mat, widths = c(4.3, 4.3, 4.3, 4.3), height = c(6,6,6), TRUE)
# layout.show(nf)


points = NULL
# for(i in days){
  for(i in 1:12){
#   print(i)
  # nc_file = subset(files_to_plot, files_to_plot[,3] == i)
  # nc = open.ncdf(nc_file[,1])
  nc = open.ncdf(files_to_plot[i])
  lat = get.var.ncdf(nc, "lat_rho")
  lat = lat[272:311, 102:221]
  
  lon = get.var.ncdf(nc, "lon_rho")
  lon = lon[272:311, 102:221]
  
  var = var
  
  vari = get.var.ncdf(nc, var)
#   vari = apply(vari, c(1,2,3), mean); vari = vari[272:311, 102:221,]
  vari = vari[272:311, 102:221,,]
  vari = apply(vari, c(1,2,3), mean); 
  
  ind1 = ind1       #a[1] +7
  ind2 = ind2       #a[2] -6
  
  sc_r = att.get.ncdf(nc, 0 , "sc_r")$value
  h    = get.var.ncdf(nc, "h"); h = h[272:311, 102:221]
  
  h_point = h[ind1, ind2] * sc_r
  point = vari[ind1, ind2,]  
  
  points = cbind(points,point)
  close(nc)
}


png(paste0("P2_", year,"_", var, ".png"), width = 1050, height = 1250, res=120)
op <- par(mfrow = c(3,4),
          oma = c(5,4,0,0) + 0.1,
          mar = c(0,0,1,1) + 0.1)
# ticks = seq(from=-0.15,to=0.15,0.15)
ticks = seq(from=-0.30,to=0.30,0.15)
at    = ticks
labels= ticks
for(i in 1:12){
  if(i == 1 | i == 5 ){
    plot(points[,i],h_point, type="l",axes =FALSE,xlim=xlim)
    abline(v = 0)
    mtext(paste0("LAT= ", round(lat[ind1,ind2], 2),
                 " LON= ", round(lon[ind1,ind2]-360, 2)), line=-2.5,
          cex=0.65)
    axis(1, at=at, labels = FALSE)
    axis(2)
    #     box(which = "plot", bty = "l")
    box()
#     legend("bottomleft", legend = i,  bty = "n")
    mtext(meses.names[i], 3 , line=-1.5)
  }else if(i == 9){
    plot(points[,i],h_point, type="l", axes =FALSE,xlim=xlim)
    abline(v = 0)
    mtext(paste0("LAT= ", round(lat[ind1,ind2], 2),
                 " LON= ", round(lon[ind1,ind2]-360, 2)), line=-2.5,
          cex=0.65)
    axis(1, at=at, labels = labels)
    axis(2)
    #     box(which = "plot", bty = "l")
    box()
#     legend("bottomleft", legend = i,  bty = "n")
    mtext(meses.names[i], 3 , line=-1.5)
  }else if(i == 10 | i == 11 | i ==12){
    plot(points[,i],h_point, type="l", axes =FALSE,xlim=xlim)
    abline(v = 0)
    mtext(paste0("LAT= ", round(lat[ind1,ind2], 2),
                 " LON= ", round(lon[ind1,ind2]-360, 2)), line=-2.5,
          cex=0.65)
    axis(1, at=at, labels =labels)
    #     axis(2)
    #     box(which = "plot", bty = "l")
    box()
#     legend("bottomleft", legend = i,  bty = "n")
    mtext(meses.names[i], 3 , line=-1.5)
  }else{
    plot(points[,i],h_point, type="l", axes =FALSE,xlim=xlim)
    abline(v = 0)
    mtext(paste0("LAT= ", round(lat[ind1,ind2], 2),
                 " LON= ", round(lon[ind1,ind2]-360, 2)), line=-2.5,
          cex=0.65)
    axis(1, at=at, labels = FALSE)
    #     axis(2)
    #     box(which = "plot", bty = "l")
    box()
#     legend("bottomleft", legend = i,  bty = "n")
    mtext(meses.names[i], 3 , line=-1.5)
  }
  
}

title(xlab = var_name,
      ylab = "Depth (m)",
      outer = TRUE, line = 3, cex.lab=1.5) #, col.lab="red", font.lab=3)

dev.off()
