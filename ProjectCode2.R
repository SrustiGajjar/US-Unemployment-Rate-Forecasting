library(fpp2)
library(urca)
library(readxl)
library(dplyr)


#a. Convert this data from a data.frame to a ts object in R.
unrate <- read_excel("C:\\Users\\srusti\\Desktop\\MSBA\\Sem2\\ECON\\project\\unemployment_rate_data.xlsx")
#View(unrate)

unrate = ts(unrate[2:11],frequency = 12)
autoplot(unrate, facets = T)
