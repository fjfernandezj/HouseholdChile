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
map_has(h,a,s)= yes$X0(h,a,s);
map_hj(h,j) = yes$jcons(h,j) ;

*   ---- definition of base model parameters
*   ---- LES parameters
$gdxin basedata\lespar.gdx
$load  lespar
$gdxin

;

gamma(h,j)$map_hj(h,j)= lespar(h,j,'gamma');
beta(h,j)$map_hj(h,j)= lespar(h,j,'beta');


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
X.fx(h,a,s)$(not map_has(h,a,s)) = 0;

* bounds on variables
X.up(h,a,s)$map_has(h,a,s) = tland;
*prdq.up(h,c,j) = sum((a,s),yl(h,c,a,s,j)*x0(h,c,a,s));
*cs.up(h,c,j)= jcons_com(h,c,j);
*cnsq.up(h,c,j)= sum((a,s),yl(h,c,a,s,j)*x0(h,c,a,s));
*HLAB.up(h,c) = sum((a,s), labrnt(h,c,a,s)) ;
*FLAB.up(h) = avFamLab(h)   ;
*HLAB.l(h) = sum((a,s), labrnt(h,a,s));

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

CALIB1(h,a,s)..  x(h,a,s)$map_has(h,a,s) =l= x0(h,a,s)*(1+eps1);

Model calibHousehold calibration model MB /
   household_noRisk
   eq_AgrInc_LP
   eq_cshcnstrnt_LP
   calib1
/;


solve calibHousehold using NLP maximizing U;

parameter chPMP, cpar;
*chPMP(h,c,a,s,'sgm') = sgm(h,c,a,s);
chPMP(h,a,s,'X0')  = x0(h,a,s);
chPMP(h,a,s,'calib') = x.l(h,a,s);

*~~~~~~~~~~~~~~~~~~~~~~~~  COST FUNCTION PARAMETERS            ~~~~~~~~~~~~~~~~*
* mu1
mu1(h,a,s)$map_has(h,a,s)  = CALIB1.M(h,a,s);

BETACST(h,a,s)$map_has(h,a,s) = 1/selas(a);

ALPHACST(h,a,s)$map_has(h,a,s)= (1/(1+BETACST(h,a,s)))*(acst(h,a,s)+mu1(h,a,s))*x0(h,a,s)**(-BETACST(h,a,s));

*   ---- checking pmp parameters
cpar(h,a,s,'alpha')$map_has(h,a,s)  = ALPHACST(h,a,s);
cpar(h,a,s,'beta')$map_has(h,a,s)   = BETACST(h,a,s);

*   ---- create gdx file with model data
display chPMP, cpar;


