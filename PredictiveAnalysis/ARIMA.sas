libname data '/home/u59206057/MS4212/Project/ARIMA/Data';
libname source '/home/u59206057/MS4212/Project/Sources';
libname program '/home/u59206057/MS4212/Project/ARIMA/Program';

/* Prepare the data */
DATA data.Integrated;
set source.integrated;
if period > 156 then delete;
drop d1-d11;
LY = log(optical);
LYDIF = DIF(LY);
LYDIF12 = DIF12(LY);
LYDIF112 = DIF(DIF12(LY));
run;

/* Plot the Optical LY LUDIF12 LYDIF112 Against Time*/
proc gplot data=data.arima_in_out_sample;
plot Optical*Period;
plot LY*period;
plot LYDIF12*period;
plot LYDIF112*period;
symbol i=j;
run;

/* Build the ARIMA Model */
proc arima data=data.Integrated;
identify var=LY;
identify var=LY(1); /*No seasonality*/;
identify var=LY(12); /*With seasonality*/;
identify var=LY(1,12) /*With both*/;
estimate P=3 Q=(12); /*Best Model*/
estimate P=(1,2,3)(12);
estimate P=(1,2,3)(12) Q=(12);
estimate P=3 Q=(1)(12);
estimate P=(1,2,3)(12) Q=(1);
estimate P=(1,2,3)(12) Q=(1)(12);

estimate P=3 Q=(1)(12);
forecast lead=24 out=Forecast;
run;

data tem;
set Forecast;
T= _n_;
Y = exp(LY);
FY = exp(FORECAST);
L95CI = exp(L95);
U95CI = exp(U95);
run;

proc print data=tem;
var Y L95CI FY U95CI;
run;

proc gplot data=tem;
plot Y*T FY*T L95CI*T U95CI*T/overlay;
SYMBOL1 COLOR=blue INTERPOL=join LINE=1;
SYMBOL2 COLOR=red INTERPOL=join LINE=1;
SYMBOL3 COLOR=green INTERPOL=join Line=2;
SYMBOL4 COLOR=green INTERPOL=join Line=2;
run;

