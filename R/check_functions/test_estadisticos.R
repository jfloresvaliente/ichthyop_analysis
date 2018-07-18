
### Tests estadisticos para normalidad de los datos

## p-value < 0.05  ==> se rechaza la hipótesis H0

## shapiro.test  ==> H0 = LOS DATOS TIENEN DISTRIBUCIÓN NORMAL

shapiro.test(runif(100))
shapiro.test(rnorm(100))

### Test de normalidad de los datos de transporte de larvas y retención de larvas

shapiro.test(sec_lob)
shapiro.test(lob_sec)

shapiro.test(sec)
shapiro.test(lob)


### Test para diferencia de grupos no parametricos

wilcox.test(sec_lob, lob_sec)
wilcox.test(sec, lob)
