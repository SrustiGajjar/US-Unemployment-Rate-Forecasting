library(fpp2)
library(urca)
library(readxl)


unemployment_rate_data <- read_excel("C:\\Users\\srusti\\Desktop\\MSBA\\Sem2\\ECON\\project\\unemployment_rate_data.xlsx")

tsdata<- ts(unemployment_rate_data[2:11], start = 1948, frequency = 12)
autoplot(tsdata,facets = T)
trainset<-window(tsdata, end=2007)
testset<-window(tsdata, start=2007)

ggtsdisplay(trainset[,1])
#we will pick an ARIMA(2,0,0)(2,1,0)

ar1<- auto.arima(trainset[,1])
summary(ar1)
#auto.arima has picked an ARIMA(3,0,1)(2,1,2), the AIC is 8.33
#ARIMA(4,0,0)(2,1,2)[12] & AICc=12

#let's check other models
ar2<-Arima(trainset[,1], order = c(2,0,0), seasonal = c(2,1,0), include.drift = T)
summary(ar2)
ar3<-Arima(trainset[,1], order = c(2,0,0), seasonal = c(2,1,1), include.drift = T)
summary(ar3)#better than the previous one AICc=51.21
ar4<-Arima(trainset[,1], order = c(2,0,0), seasonal = c(3,1,1), include.drift = T)
summary(ar4)#worse
ar5<-Arima(trainset[,1], order = c(2,0,1), seasonal = c(2,1,1), include.drift = T)
summary(ar5)#better 9.92
ar6<-Arima(trainset[,1], order = c(2,0,2), seasonal = c(2,1,1), include.drift = T)
summary(ar6)#better 7.15
ar7<-Arima(trainset[,1], order = c(2,0,2), seasonal = c(3,1,1), include.drift = T)
summary(ar7)#worse
ar8<-Arima(trainset[,1], order = c(2,0,2), seasonal = c(2,1,2), include.drift = T)
summary(ar8)#worse
ar9<-Arima(trainset[,1], order = c(3,0,1), seasonal = c(2,1,1), include.drift = T)
summary(ar9)#better 6.66
ar10<-Arima(trainset[,1], order = c(3,0,1), seasonal = c(2,1,2), include.drift = T)
summary(ar10)#worse
ar11<-Arima(trainset[,1], order = c(3,0,1), seasonal = c(3,1,1), include.drift = T)
summary(ar11)#worse
ar12<-Arima(trainset[,1], order = c(3,0,0), seasonal = c(2,1,0), include.drift = T)
summary(ar12)#worse
ar13<-Arima(trainset[,1], order = c(3,0,2), seasonal = c(2,1,0), include.drift = T)
summary(ar13)#worse
#the best model is ar9

#let's check the residuals
checkresiduals(ar9)
#the residuals are white noise, there is no evidence of serial correlation
#and they are normally distibuted
#we can concluse that the model is the best

#let's forecast
far<- forecast(ar9, h=length(testset))
far
autoplot(far)+
  autolayer(trainset[,1])

#let's check the accurary
accuracy(far, testset[,1])

#let's try the dynamic regression approach
xreg=cbind('men' = trainset[,2],'women'=trainset[,3],'16-17'=trainset[,4],
           '18-19'=trainset[,5],'20-24'=trainset[,6],'24-34'=trainset[,7],
           '35-44'=trainset[,8],'44-54'=trainset[,9],'55+'=trainset[,10])
dr1 <-auto.arima(trainset[,1], d=0,D=1, xreg = xreg)
summary(dr1)
#auto.arima selected an ARIMA(0,0,5)(2,1,2) with errors
#let's test other models. AICc=-2332.51
dr2 <-Arima(trainset[,1], order = c(0,0,4), seasonal = c(2,1,2),xreg = xreg)
summary(dr2)#worse #AICc=-2328.85
dr3 <-Arima(trainset[,1], order = c(0,0,6), seasonal = c(2,1,2),xreg = xreg)
summary(dr3)#better -2344.71
dr4 <-Arima(trainset[,1], order = c(0,0,7), seasonal = c(2,1,2),xreg = xreg)
summary(dr4)#worse
dr5 <-Arima(trainset[,1], order = c(0,0,6), seasonal = c(1,1,2),xreg = xreg)
summary(dr5)
dr6 <-Arima(trainset[,1], order = c(0,0,6), seasonal = c(2,1,1),xreg = xreg)
summary(dr6)
dr7 <-Arima(trainset[,1], order = c(0,0,6), seasonal = c(3,1,2),xreg = xreg)
summary(dr7)
dr8 <-Arima(trainset[,1], order = c(0,0,6), seasonal = c(2,1,3),xreg = xreg)
summary(dr8)

#the best model is dr3
#check residuals
checkresiduals(dr3)
# the residuals are not white noise and the is evidence of serial correlation
checkresiduals(dr1)
#same

#let's try to forecast with it
#we have to forecast the predictors since we already know the values of the 
#predictors for the testing period, we are going to use scenario forecasting

fxreg= cbind('men' = testset[,2],'women'=testset[,3],'16-17'=testset[,4],
           '18-19'=testset[,5],'20-24'=testset[,6],'24-34'=testset[,7],
           '35-44'=testset[,8],'44-54'=testset[,9],'55+'=testset[,10])

fdr <- forecast(dr3,h=length(testset),xreg = fxreg)
fdr
autoplot(trainset[,1])+
  autolayer(fdr)
#let's check for accuracy between the two models 
accuracy(far, testset[,1])
accuracy(fdr, testset[,1])
# the dynamic arima model is preferred as it minimizes all the parameters
#fcast <- forecast(testset,h=6)
#fcast
#now let's use it to forecast unemployment for the next 6 months(starting in
#December 2021)
#this time we are going to use exante to forecast the predictors.
fcastedData = data.frame(far$mean)

fcast.exante = forecast(fdr,newdata = fcastedData,h=6)
summary(fcast.exante)

autoplot(trainset[,1])+
  autolayer(fcast.exante)

