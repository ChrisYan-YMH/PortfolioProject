Libname Sources '/home/u59206057/MS4212/Project/Sources';
Libname Project '/home/u59206057/MS4212/Project';
libname Model '/home/u59206057/MS4212/Project/Model';
libname Error '/home/u59206057/MS4212/Project/Error';

data sources.out_sample;
set sources.integrated;
if period >156 then delete;
run;

data project.Add_Trend_in_and_out_sample;
set sources.integrated;
if period >156 then delete;
if period >132 and period <= 156 then optical =.;
run;

data project.Add_Quad_in_and_out_sample;
set sources.integrated;
if period >156 then delete;
if period >132 and period <= 156 then optical =.;
Quad = Period **2;
run;

data project.Multi_Trend_in_and_out_sample;
set sources.integrated;
if period >156 then delete;
if period >132 and period <= 156 then optical =.;
LOGY= log(optical);
run;

data project.Multi_Quad_in_and_out_sample;
set sources.integrated;
if period >156 then delete;
if period >132 and period <= 156 then optical =.;
Quad = Period **2;
LOGY= log(optical);
run;


/* No seasonality Trend*/
proc reg data=project.add_trend_in_and_out_sample;
model optical = period ;
output out=model.No_Season_Trend p=forecast;
run;
data tem;
set model.no_season_trend;
keep period forecast;
run;
data error.no_season_trend;
merge sources.out_sample tem;
SE= (optical - forecast)**2;
run;
proc means data= error.no_season_trend;
var se;
run;

/* No seasonality Quad Trend*/
proc reg data=project.add_quad_in_and_out_sample;
model optical = period quad ;
output out= model.No_Season_Quad p=forecast;
run;
data tem;
set model.no_season_quad;
keep forecast period;
run;
data error.no_season_quad;
merge sources.out_sample tem;
SE = (optical- forecast)**2;
run;
proc means data=error.no_season_quad;
var se;
run;

/*
MSE for No Seasonality Trend AutoReg= 1344.96
MSE for No Seasonality Quad Trend AutoReg = 1664.34
*/


/* Multi Trend AutoReg */
proc reg data=project.multi_trend_in_and_out_sample;
model LOGY = Period d1-d11;
output out=model.Multi_Trend p=Forecast;
run;
data tem;
set model.Multi_Trend;
keep period forecast;
run;
data error.Multi_Trend;
merge sources.out_sample tem;
SE = (optical - exp(forecast))**2;
run;
proc means data=error.Multi_Trend;
var SE;
run;

/* Multi Quad Trend AutoReg */
proc reg data=project.multi_quad_in_and_out_sample;
model LOGY = period quad d1-d11 ;
output out=model.Multi_Quad p=forecast;
run;
data tem;
set model.Multi_Quad;
keep period forecast;
run;
data error.Multi_Quad;
merge sources.out_sample tem;
SE = (optical - exp(forecast))**2;
run;
proc means data=error.Multi_Quad;
var SE;
run;

/*
MSE for Multi Trend = 834.0433724
MSE for Multi Quad = 1076.02
*/


/* Plot the trend */
proc sgplot data=sources.integrated;
Title "Trend Of Optical";
series y=Optical x=Period;
run;


/* Addictive Trend AutoReg */
proc reg data=project.add_trend_in_and_out_sample;
model optical= Period d1-d11 ;
output out=Model.Add_Trend p=forecast;
run;
data tem;
set model.add_trend;
keep forecast period;
run;
data error.add_trend;
merge sources.out_sample tem;
SE = (Optical- Forecast)**2;
run;
proc means data=error.add_trend;
var SE;
run;

/* Addictive Quad Trend AutoReg */
proc reg data=project.add_Quad_in_and_out_sample;
model optical= Period Quad d1-d11;
output out=Model.Add_Quad_Trend p=forecast;
run;
data tem;
set model.Add_Quad_trend;
keep forecast period;
run;
data error.Add_Quad_trend;
merge sources.out_sample tem;
SE = (optical - forecast)**2;
run;
proc means data=error.Add_Quad_trend;
var SE;
run;

/*
MSE for Addictive Seasonality Trend Reg= 564.8132540	
MSE for Addictive Seasonality Quad Trend Reg= 898.0824582	
*/	