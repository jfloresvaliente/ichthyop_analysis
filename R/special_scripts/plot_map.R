#===============================================================================
# Name   : plot_map
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Make map from 'maps' package
# URL    : 
#===============================================================================
library(maps)
library(mapdata)

# Establish the working directory were the map will be save
out_path <- 'C:/Users/ASUS/Desktop/paper_figures/'
# Countries to be plotted
countries <- c('peru','bolivia','brazil','ecuador','colombia')
# Named of the plot
name <- 'map_peru'
# Limits of the plot
xmin <- -84
xmax <- -68
ymin <- -20
ymax <- 0.
interval <- 2 # interval of degrees to be plotted in the axis
cex.axis <- 0.75

# win.metafile(filename = paste0(out_path,name,'.emf'), width = 8, height = 8, pointsize = 12)
tiff(filename = paste0(out_path,name,'.tiff'), width = 680, height = 680, res = 120)
map('worldHires' , countries , resolution=0 , xlim=c(xmin,xmax) , ylim=c(ymin,ymax),
    col='gray90' , fill=TRUE)

axis(1, at=seq(xmin,xmax, interval), labels=seq(xmin,xmax, interval), lwd= 1 ,lwd.ticks = 1, font=1)
axis(2, at=seq(ymin,ymax, interval), labels=seq(ymin,ymax, interval), lwd= 1 ,lwd.ticks = 1, font=1)
axis(3, at=seq(xmin,xmax, interval), lwd.ticks=0, lwd=1, labels=FALSE) 
axis(4, at=seq(ymin,ymax, interval), lwd.ticks=0, lwd=1, labels=FALSE) 

mtext('Longitude', 1, line = 2.5 , cex= 1.35)
mtext('Latitude' , 2, line = 2.5 , cex= 1.35)

## If you want to draw a box with specific points
arrows(x0=-82, y0=-7, x1 = -82, y1 = -5, code=0)
arrows(x0=-82, y0=-5, x1 = -80, y1 = -5, code=0)
arrows(x0=-80, y0=-5, x1 = -80, y1 = -7, code=0)
arrows(x0=-80, y0=-7, x1 = -82, y1 = -7, code=0)

# To draw name into the map
mtext('PERU', 1, line= -12, cex= 1.5)
dev.off()
#===============================================================================
# END OF PROGRAM
#===============================================================================