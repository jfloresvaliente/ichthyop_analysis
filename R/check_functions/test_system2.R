test_system2 <- function(){ 

library(XML)

# Ichthyop cfg file
cfgfile = '/home/clett/IRD/Ichthyop/stable-3/cfg/2016_03_18_clett_config_roms3d_WMOP_Audrey_Planier.xml'
# Runs Ichthyop with cfg file
#system2('/opt/jdk1.8.0_77/jre/bin/java', args=c('-jar', '/home/clett/IRD/Ichthyop/stable-3/dist/ichthyop_stable_v3.jar', cfgfile))

# Lists Ichthyop output files
outputpath = xmlValue(xmlRoot(xmlParse(cfgfile))[[5]][[4]][[2]][[3]])
filenames <- list.files(path = outputpath, pattern = glob2rx('*ichthyop-run*.nc'), full.names = TRUE)

# Process Ichthyop output files
source('plot_traj_Ichthyop_v3_ggmap.R')
source('plot_dens_Ichthyop_v3_ggmap.R')
fd = 1
ld = 10000
ft = 1
lt = 111
lonmin = 2.0
lonmax = 10.0
latmin = 41.0
latmax = 44.5
z = 5
pt = 111
for (i in seq(1, length(filenames))){
    print(filenames[i])
    plot_traj_Ichthyop_v3_ggmap(
	ncfile = filenames[i],
	firstdrifter = fd,
	lastdrifter = ld,
	firsttime = ft,
	lasttime = lt,
	longitudemin = lonmin,
	longitudemax = lonmax,
	latitudemin = latmin,
	latitudemax = latmax,
	zoom = z,
	pngfile = gsub('.nc', '_traj.png', filenames[i]))
    plot_dens_Ichthyop_v3_ggmap(
	ncfile = filenames[i],
	firstdrifter = fd,
	lastdrifter = ld,
	firsttime = ft,
	lasttime = lt,
	plottime = pt,
	longitudemin = lonmin,
	longitudemax = lonmax,
	latitudemin = latmin,
	latitudemax = latmax,
	zoom = z,
	pngfile = gsub('.nc', paste('_dens_', pt-1, 'd.png', sep = ''),filenames[i]))
    }
}