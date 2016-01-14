* Niamh O'Connell 12-01-2016

* A simple script to demonstrate the use of gdx input and output processing scripts in R

* This script simulates the optimal dispatch of power generation units to serve
* a time varying load such that the cost of serving that load is minimised.

sets

t time index
i generator index
;

parameters

cost(i) fuel cost for generator i
demand(t) demand at time t
Pmax(i) Maximum power generation (capacity) at generator i
Pmin(i) Minimum generation at generator i

test_2d(t,i) a test parameter to demonstrate the input of 2D data
;

* Include gdx file "Input.gdx" in the execution to find values for set and parameters
$gdxin Input
$load i t
$load cost demand Pmax Pmin test_2d
$gdxin

positive variables
P(i,t) generation at generator i at time t
;
free variables
SysCost System generation cost
;


Equations
Costs
Balance(t)
MaxOutput(i,t)
MinOutput(i,t)
;

Costs.. SysCost =e= sum((t,i),P(i,t)*cost(i));
Balance(t).. sum(i, P(i,t)) =e= demand(t);
MaxOutput(i,t).. P(i,t) =l= Pmax(i);
MinOutput(i,t).. P(i,t) =g= Pmin(i);

model ED /all/;

solve ED minimising SysCost using lp;
                           
* Save output variables in the output file "Output.gdx"
execute_unload 'Output', SysCost, P;
