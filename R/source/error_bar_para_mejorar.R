# ic bar histogram : (5 cols, 100 filas)
x = 1:20;y=21:40
# Funci?n limite de confianza J Tam 
ic.bar <- function(x, y, upper, lower=upper, length=0.1){
  if(length(x) != length(y) | length(y) !=length(lower) | length(lower) != length(upper))
  stop("vectors must be same length")
  
  arrows(x,y+upper, x, y-lower, angle=90, code=3, length=length)
}

# Funci?n limite de confianza J Flores
error_bar <- function(x, a = 0.05){
  # x = vector o matrix with data to evaluate, if x is a matrix, each column will be evaluate
  # a = confianza interval to evaluate
  
  if(!is.null(dim(x))){
    stat <- NULL
    for(i in 1:dim(x)[2]){
      n  <- length(x[,i])
      m  <- mean(x[,i], na.rm = T)
      s  <- sd(x[,i], na.rm = T)
      tt <- -qt(a/2,n-1)
      ee <- sd(x[,i])/sqrt(n)  # standard error. It is different from the standard deviation
      e  <- tt*ee          # error range
      d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
      li <- m-e            # lower limit
      ls <- m+e            # upper limit
      vec <- c(m, li, ls)
      stat <- rbind(stat, vec)
    }
  }else{
    n  <- length(x)
    m  <- mean(x, na.rm = T)
    s  <- sd(x)
    tt <- -qt(a/2,n-1)
    ee <- sd(x)/sqrt(n)  # standard error. It is different from the standard deviation
    e  <- tt*ee          # error range
    d  <- e/m            # relative error, says that the confidence interval is a percentage of the value
    li <- m-e            # lower limit
    ls <- m+e            # upper limit
    stat <- c(m, li, ls)
  }
  return(stat)
}


# Plot para probar ambas funciones
par(mfrow=c(1,2))

# Data
set.seed(500)
n=500
a=0.05
y <- rnorm(n, mean=1)
y <- matrix(y,100,5)
tp <- qt(a/2,n-1)
y.means <- apply(y,2,mean)
y.sd <- apply(y,2,sd)
ic=tp*y.sd/sqrt(100)
ymin=min(y.means)-max(y.sd)
ymax=max(y.means)+max(y.sd)


par(mfrow = c(1,2))
# Plot JTam
barx <- barplot(y.means, names.arg=1:5,ylim=c(ymin,ymax),
                col="yellow", axis.lty=1, xlab="X", ylab="Y", main = 'Tam code')
ic.bar(barx, y.means, ic)

# Plot JFlores
dat <- apply(y, c(2), error_bar)
barx2 <- barplot(dat[1,],names.arg=1:5,ylim=c(ymin,ymax),
                 col="yellow", axis.lty=1, xlab="X", ylab="Y",main = 'Flores code')
arrows(x0 = barx2, y0 = dat[2,],x1 = barx2, y1 = dat[3,], angle=90, code=3, length=0.1)



# error bar timeseries

t=c(1:5)
m=y.means
ic=ic

ymin=min(m)-max(ic)
ymax=max(m)+max(ic)
plot(t,m,col="red",type="l", cex=0.7,pch=16,
     xlab="t",ylab="m",main="ic", ylim=c(ymin,ymax))
arrows(t,y0=m-ic,t,y1=m+ic,code=3,angle=90,length=0.1,col="blue")
#
#
#
#
#
# # otro error bar timeseries
#
# add.error.bars <- function(x,y,lc,w,col=1)
# { X0 = x; Y0 = (y-lc); X1 =x; Y1 = (y+lc);
# arrows(X0, Y0, X1, Y1, code=3,angle=90,length=w,col=col)}
#
# t = 1:10
# xmin=min(t)
# xmax=max(t)
# m = rnorm(10,10,5)
# lc = rnorm(10,2,0.5)
#
# ymin=min(m)-max(lc)
# ymax=max(m)+max(lc)
# plot(t,m, col="red",xlim=c(xmin,xmax), ylim=c(ymin,ymax), type="l")
# add.error.bars(t,m,lc,0.1,col=4)

