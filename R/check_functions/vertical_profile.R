#===============================================================================
# Name   : Vertical Profile
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Make vertical profiles from ROMS files in a specific point (lon-lat)
# URL    : 
#===============================================================================
  
  # Directory where open input-files and where save pictures
  dirpath  = "G:/ROMS_SIMULATIONS/NoTides_ClimWind/"  #input location
  dirpath2 = "C:/JORGE_FLORES/ICHTHYOP_OUTPUT"        #output location
  

library(ncdf)






meses= c("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
           "Agosto","Septiembre","Octubre","Noviembre","Diciembre")
  
files = c("newperush_avg.Y2000.M2.extjflores.nc", "newperush_avg.Y2000.M3.extjflores.nc",
          "newperush_avg.Y2000.M4.extjflores.nc", "newperush_avg.Y2000.M5.extjflores.nc",
          "newperush_avg.Y2000.M6.extjflores.nc", "newperush_avg.Y2000.M7.extjflores.nc",
          "newperush_avg.Y2000.M8.extjflores.nc", "newperush_avg.Y2000.M9.extjflores.nc",
          "newperush_avg.Y2000.M10.extjflores.nc", "newperush_avg.Y2000.M11.extjflores.nc",
          "newperush_avg.Y2000.M12.extjflores.nc", "newperush_avg.Y2001.M1.extjflores.nc")
  
# nc2    = open.ncdf("newperush_grd.extjflores.nc")
# mask   = get.var.ncdf(nc2, "mask_rho") ; mask[mask !=1] = NA
# mask = mask[272:311, 102:221]

var = "v"
ind1 = 12       
ind2 = 80       
xlim=c(-0.3,0.3)

png(paste0("bahia_", var, ".png"), width = 1050, height = 1250, res=120)

mat <- matrix(c(1:12), 3, 4, byrow = TRUE)
nf <- layout(mat, widths = c(4.3, 4.3, 4.3, 4.3), height = c(6,6,6), TRUE)

for(i in 1:12){
    
    nc = open.ncdf(paste0(dir, files[i]))
    
    lat = get.var.ncdf(nc, "lat_rho")
    lat = lat[272:311, 102:221]
    
    lon = get.var.ncdf(nc, "lon_rho")
    lon = lon[272:311, 102:221]
  
    var = var
    if (var == "u"){
      var_name = "Velocidad zonal (m/s)"
    }else{
      var_name = "Velocidad meridional (m/s)"
    }
    
    vari = get.var.ncdf(nc, var)
    vari = apply(vari, c(1,2,3), mean); vari = vari[272:311, 102:221,]
  
    ind1 = ind1       #a[1] +7
    ind2 = ind2       #a[2] -6

    sc_r = att.get.ncdf(nc, 0 , "sc_r")$value
    h    = get.var.ncdf(nc, "h"); h = h[272:311, 102:221]
    
    h_point = h[ind1, ind2] * sc_r
    point = vari[ind1, ind2,]  
  
    par(mar=c(3,3,1,1))
    plot(point, h_point, type ="l", xlab=var_name, ylab="",
         xlim = xlim)
    abline(v=0)
    mtext(paste0("LAT= ", round(lat[ind1,ind2], 2),
                 " LON= ", round(lon[ind1,ind2]-360, 2)), line=-2.5,
          cex=0.65)
    mtext(meses[i], 3 , line=-1.5)
#     mtext("")
  
  }
dev.off()
  
