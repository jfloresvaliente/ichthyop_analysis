####
#Curso GLM-GAM 3/04/2017
####

setwd("F:/GLM_GAM/datos/")
library(gam)
library(DAAG)
library(car)

dat = read.csv("Kiwi.csv")
attach(dat)

kiwi.lm1 = lm(ohms~juice)
summary(kiwi.lm1)
plot(juice,ohms)
abline(kiwi.lm1,col="red")

kiwi.lm2 = lm(ohms~factor(juice)) # estima los promedios de cada valor de 'juice'
summary(kiwi.lm2)
plot(juice,ohms)
abline(kiwi.lm1,col="red")
#lines(juice,kiwi.lm2$fitted.values)
lines(juice,kiwi.lm2$fitted, col='green')

anova(kiwi.lm1,kiwi.lm2)


plot(ohms,kiwi.lm1$fitted)
abline(0,1)

plot(ohms,kiwi.lm1$residuals) 
plot(juice,kiwi.lm1$residuals)

j2 = juice^2

kiwi.lm3 = lm(ohms~juice+j2)
summary(kiwi.lm3)
plot(juice,ohms)
# curve(kiwi.lm3$coef[1]+kiwi.lm3$coef[2])

kiwi.glm1 = glm(ohms~juice,family = poisson)
summary(kiwi.glm1)
plot(juice,ohms)
points(juice,kiwi.glm1$fitted.values,col='blue')

### GAM's ###

dat = read.csv("Stress.csv")
attach(dat)
plot(Month,Respondents)
stress.lm1 = lm(Respondents~Month)
summary(stress.lm1)
abline(stress.lm1)
stress.glm1 = glm(Respondents~Month)
summary(stress.glm1)
points(Month,stress.glm1$fitted.,col='red')

plot(stress.glm1)

####

dat = read.csv("Prostate.csv")
attach(dat)
dat
pros.mod1 = lm(Nodes~.,data = dat)
plot(dat)
summary(pros.mod1)

plot(Nodes,pros.mod1$fitted.values)
step(pros.mod1,direction = 'backward') # sugiere un nuevo modelo

pros.mod.2 = lm(formula = Nodes ~ Acid + Xray + Size, data = dat)
summary(pros.mod.2)

anova(pros.mod1,pros.mod.2)

pros.mod.3 = lm(formula = Nodes ~ Xray + Size, data = dat)
pros.mod.4 = lm(formula = Nodes ~ log(Acid) + Xray + Size, data = dat)

Anova() # érteneciente a paquete car





