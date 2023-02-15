library(fpp2)
library(urca)

tsdata<- ts(unemployment_rate_data[2:11], start = 1948, frequency = 12)
trainset<-window(tsdata, end=2007)
testset<-window(tsdata, start=2007)
autoplot(tsdata[,1])
summary(tsdata)

autoplot(tsdata[,1], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Total Unemploymment Rate From Jan 1948 to Nov 2021")
autoplot(tsdata[,2], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Men")
autoplot(tsdata[,3], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Women")
autoplot(tsdata[,4], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 16 to 17")
autoplot(tsdata[,5], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 18 to 19")
autoplot(tsdata[,6], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 20 to 24")
autoplot(tsdata[,7], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 25 to 34")
autoplot(tsdata[,8], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 35 to 44")
autoplot(tsdata[,9], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 45 to 54")
autoplot(tsdata[,10], xlab = "Time", ylab = "Rates in %")+
  ggtitle("Unemploymment Rate Age 55+")

nsdiffs(tsdata[,1])
summary(ur.df(tsdata[,1], type = 'drift', lags = 12)) #there is no unit root
ggtsdisplay(trainset[,1])#ARIMA(0,0,0)
#we will pick an ARIMA(2,0,0)(2,1,0)
u1 <- Arima(trainset[,1], order = c(10,0,0), seasonal = c(2,0,0), include.drift = T)
summary(u1)#113.64
u2 <- Arima(trainset[,1], order = c(10,0,0), seasonal = c(3,0,0), include.drift = T)
summary(u2)#68.05
u3 <- Arima(trainset[,1], order = c(10,0,0), seasonal = c(4,0,0), include.drift = T)
summary(u3)#44.34
u4 <- Arima(trainset[,1], order = c(10,0,0), seasonal = c(5,0,0), include.drift = T)
summary(u4)#41.97
u5 <- Arima(trainset[,1], order = c(11,0,0), seasonal = c(5,0,1), include.drift = T)
summary(u5)#42.41
u6 <- Arima(trainset[,1], order = c(11,0,0), seasonal = c(6,0,0), include.drift = T)
summary(u6)#38.56
u7 <- Arima(trainset[,1], order = c(12,0,0), seasonal = c(6,0,0), include.drift = T)
summary(u7)#36.25
u8 <- Arima(trainset[,1], order = c(12,0,0), seasonal = c(6,0,1), include.drift = T)
summary(u8)#30.55, best model

checkresiduals(a8) #there is one lag that is out of the confidence interval so we
#can consider the residuals white noise. although there is still evidence of serial 
#correlation, pvalue = 0.00377. residuals are normally distributed
length(testset[,1])
testset
fa<- forecast(a8, h=8)
fa
autoplot(fa)+
  autolayer(trainset[,1])

#using the entire data set
ggtsdisplay(tsdata[,1])
u1 <- Arima(tsdata[,1], order = c(10,0,0), seasonal = c(2,0,0), include.drift = T)
summary(u1)#1141.35
u2 <- Arima(tsdata[,1], order = c(10,0,0), seasonal = c(3,0,0), include.drift = T)
summary(u2)#1110.07
a3 <- Arima(tsdata[,1], order = c(10,0,0), seasonal = c(4,0,0), include.drift = T)
summary(a3)#1095.09
a4 <- Arima(tsdata[,1], order = c(10,0,0), seasonal = c(5,0,0), include.drift = T)
summary(a4)#1094.78
a5 <- Arima(tsdata[,1], order = c(9,0,0), seasonal = c(4,0,1), include.drift = T)
summary(a5)#1092.83
a6 <- Arima(tsdata[,1], order = c(8,0,0), seasonal = c(4,0,1), include.drift = T)
summary(a6)#1092.31
a7 <- Arima(tsdata[,1], order = c(9,0,0), seasonal = c(5,0,0), include.drift = T)
summary(a7)#1094.13
a8 <- Arima(tsdata[,1], order = c(8,0,1), seasonal = c(4,0,0), include.drift = T)
summary(a8)#1081.69 best
a9 <- Arima(tsdata[,1], order = c(8,0,0), seasonal = c(4,0,0), include.drift = T)
summary(a9)#1081.69

#the model we will use is and ARIMA (8,0,1)(4,0,0)
checkresiduals(a8) #white noise residuals with a pvalue of 0.71

fcast<- forecast(a8, h=6)
fcast
autoplot(betterplot,xlab = "Years", ylab = "Unemployment Rate")+
  autolayer(fcast) +
  ggtitle("Forecasted using ARIMA")
