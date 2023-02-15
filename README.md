# US-Unemployment-Rate-Forecasting

## For R Version 3.6 (Base R)

## Dataset:
Our dataset comes from kaggle.com, an online community of data scientists and machine learning practitioners. The data contains the seasonally unadjusted monthly unemployment rate from January 1948 to November 2021. The data also includes total unemployment, men's and women's unemployment rate, and information on subsets of the population like ages ranging from 16 to 55. We will use seasonally unadjusted unemployment rate data from the St Louis Federal Reserve database, FRED, as the control for our analysis.

## Description:
The unemployment rate is highly influenced by the business cycle and the overall health of the economy. As we have recently noticed during the pandemic, the unemployment rate skyrocketed as businesses were forced to close. We are interested in using different forecasting methods to forecast the unemployment rate. The first forecasting method we are using is time series regression. we will be regressing (yt = β0 + β1x1,t + β2x2,t + ⋯ + βkxk,t + εt) the total unemployment rate as a function of the unemployment rate of the subsets groups in our data which are: men, women, and age groups 16 to 17, 17 to 18, 19 to 24, 25 to 34, 35 to 44, 45 to 55, and 55 and older. The second forecasting method we will examine is the AutoRegressive Integrated Moving Average (ARIMA (p,d,q)) which is a model that makes the dependent variate (y) a function of the last p lags of y, its last q lagged errors and d degrees of first difference.

## Results:
1. Stepwise Regression:
The equation we received after the regression with coefficients will be:
unrate =-0.041 + 0.55*unrate_men + 0.3882423*unrate_women - 0.0002*unrate_16_to_17 - 0.003*unrate_18_to_19 + 0.029*unrate_20_to_24 + 0.05*unrate_25_to_34 - 0.005*unrate_35_to_44 - 0.035*unrate_45_to_54 + 0.009*unrate_55_over
2. ARIMA:
After using the selected Arima model to forecast the unemployment rate for the next six months after November 2021. The estimated forecasting equation is:
yt = 5.073 + 2.052yt-1 - 1.201yt-2 + 0.247yt-3 - 0.206yt-4 + 0.214yt-5 - 0.185yt6 + 0.109yt-7 - 0.032yt-8 + 0.074yt-1 + 0.294yt-2 +0.245yt-3 + 0.261yt-4 - et-1 +0.002
