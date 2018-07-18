#===============================================================================
# Name   : 
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/trajectoy/'
out_path <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited_depth/'

simu <- 'daily_sechura_lobos'

depth_month <- NULL
for(i in 1:12){
  df <- read.table(paste0(dirpath,'traj_', simu, i, '.csv'),header = T)
  print(paste0(dirpath,'traj_', simu, i, '.csv'))
  df <- subset(df, df$Day == 28)
  depth_month <- rbind(depth_month, df)
}

write.table(x = depth_month, file = paste0(out_path, simu, '_depth_of_recruited.csv'),
            sep = ',', row.names = F)
