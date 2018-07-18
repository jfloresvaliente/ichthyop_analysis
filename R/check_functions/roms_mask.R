#===============================================================================
# Name   : roms_mask
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Makes a mask from a ROMS file
# URL    : 
#===============================================================================

library(ncdf4)

dirpath = "G:/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/"
file    = "roms6b_avg.Y1958.M1.rl1b.nc"

i     = 6   # number of pixels of mask for coast
down  = 140 # row number to remove from down limit
up    = 60  # equal to down

nc = nc_open(paste0(dirpath,file))

## Step 1: Get the coast line ## Cada celda es 18.48 km (esto es en mi simulacion)

mask = ncvar_get(nc, "mask_rho")
# dim(mask)

mask  = ncvar_get(nc, "mask_rho")
a     = mask[-c(1:i), ] # quito 6 filas de la parte superior
b     = matrix (0 , i , ncol(a)) # crea una matriz de ceros para suplir las faltantes
c     = rbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)
mask  = mask - c # resto para tener la mascara deseada
mask[mask!=1] = NA # transformo todos los calores no desados en NA

image(mask)
mask2 = mask ## Create a new mask to avoid confutions

## Step 2: Set the limits (down and up) for the mask

# Set down limit
a     = mask2[ ,-c(1:down)]
b     = matrix (NA , nrow(a) , down) # crea una matriz de ceros para suplir las faltantes
mask2 = cbind(b,a) # suma a (con filas faltantes) y b (con las filas llenas de ceros)

# Set up limit
lim_up   = ncol(mask2)
lim_down = ncol(mask2)-up +1


a     = mask2[ ,-c(lim_down:lim_up)]
b     = matrix (NA , nrow(a) , up) # crea una matriz de ceros para suplir las faltantes
mask2 = cbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)

dim(mask2)
image(mask2)


### Ya tu calculas cuanto quitas de arriba y de abajo, porque el numero de pixeles de tu
### simulacion es diferente, puedes empezar quitando 20 arriba y abajo



## Cada celda es 18.48 km

# mask = ncvar_get(nc, "mask_rho") 
# dim(mask)
# 
# i = 6
# 
# for(i in 1:8){
#   # cell = i # numero de celdas a ser reemplazadas
#   mask = ncvar_get(nc, "mask_rho")
#   a = mask[-c(1:i), ] # quito 6 filas de la parte superior
#   b = matrix (0 , i , ncol(a)) # crea una matriz de ceros para suplir las faltantes
#   c = rbind(a,b) # suma a (con filas faltantes) y b (con las filas llenas de ceros)
#   mask = mask - c # resto para tener la mascara deseada
#   mask[mask!=1] = NA # transformo todos los calores no desados en NA
#   
#   image(mask)
#   # write.table(mask, paste0("C:/Users/ASUS/Desktop/","mask","_", i, ".csv"),
#   #             row.names = FALSE, col.names = FALSE)
# }
# 
