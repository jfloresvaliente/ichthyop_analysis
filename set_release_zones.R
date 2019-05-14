library(ncdf4)
library(fields)
nc <- nc_open('D:/ROMS_SIMULATIONS/peru02km/roms_avg_Y2008M1.newperushtopoP.nc')
lon <- ncvar_get(nc, 'lon_rho')
lat <- ncvar_get(nc, 'lat_rho')
h <- ncvar_get(nc, 'h')
mask <- ncvar_get(nc, 'mask_rho')
mask[mask == 0] <- NA

h[h > 2000] <- NA

xax <- seq(-83,-74,1)
yax <- seq(-16,-4,2)
png(filename = 'C:/Users/ASUS/Desktop/map.png', width = 850, height = 850, res = 120)
image.plot(lon, lat, h, xlim = c(-83,-74), axes = F)
axis(1, at = xax, labels = xax, line = -3)
axis(2, at = yax, labels = yax, line = -3)
abline(h = yax, lwd = 2, v = xax)
dev.off()
# abline(v=-75.1)


#Hola


