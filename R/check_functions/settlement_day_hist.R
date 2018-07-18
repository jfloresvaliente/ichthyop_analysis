
setwd("G:/ICHTHYOP/final/processed/output_2nd")
# source("G:/ICHTHYOP/scripts/recruitment_age.R")
library(plotrix)
simu = "clim_lobos"
# ylim = 50000

settle = NULL
for(i in c(1,5,10)){
  
  dataset = read.table(paste0("tracking_larval_", simu, "_t", i, ".csv"), header = T)
  settle  = rbind(settle, dataset)
}

settle$settlement = settle$settlement-0.5

age15 = subset(settle, settle$age == 15 ); age15 = age15[seq(1,length(age15$drifter), 55),]
age20 = subset(settle, settle$age == 20 ); age20 = age20[seq(1,length(age20$drifter), 55),]
age25 = subset(settle, settle$age == 25 ); age25 = age25[seq(1,length(age25$drifter), 55),]

age15 = subset.data.frame(age15, age15$settlement != 15 & age15$settlement != 15.5)
age20 = subset.data.frame(age20, age20$settlement != 20 & age20$settlement != 20.5)
age25 = subset.data.frame(age25, age25$settlement != 25 & age25$settlement != 25.5)

rm(settle)
png(paste0(simu,"_settlement_day.png") , width = 850 , height = 550 , res=120)

mat <- matrix(c(1,2,3), 1, 3, byrow = TRUE)
nf <- layout(mat, widths = c(9,9,9), height = c(12), TRUE)

# ylim = max(a$counts, b$counts, c$counts)
ylim = c(0,17000)
xmin = 15
xmax = 27
xlim = c(xmin,xmax)
breaks = seq(xmin, xmax, 0.5)
gap = c(200,800)
# ytics=c(0,50,100,150,1600,1700, 1800)
ytics=c(0,50,100,150,900,1000)
yaxlab = ytics
inde = 1775

# par(mfrow=c(3,1))
# a = hist(age15$settlement, plot=FALSE, breaks= breaks)
# b = hist(age20$settlement, plot=FALSE, breaks= breaks)
# c = hist(age25$settlement, plot=FALSE, breaks= breaks)

# a = a$counts
# b = b$counts
# c = c$counts

# a = log(a)
# b = log(b) ; b[-Inf] = NA
# c = log(c) ; c[-Inf] = NA


# barplot(a, space = 0, ylim = c(0,7))
# barplot(b, space = 0, ylim = c(0,7))
# barplot(c, space = 0, ylim = c(0,7))


# # b[1] = inde ; c[1] = inde
# 
# gap.barplot(a, gap = gap, col=c(rep("grey", length(a))), yaxlab = yaxlab,
#             ytics=ytics, xaxlab=breaks[1:length(breaks)-1],
#             xlab = "Day of recruitment", ylab="# of particles", ylim = ylim)
# 
# gap.barplot(b, gap = gap, col=c(rep("grey", length(a))), yaxlab = yaxlab,
#             ytics=ytics, xaxlab=breaks[1:length(breaks)-1],
#             xlab = "Day of recruitment", ylab="# of particles", ylim = ylim)
# 
# gap.barplot(c, gap = gap, col=c(rep("grey", length(a))), yaxlab = yaxlab,
#             ytics=ytics, xaxlab=breaks[1:length(breaks)-1],
#             xlab = "Day of recruitment", ylab="# of particles", ylim = ylim)

# barplot(a, space = 0, ylim=ylim, main="")

a = hist(age15$settlement, ylim=ylim, main="", xlim = xlim,
         ylab="# particles",axes=F, breaks= seq(xmin, xmax, 0.5))
axis(1, at= xmin:xmax, labels = xmin:xmax); axis(2)

b = hist(age20$settlement, ylim=ylim, main="", xlim = xlim,
         ylab="# particles",axes=F, breaks= seq(xmin, xmax, 0.5))
axis(1, at= xmin:xmax, labels = xmin:xmax); axis(2)

c = hist(age25$settlement, ylim=ylim, main="", xlim = xlim,
         ylab="# particles",axes=F, breaks= seq(xmin, xmax, 0.5))
axis(1, at= xmin:xmax, labels = xmin:xmax); axis(2)

dev.off()

library(beepr)
beep(8, "EL TRABAJO FUE REALIZADO")