### ANALISIS DE LOS DATOS ###
## Dominio espacial de los datos lat [-4.06,-16.01]

library(fields)
dir = "F:/GLM_GAM/ROMS_2D/"

dat = read.csv(paste0(dir,'variables.csv'),sep='')
dat = dat[,-c(5)]
attach(dat)
### Analisis exploratorio
png(paste0(dir,'plot_every_var.png'), width = 2000, height = 850, res = 120)
plot(dat)
dev.off()

# aplico la funcion log para normalizar los valores de clorofila-a
# inicio con un lm para cada variable explicativa respecto a la clorofila-a

# Variable respuesta NCHL (clorofila-a); variable explicativa (temp) temperatura

png(paste0(dir,'lm_log_NCHL_temp.png'), width = 850, height = 850, res = 120)
lm.NCHL1 = lm(log(NCHL)~temp)
plot(temp,log(NCHL))
abline(lm.NCHL1,col='red',lwd=2)

model.name = toString(lm.NCHL1$call)
intercept = paste('Intercept',toString(round(lm.NCHL1$coefficients[1],4)))
var.name1 = paste('temp', toString(round(lm.NCHL1$coefficients[2],4)))

legend('topright', bty = "n", cex = 0.9, legend = c(model.name,paste(intercept,var.name1)))
dev.off()

# Variable respuesta NCHL (clorofila-a); variable explicativa (Si) silicato

png(paste0(dir,'lm_log_NCHL_Si.png'), width = 850, height = 850, res = 120)
lm.NCHL2 = lm(log(NCHL)~Si)
plot(Si,log(NCHL))
abline(lm.NCHL2,col='red',lwd=2)

model.name = toString(lm.NCHL2$call)
intercept = paste('Intercept',toString(round(lm.NCHL2$coefficients[1],4)))
var.name1 = paste('Si', toString(round(lm.NCHL2$coefficients[2],4)))

legend('topright', bty = "n", cex = 0.9, legend = c(model.name,paste(intercept,var.name1)))
dev.off()

# Variable respuesta NCHL (clorofila-a); variable explicativa (NO3) nitrato

png(paste0(dir,'lm_log_NCHL_NO3.png'), width = 850, height = 850, res = 120)
lm.NCHL3 = lm(log(NCHL)~NO3)
plot(NO3,log(NCHL))
abline(lm.NCHL3,col='red',lwd=2)

model.name = toString(lm.NCHL3$call)
intercept = paste('Intercept',toString(round(lm.NCHL3$coefficients[1],4)))
var.name1 = paste('NO3', toString(round(lm.NCHL3$coefficients[2],4)))

legend('topright', bty = "n", cex = 0.9, legend = c(model.name,paste(intercept,var.name1)))
dev.off()

# Variable respuesta NCHL (clorofila-a); variable explicativa (PO4) fosfato

png(paste0(dir,'lm_log_NCHL_PO4.png'), width = 850, height = 850, res = 120)
lm.NCHL4 = lm(log(NCHL)~PO4)
plot(PO4,log(NCHL))
abline(lm.NCHL4,col='red',lwd=2)

model.name = toString(lm.NCHL4$call)
intercept = paste('Intercept',toString(round(lm.NCHL4$coefficients[1],4)))
var.name1 = paste('NO3', toString(round(lm.NCHL4$coefficients[2],4)))

legend('topright', bty = "n", cex = 0.9, legend = c(model.name,paste(intercept,var.name1)))
dev.off()




########################################################################
# NCHL.lm1=lm(NCHL~temp);summary(NCHL.lm1)
# abline(NCHL.lm1,col="red")
# plot(NCHL,NCHL.lm1$fitted.values)
# abline(0,1, col='red')
# plot(temp,NCHL.lm1$residuals)
# abline(h=0, col='red')
# ########################################################################
# j2=temp*temp
# NCHL.lm3=lm(NCHL~temp+j2)
# summary(NCHL.lm3)
# anova(NCHL.lm1,NCHL.lm3)
# plot(temp, NCHL)
# curve(NCHL.lm3$coef[1]+NCHL.lm3$coef[2]*x+NCHL.lm3$coef[3]*x^2,col="red",add=TRUE)
# plot(NCHL,NCHL.lm3$fitted.values)
# abline(0,1,col='red')
# # anova(kiwi.lm3,kiwi.lm2)
# plot(temp,NCHL.lm3$residuals)
# abline(h=0, col='red')



# plot(temp,NCHL)
# NCHL.lo1 = loess(NCHL~temp, model=TRUE, enp.target=4, degree = 1, family = "gaussian", method = "loess") 
# summary(NCHL.lo1);NCHL.lo1$kd
# 
# # anova(kiwi.lo7,kiwi.lo8)
# lines(temp,NCHL.lo1$fitted,col="red")
# plot(NCHL,NCHL.lo1$fitted)
# abline(0,1, col='red')
# plot(temp,NCHL.lo1$residuals)
# abline(h=0, col = 'red',lwd=2)

######################################



# lm.model = lm(NCHL~temp+NO3+Si+PO4); summary(lm.model)
# 
# coef = lm.model$coefficients




lm.model = lm(NCHL~temp); lm.model$coefficients
model.name1 = toString(lm.model$call)
intercept1 = paste('Intercept',toString(round(lm.model$coefficients[1],4)))
var.name1 = paste('temp', toString(round(lm.model$coefficients[2],4)))
legend1 = paste(model.name1,intercept1,var.name1)

glm.model2 = glm(NCHL~temp, family = gaussian); glm.model2$coefficients
model.name2 = toString(glm.model2$call)
intercept2 = paste('Intercept',toString(round(glm.model2$coefficients[1],4)))
var.name2 = paste('temp', toString(round(glm.model2$coefficients[2],4)))
legend2 = paste(model.name2,intercept2,var.name2)

# glm.model3 = glm(NCHL~temp); glm.model3$coefficients
# model.name3 = toString(glm.model3$call)
# intercept3 = paste('Intercept',toString(round(glm.model3$coefficients[1],4)))
# var.name3 = paste('temp', toString(round(glm.model3$coefficients[2],4)))
# legend3 = paste(model.name3,intercept3,var.name3)
# png(paste0(dir,'lm_glm_temp.png'), width = 850, height = 850, res = 120)
plot(temp,NCHL) #ylim=c(0.3,1))
abline(lm.model,col='red',lwd=2)
# lines(glm.mode$fitted.values,col="green",lwd=2)
lines(glm.model2$fitted.values,col="blue",lwd=2)
legend('topright', bty = "n", cex = 0.9, legend = c(legend1,legend2),
       lty = c(1,1),col=c('red', 'blue'))
# dev.off()


lm.multiple = lm(NCHL~temp+Si+NO3+PO4)
plot(NCHL, lm.multiple$fitted.values)
coef = lm.multiple$coefficients


## El multiple R square es el que importa
# el R ajustado es para comparar con otros modelos


# (Intercept)        temp          Si         NO3         PO4 
# 1.85545640 -0.04740123  0.03269469  0.01285061 -0.68068596 
# model.name = toString(lm.NCHL2$call)
# intercept = paste('Intercept',toString(round(lm.NCHL2$coefficients[1],4)))
# var.name1 = paste('Si', toString(round(lm.NCHL2$coefficients[2],4)))
# 
# legend('topright', bty = "n", cex = 0.9, legend = c(model.name,paste(intercept,var.name1)))
# dev.off()
