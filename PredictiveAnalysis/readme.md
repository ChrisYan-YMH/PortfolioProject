# Projec Aim
This project aims to forecast the GDP of optical retail in Hong Kong.The available data we have is from 2005 Jan and 2022 May, but only 2005 Jan to 2014 Dec is the in-samepl data and 2015 Jan to 2017 Dec is the out-sample data. 2018 Jan to 2019 Dec will be used for the forecast period.

# The following forecasting models are applied to the data.
a)	Double moving average <br/>
The double moving average is a method which is suitable for the linear trend series. The idea behind this method is that we are trying to smooth out the random fluctuation in specified n periods. And its general form for forecasting is to add a constant to coefficient(slope) time m periods ahead in the future 

b)	Brown Double Exponential Method <br/>
Brown double exponential method is suitable for linear trend series and the coefficient, and the constant may change slowly with time. The alpha acts as smoothing constant for the level of the series that minimizes the MSE will be used for the calculation of the simple exponential statistics and double exponential statistics. The idea behind is to calculate the simple exponential statistics first and then smooth the simple exponential statistic by double exponential smoothing. The weight decreases exponentially with heavier weight to recent observation and smaller weights given to old observations. The initialization will be simply using Delurgio way. The general form of forecasting m-step ahead would be adding a constant (current level of the data at time t) to the coefficient(slope) time m period ahead. 

c)	Holt Double Exponential Method <br/>
Holt’s Method is like Brown’s. The differences are the estimate of the current level of the data at time t and the slope of the series. By adding the trend form of t-1 time period to the simple exponential statics of the t-1 time period, the estimate of the current of the data at time t will be adjusted by the trend. The slope will be also multiplied by the trend form of t-1 period and, in addition, time the beta which is acted as smoothing constant for the trend and determined by choosing the value that can minimize MSE.

d)	Winter Multiplicative Method <br/>
Winter Multiplicative Method is suitable for linear trend and multiplicative seasonality and multiplicative seasonality series. Alpha, beta, and gamma that will minimize the MSE will be used for the modeling. The role of alpha and beta are the same as Holt Double Exponential Method, smoothing constant for level of the series and the trend, respectively. The additional gamma acts as smoothing constant for the seasonality. The initialization in Winter Multiplicative Method will be using Markridakis. If the magnitude of the seasonality changes with the time period, then Winter Multiplicative will be used for handling the multiplicative seasonality. Otherwise, Winter Addictive Method will be used. 

e)	Winer Addictive Method <br/>
Winter Addictive Method is basically same as the Winter Multiplicative Method, except Winter Addictive Method is suitable for addictive seasonality

f)	Multiplicative decomposition & Addictive decomposition <br/>
The idea behind this method is to decompose the timer series into serval components, like, trend, cyclical and seasonal component and each component can be estimated. For the multiplicative decomposition, all these components will be multiplied together in order to get the forecast. For the addictive decomposition, sum of all these components together will give us the forecast value. If the seasonal component's magnitude changes with the time period, then multiplicative decomposition will be used for handling the multiplicative seasonality. Otherwise, addictive decomposition will be used.

g)	Seasonal ARIMA models <br/>
The idea behind ARIMA is making use of the autoregressive and moving average and achieving stationarity by integrating or differencing of the data. The AR part in the ARIMA model specifies that the output variable depends linearly on its own past value. The MA part indicates the regression error is a linear combination of error term whose value occurred contemporaneously and at various times in the past. Before the seasonal ARIMA model is implemented, pre-differencing will be performed to stabilize the seasonal variation. The parameters in the model will be found by maximum likelihood estimation.

# Result
ARIMA(3,1,0)(0,1,1)12 is the best model, and it will be chosen for prediction of the forecast period
