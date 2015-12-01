*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Household Model Chile, Maule region

   Name      :   parshouseholdChile.gms
   Purpose   :   Core model parameters
   Author    :   F Fernández
   Date      :   30.09.15
   Since     :   September 2015
   CalledBy  :   run1_calPMP

   Notes     :   Declaration of core model parameters

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         PARAMETERS DECLARATION                               *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

* ---- DEFINING PARAMETERS FOR GME - LES function

Parameter
ielas        income elasticity for agricultural food products
jcons        Goods consumed (ton)
jprice       Consumer prices (millions of $CLP per ton)
exinc        Exogenous off-farm incomes for households (millions of $CLP)
sb           Subsidies (millions of $CLP)
Y_0          Initial Farm household full Income (millions of $CLP)
bdgtshr      budget share by household-commune and good
avs          average budget share per good per commune

$ontext
Y_0          Initial Farm household full Income ( millions of $CLP)
consval      Consumption in monetary value -prices of good by consumed quantity of good (CLP$)-
pm           Market price of goods and tradable factor
Z1           Values of support points for beta
Z2           Values of support points for gamma
Z3           Values of support points for mhu
ZM(eb,m)     Values of support points for market goods (non-agricultural goods)
za(eb,j)     pre-support points for beta
zb(eg,j)     pre-support points for gamma
bdgtshr      budget share by household-commune and good
avs          average budget share per good per commune
avgch        average consumption of good by household
avgc         average consumption of good by commune
std_les      sample standar deviation of consumption and expenditure in good j
cp           Consumer price
p_gammah     gamma parameter per household
p_gamma      gamma parameter per commune
Kst          Number of state of nature
gdc          Goods consumed



tcland       Total land per commune
thland       Total land of household f per commune
icland       irrigable land (ha) commune
w            Farm household weight within the commune
phi          Risk aversion coefficient
lab          Labor demand per hectare (man days)
labrnt       Labor rented-in per household-commune crop and system (man days)
B            Initial resource endowment
y_oc         Economic output coefficient (yield of activity i)
sb           Subsidies
pm           Market prices of goods and tradable factors
tb           Multiplicative transaction costs of goods (buyer)
ts           Multiplicative transaction costs of goods (seller)
acst         Accounting costs
d            Implicit cost function's parameters estimated with PMP-ME
Q
lambda       Implicit marginal costs of tradable factors revealed through PMP approach
fc           Fixed costs

*Kst          number of state of nature



Am           Input coefficients (input use of factor f in activity a)
gamma        Household expenditure function's parameter - les parameter
beta         Household expenditure function's parameter - les parameter
P            Poverty line
Hc           Household composition
BETACST
ALPHACST
cpar

*   ---- base year data commune------
   yld          "crop yield (tons/h)"

   x0           "crop area (2011) in ha household-commune level"

   w0           "water delivery (2011) in m3 commune level"

   selas        'supply elasticity'
   delas        'demand elasticity'

   DW           'Gross Water Delivered'

* model data for baseline
   p_householdData(*,*,*,*,*)   'crop management data household level'
   p_houGdsData(*,*,*,*,*)      'Goods and Factors household data'
;

$offtext

* model data for baseline
   p_householdData(*,*,*,*,*)   'crop management data household level'
   p_houGdsData(*,*,*,*,*)      'Goods and Factors household data'
   p_consumptionData(*,*)       'Consumption data'
   p_supplyData(*,*)            'Supply data'




