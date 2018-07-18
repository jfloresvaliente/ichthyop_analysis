dirpath <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
source_path <- 'D:/ICHTHYOP/scripts/'

# setwd(dirpath)

firstdrifter <- 1
lastdrifter  <- 55
# simu <- 'clim_sechura_lobos'

csv_file <- paste0(dirpath, 'traj_clim_sechura_lobos3.csv')
df <- read.table(csv_file,header = T)

ylim <- -65 # 65 para lobos ; 120 para sechura - lobos
color.limits <- c(ylim,0)
source(paste0(source_path,'plot_traj_data_gif_jorge.R'))

pngfile <- paste0(out_path,'clim_sechura_lobos_M3')
plot_traj_data_gif_jorge(dataset = df,pngfile = pngfile)
