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
*--- BETA-LES Parameter
ielas        income elasticity for agricultural food products
jcons_com    Goods consumption (ton) per commune
jcons        Goods consumed (ton) per household
jprice       Consumer prices (millions of $CLP per ton)
consval      Consumption value million $CLP
exinc        Exogenous off-farm incomes for households (millions of $CLP)
sb           Subsidies (millions of $CLP)
Y_0_com      Initial Farm household full income per commune (millions of $CLP)
Y_0          Initial Farm household full Income (millions of $CLP)
bdgtshr      budget share by household-commune and good
avs          average budget share per good per commune
za           pre-support points for beta
Z1           Values of support points for beta

*--- GAMMA-LES Parameter
avg_hougamma average Gamma parameter by household -  average uncompressible consumption
avg_comgamma average Gamma parameter by commune -  average uncompressible consumption
zb           pre-support points for gamma
Z2           Values of support points for gamma

*--- MHU-LES Parameter (Error term)
Kst          Number of supports for mhu LES
avgc         average consumption of good by commune
std_les      standar deviation of consumption and expenditure in good j
Z3           Values of support points for mhu


**--- Core Model Data
tcland       Total land per commune
thland       Total land of household f per commune
icland       irrigable land (ha) commune
w            Farm household weight within the commune
BETACST      Implicit cost function's Beta parameter
ALPHACST     Implicit cost function's Alpha parameter
labrnt       Hired labour (working days)
labfam       Family labour (working days)
Am           Input coefficients (input use of factor f in activity a)
B            Initial resource endowment
yl           economic output coefficient (yield of activiti a)
tb           Multiplicative transaction costs of goods (buyer)
ts           Multiplicative transaction costs of goods (seller)
acst         Accounting costs
avgLab       Average labour per activity and system
avFamLab     average family labour available per household and commune
HrdPrice     Hired labour average price (million $CLP)

$ontext

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

*   ---- base year data commune------
   yld          "crop yield (tons/h)"

   x0           "crop area (2011) in ha household-commune level"

   lab          "Total labour (2011) working days"

   pprice       "Producer prices (millions $CLP/ton) (2011)"

   selas        "supply elasticity"

* model data for baseline
   p_householdData(*,*,*,*,*)   'crop management data household level'
   p_houGdsData(*,*,*,*,*)      'Goods and Factors household data'
   p_consumptionData(*,*)       'Consumption data'
   p_supplyData(*,*)            'Supply data'

*   ---- LES function parameters
   beta        "marginal budget share"
   gamma       "minimum subsistence"
   lespar      "LES parameters"


  ;


