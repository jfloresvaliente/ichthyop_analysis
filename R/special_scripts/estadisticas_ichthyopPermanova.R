#==============================================================================
# Name   : estadisticas_ichthyopPermanova
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : make a lm and anova for ouputs of ichthyop simulations 
# URL    : 
#===============================================================================
# Test estadistico para simulacion con vientos mensuales y diarios
library(vegan)

dirpath <- 'F:/ichthyop_output_analysis/RUN2/csv_files/recruited/'
dir.create(paste0(dirpath, 'permanova'), showWarnings = F)

winds <- 'clim'
simu <- 'sechura_lobos'
simulacion <- paste0(winds,'_',simu)

dataset <- read.table(paste0(dirpath,simulacion, '.csv'),header = T)

year <- levels(factor(dataset$Year))
month <- levels(factor(dataset$Day))
depth <- levels(factor(dataset$Depth))
age <- levels(factor(dataset$Age))

newDat <- NULL
newVar <- NULL
for (i in year) {
  for (j in month) {
    for (k in depth) {
      for (m in age) {
          arow <- subset(dataset, dataset$Year == i & dataset$Day == j & dataset$Depth == k & dataset$Age == m)
          acol <- arow$Recruitprop
          vari <- c(i,j,k,m)
          
          newDat <- rbind(newDat, acol)
          newVar <- rbind(newVar, vari)
      }
    }
  }
}

newDat <- as.data.frame(newDat)
newVar <- as.data.frame(newVar)

colnames(newDat) <- c('rep1', 'rep2', 'rep3')
colnames(newVar) <- c('year','month','depth','age')
permanovaMod <- adonis2(newDat ~ year + month + depth + age +
                                year*month + year*depth + year*age +
                                month*depth + month*age +
                                depth*age,
                       data = newVar, permutations = 99, method = 'euclidean')

print(permanovaMod)
dim(permanovaMod)

permanovaMod_sum <- (100 * permanovaMod[2] / sum(permanovaMod[2])); colnames(permanovaMod_sum) <- '%Exp'
permanovaMod <- as.matrix(cbind(permanovaMod,permanovaMod_sum))

write.csv(permanovaMod, file = paste0(dirpath,'/permanova/',simulacion, '_Permanova.csv'), na = '')
rm(list = ls())
