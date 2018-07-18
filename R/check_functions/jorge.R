library(ggmap)
source('D:/ICHTHYOP/scripts/plot_traj_ggmap.R')

dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
dat <- read.table(paste0(dirpath, 'traj_daily_sechura_lobos3.csv'),
                  header = T)
particles <- c(345,381,420,483,502,505,514,525,
               527,528,556,572,598,628, 708,728)
sub_particles <- subset(dat, dat$drifter %in% particles)
set.seed(200)
new_depths <- rnorm(n = 11, mean = -45, sd = 10)

a = which(sub_particles$depth <= -60, arr.ind = T)
sub_particles$depth[a] <- new_depths

pngfile <- paste0(dirpath, 'particles.png')

plot_traj_ggmap(df = sub_particles,color.limits = c(-81,0),release = 0,
                month = 3, pngfile = NULL)



