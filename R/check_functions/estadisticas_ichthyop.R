#===============================================================================
# Name   : estadisticas_ichthyop
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : make a lm and anova for ouputs of ichthyop simulations 
# URL    : 
#===============================================================================
# Test estadistico para simulacion con vientos mensuales y diarios

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
# out_path <- 'C:/Users/ASUS/Desktop/ichthyop_output_analysis/'
source_path <- 'D:/ICHTHYOP/scripts/'

winds <- 'clim'
simu <- 'lobos'
simulacion <- paste0(winds,'_',simu)

# dataset = NULL
# for(i in 1:length(winds)){
#   simu = paste0(winds[i],'_',simu)
#   dat = read.csv(paste0(dirpath,simu,".csv"), sep= ",")
#   winds_index = rep(winds[i], times = length(dat[,1]))
#   dat = cbind(dat,winds_index)
#   dataset = rbind(dataset,dat)
# }

dataset <- read.table(paste0(dirpath,simulacion, '.csv'),header = T)

# # lm para los factores originales
# mod <- lm(Recruitprop ~ factor(winds_index)+ factor(Year) + factor(Day) + factor(Depth) + factor(Age)
#           + factor(winds_index):factor(Year)+factor(winds_index):factor(Day)+factor(winds_index):factor(Depth)+factor(winds_index):factor(Age)
#           + factor(Year):factor(Day) + factor(Year):factor(Depth) + factor(Year):factor(Age) 
#           + factor(Day):factor(Depth)+ factor(Day):factor(Age)
#           + factor(Depth):factor(Age) , data = dataset)


# lm para los factores originales
mod <- lm(Recruitprop ~ factor(Year) + factor(Day) + factor(Depth) + factor(Age)
          + factor(Year):factor(Day) + factor(Year):factor(Depth) + factor(Year):factor(Age) 
          + factor(Day):factor(Depth)+ factor(Day):factor(Age)
          + factor(Depth):factor(Age) , data = dataset)

# summary(mod)
aov = anova(mod)
print(aov)
print(100 * aov[2] / sum(aov[2]))
aov_sum <- (100 * aov[2] / sum(aov[2])); colnames(aov_sum) <- '%Exp'

aov <- cbind(aov,aov_sum)
rownames(aov) <- c('year','Day','depth','age',
                       'year x Day','year x depth','year x age',
                       'Day x depth','Day x age',
                       'depth x age','residuals')
# print(aov)
# write.csv(as.matrix(aov),     file = paste0(out_path,simulacion, '_ANOVA.csv'), na = "")
# write.csv(as.matrix(aov_sum), file = paste0(out_path,simulacion, '_ANOVA_SUM.csv'), na = "")


mod <- aov(Recruitprop ~ factor(Year) + factor(Day) + factor(Depth) + factor(Age)
          + factor(Year):factor(Day) + factor(Year):factor(Depth) + factor(Year):factor(Age) 
          + factor(Day):factor(Depth)+ factor(Day):factor(Age)
          + factor(Depth):factor(Age) , data = dataset)
print(100 * mod[2] / sum(mod[2]))
