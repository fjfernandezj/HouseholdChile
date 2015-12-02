*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Householdmodel Chile

   Name      :   household_pmpCalibration.gms
   Purpose   :   model Household Chile (PMP)
   Author    :   F Fernández
   Date      :   18/11/2015
   Since     :   September 2015
   CalledBy  :

   Notes     :

$offtext
$onmulti;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         INCLUDE SETS AND BASE DATA                           *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include basedata\load_basedataHMC.gms
;

*~~~~~~~~~~~~~~~~~~~~~~~~ BASEYEAR DATA    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*   ---- definition of current activities in each household
map_hcas(h,c,a,s)= yes$X0(h,c,a,s);

*   ---- definition of base model parameters

*~~~~~~~~~~~~~~~~~~~~~~~~ CALIBRATION PARAMETERS            ~~~~~~~~~~~~~~~~~~*
Parameter
   eps1       "epsilon (activity)"
   eps2       "epsilon (crop)"
   eps3       "epsilon (total crop area)"
   mu1        "dual values from calibration constraints (activity)"
   mu2        "dual values from calibration constraints (group)"
   mu3        "dual values from calibration constraints (total activity area)"
   cvpar      "cost function parameters"
   LambdaL    "land marginal value"

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*            PMP CALIBRATION -                                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*~~~~~~~~~~~ SOLVE Household MODEL WITH CALIBRATION CONSTRAINTS ~~~~~~~~~~~~~~~*
$include HMC_coreModel.gms
;

* consider only potential activities
X.fx(h,c,a,s)$(not map_hcas(h,c,a,s)) = 0;

* bounds on variables
X.up(h,c,a,s)$map_hcas(h,c,a,s) = tcland(c);


model basemodel modelo lineal base /
   household_noRisk
   eq_AgrInc_LP
   eq_cshcnstrnt_LP
/;

solve basemodel using NLP maximizing U;


*   ---- calibration parameters
*   ---- eps1 > eps2 - ep2 < eps3
eps1=0.000001;
eps2=0.0000001;
eps3=0.000001;

*   ---- calibration constraints
equation
   calib1    calibration constraints (activity)
;

CALIB1(h,c,a,s)..  x(h,c,a,s)$map_hcas(h,c,a,s) =l= x0(h,c,a,s)*(1+eps1);

Model calibHousehold calibration model MB /
   household_noRisk
   eq_AgrInc_LP
   eq_cshcnstrnt_LP
   calib1
/;


solve calibHousehold using NLP maximizing U;

parameter chPMP, cpar;
*chPMP(h,c,a,s,'sgm') = sgm(h,c,a,s);
chPMP(h,c,a,s,'X0')  = x0(h,c,a,s);
chPMP(h,c,a,s,'calib') = x.l(h,c,a,s);

*~~~~~~~~~~~~~~~~~~~~~~~~  COST FUNCTION PARAMETERS            ~~~~~~~~~~~~~~~~*
* mu1
mu1(h,c,a,s)$map_hcas(h,c,a,s)  = CALIB1.M(h,c,a,s);

BETACST(h,c,a,s)$map_hcas(h,c,a,s) = 1/selas(a);

ALPHACST(h,c,a,s)$map_hcas(h,c,a,s)= (1/(1+BETACST(h,c,a,s)))*(acst(h,c,a,s)+mu1(h,c,a,s))*x0(h,c,a,s)**(-BETACST(h,c,a,s));

*   ---- checking pmp parameters
cpar(h,c,a,s,'alpha')$map_hcas(h,c,a,s)  = ALPHACST(h,c,a,s);
cpar(h,c,a,s,'beta')$map_hcas(h,c,a,s)   = BETACST(h,c,a,s);

*   ---- create gdx file with model data
display chPMP, cpar;


