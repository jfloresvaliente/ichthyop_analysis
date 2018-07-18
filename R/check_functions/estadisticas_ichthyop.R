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



# ## PARA CADA REGIMEN DE VIENTOS POR SEPARADO
# winds = c('clim')
# simu = "sechura_lobos"
# simu = paste0(winds,'_',simu)
# data = read.csv(paste0(dirpath,simu,".csv"), sep= ",")
# 
# # lm para los factores originales
# mod <- lm(Recruitprop ~ factor(Year) + factor(Day) + factor(Depth) + factor(Age)
#           + factor(Year):factor(Day) + factor(Year):factor(Depth) + factor(Year):factor(Age) 
#           + factor(Day):factor(Depth)+ factor(Day):factor(Age)
#           + factor(Depth):factor(Age) , data = data)
# 
# # summary(mod)
# aov = anova(mod)
# print(aov)
# print(100 * aov[2] / sum(aov[2]))
# aov_sum = (100 * aov[2] / sum(aov[2]))
# 
# write.csv(as.matrix(aov), file = paste0(simu, '_ANOVA.csv'), na = "")
# write.csv(as.matrix(aov_sum), file = paste0(simu,'_ANOVA_SUM.csv'), na = "")





#################
# fact = c('Year','Day','Depth','Age')
# 
# orig.fact = NULL
# for(i in 1:length(fact)){
#   fac = paste0('factor(', fact[i], ')+')
#   orig.fact = paste0(orig.fact,fac)
# }
# 
# a = 2
# simb = '+'
# comb.fact = NULL
# for(i in 1:(length(fact)-1)){
#     fac1 = paste0('factor(', fact[i],'):')
#   
#   com.fin = NULL
#   for(j in a:length(fact)){
#     fac2 = paste0('factor(', fact[j],')',simb)
#     com = paste0(fac1,fac2)
#     com.fin = paste0(com.fin,com)
#   }
#   a = a+1
#   if(a == length(fact)){simb = ''}
#   comb.fact = paste0(comb.fact,com.fin)
# }
# 
# final.sentence = paste0(orig.fact,comb.fact)
##################



# lm incluyendo la fecha de liberacion
# 
# mod <- lm(Recruitprop ~ factor(Year)+factor(Day)+factor(Depth)+factor(Age)+factor(t_x)
#           + factor(Year):factor(Day)+factor(Year):factor(Depth)+factor(Year):factor(Age)+factor(Year):factor(t_x)
#           + factor(Day):factor(Depth)+factor(Day):factor(Age)+factor(Day):factor(t_x)
#           + factor(Depth):factor(Age)+factor(Depth):factor(t_x)
#           + factor(Age):factor(t_x), data = data)
# summary(mod)
# aov = anova(mod)
# print(aov)
# print(100 * aov[2] / sum(aov[2]))

# lm incluyendo el regimen de vientos

# mod <- lm(Recruitprop ~ factor(Year)+factor(Day)+factor(Depth)+factor(Age)+factor(t_x)+factor(id)
#           + factor(Year):factor(Day)+factor(Year):factor(Depth)+factor(Year):factor(Age)+factor(Year):factor(t_x)+factor(Year):factor(id)
#           + factor(Day):factor(Depth)+factor(Day):factor(Age)+factor(Day):factor(t_x)+factor(Day):factor(id)
#           + factor(Depth):factor(Age)+factor(Depth):factor(t_x)+factor(Depth):factor(id)
#           + factor(Age):factor(t_x)+ factor(Age):factor(id), data = data)
# summary(mod)
# aov = anova(mod)
# print(aov)
# print(100 * aov[2] / sum(aov[2]))


# mod <- lm(as.numeric(Recruitprop) ~ factor(Year) + factor(Day), data=data4)
# 
# aov = anova(mod)
# print(aov)
# print(100 * aov[2] / sum(aov[2]))
# 
# ####################################
# 
# seg_600 = as.numeric(as.vector(data3$Recruitprop))
# seg_1800 = as.numeric(as.vector(data4$Recruitprop))
# 
# simu = rep(2,36)
# data2 = cbind(data2, simu)
# 
# DATA = rbind(data1, data2, data3, data4)
# DATA2= rbind(data1, data3, data4)
# wilcox.test(seg_600, seg_1800)
# t.test(seg_600, seg_1800)
# 
