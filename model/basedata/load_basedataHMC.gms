*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Household model Chile, Maule region

   Name      :   load_basedataHouseholdChile.gms
   Purpose   :   Base model data definition
   Author    :   F Fernández
   Date      :   30.09.15
   Since     :   September 2015
   CalledBy  :   .......

   Notes     :   load gdx data + parameters definition

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         SETS AND PARAMETERS                                  *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*~~~~~~~~  sets and parameters declaration   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include sets\sets_HMC.gms
$include basedata\parsHMC.gms

;

$GDXIN ..\data\supportpoints\supportpoints.gdx
$LOAD za zb
$GDXIN

*~~~~~~~~  original data (comming from data folder) ~~~~~~~~~~~~~~~~~~~~~~~~~~~*

execute_load "..\results\HouseholdChile_db_3011.gdx" p_householdData p_houGdsData p_consumptionData p_supplyData ;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         DEFINE MODEL DATA                                    *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

****************************Data for LES Parameters*****************************

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                   Beta parameter (marginal budget share)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* for the beta parameters of agricultural food products 11 support points are
* chosen, centred around the income elasticity times the average budget share at
* district/region level.
* The 11 support points are represented by:
* za(eb,j) =[0.01,0.3,0.6,0.9,1.2,1.5,1.8,2.1,2.4,2.7,3]

** ---Income elasticity
* Based on Louhichi et al (2013) All farm households have the same income
* elasticity. Income elasticity information for Chile from Seale et al. (2003)
ielas(j) = 0.586;

** --- Average budget share of agricultural activities (p(j)*c(j)/Y)
* Average across sample households within each commune
* We calculate consumption in monetary value
*(i.e prices of good consumed by consumed quantity of good (CLP$))
*   ---- Goods household data
* --- Consumption (ton) per commune
jcons_com(h,c,j)= sum(s, p_houGdsData(h,c,j,s,'cons'));

* --- Consumption (ton) per household
jcons(h,j)$(sum(c, 1$jcons_com(h,c,j)))= sum(c, jcons_com(h,c,j))/sum(c, 1$jcons_com(h,c,j));

* --- Consummer price (millions of $CLP/ton)
jprice(j)= p_consumptiondata(j,'prc')*(1/1000000);

*--- consumption value million $CLP'
consval(h,j)=jcons(h,j)*jprice(j);

*   ---- Exogenous off-farm incomes for households (million of CLP)
*It is necessary to determine off-farm income of household by commune
* We use as initial source information from Berdegué et al. 2001 Assuming that for wealthier farms
* the exinc represent a 20% of their on farm income, for H2, H3 and H4 their exinc represent their
* 50% of their on-farm income, while for the poorest represent the 80% of their on-farm income

exinc('H1') = 0.2 * [[sum((c,a,s), p_householdData('H1',c,a,s,'srev'))/sum((c,a,s), 1$p_householdData('H1',c,a,s,'srev'))] *(1/1000000)] ;
exinc('H2') = 0.5 * [[sum((c,a,s), p_householdData('H2',c,a,s,'srev'))/sum((c,a,s), 1$p_householdData('H2',c,a,s,'srev'))] *(1/1000000)] ;
exinc('H3') = 0.5 * [[sum((c,a,s), p_householdData('H3',c,a,s,'srev'))/sum((c,a,s), 1$p_householdData('H3',c,a,s,'srev'))] *(1/1000000)] ;
exinc('H4') = 0.5 * [[sum((c,a,s), p_householdData('H4',c,a,s,'srev'))/sum((c,a,s), 1$p_householdData('H4',c,a,s,'srev'))] *(1/1000000)] ;
exinc('H5') = 0.8 * [[sum((c,a,s), p_householdData('H5',c,a,s,'srev'))/sum((c,a,s), 1$p_householdData('H5',c,a,s,'srev'))] *(1/1000000)] ;

*   ---- Subsidies million $CLP
* We based subsidies data in the CASEN 2013.
* We assume differentiated subsidies depending on the households types. We assume that each
* Farm type belong to different quintiles H1 belong to the highest quintile while H5 to the poorest

sb('H1') =  47328 * (1/1000000);
sb('H2') = 242772 * (1/1000000);
sb('H3') = 242772 * (1/1000000);
sb('H4') = 242772 * (1/1000000);
sb('H5') = 772800 * (1/1000000);

*Farm household full income
Y_0_com(h,c) = [[[sum((a,s), p_householdData(h,c,a,s,'gmar'))]*(1/1000000)] + exinc(h) + sb(h)];
Y_0(h) = sum(c, Y_0_com(h,c))/sum(c, 1$Y_0_com(h,c));

* ---consumption values for "market goods"
* Based on "VII Encuesta de Presupuestos Familiares"  (INE, 2013) we assume the
* following values for budget share for non-agricultural goods
* The first quintil 35% of their budget share is in Food
* The second quintil 30% of their budget share is in Food
* The third quintil 25% of their budget share is in Food
* The fourth quintil 20% of their budget share is in Food
* The fifth quintil 12% of their budget share is in Food

consval('H1','nagr-g')= Y_0('H1')*(0.88);
consval('H2','nagr-g')= Y_0('H2')*(0.80);
consval('H3','nagr-g')= Y_0('H3')*(0.75);
consval('H4','nagr-g')= Y_0('H4')*(0.72);
consval('H5','nagr-g')= Y_0('H5')*(0.68);


* --- budget share of agricultural goods (p(j)*c(j)/Y)
bdgtshr(h,j) = [jcons(h,j)*jprice(j)]/Y_0(h);

* --- budget share of non-agricultural goods
bdgtshr(h,'nagr-g') = consval(h,'nagr-g')/Y_0(h);

** --- Average budget share
avs(j)$(sum(h, 1$bdgtshr(h,j)) gt 0)= sum(h, bdgtshr(h,j))/sum(h, 1$bdgtshr(h,j))    ;
avs('nagr-g')$(sum(h, 1$bdgtshr(h,'nagr-g')) gt 0)= sum(h, bdgtshr(h,'nagr-g'))/sum(h, 1$bdgtshr(h,'nagr-g')) ;

*--- Values of support points for beta
Z1(eb,j) = za(eb,j)*ielas(j)*avs(j) ;

*--- Support points for the beta parameter of the additional goods ("market goods)
Z1(eb,'nagr-g') = za(eb,'nagr-g');

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                   Gamma parameter (uncompressible consumption)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* for the gamma parameter, 5 support points are chosen (i.e. K’ = 5), ranging between
* ± 100% times the average uncompressible consumption across farm households for
* each good. The 11 support points are represented by:
* zb(eg,j) =[0,0.5,1,1.5,2]

*   ----Frisch own price elasticity from (Seale et al. 2003)  (+/- ????)
Scalar
lambda Frisch parameter                                  /0.474/
;

* --- average Gamma parameter by household -  average uncompressible consumption
avg_hougamma(h,j)$(jprice(j) gt 0) =  [Y_0(h)/jprice(j)]*[avs(j)+([ielas(j)*avs(j)]/lambda)];
avg_hougamma(h,'nagr-g')$(consval(h,'nagr-g') gt 0) =  [Y_0(h)/consval(h,'nagr-g')]*[avs('nagr-g')+([ielas('nagr-g')*avs('nagr-g')]/lambda)];


* --- average Gamma parameter by commune -  average uncompressible consumption
avg_comgamma(j)$(sum(h, 1$avg_hougamma(h,j)) gt 0) = sum(h, avg_hougamma(h,j))/sum(h, 1$avg_hougamma(h,j));

* --- Support points for gamma
Z2(eg,j) = zb(eg,j) * avg_comgamma(j)   ;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                                 Error term (mhu)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* For the error term m we use the common assumption where three support points
*(i.e., K” = 3) are symmetrically defined around zero and bounded by the
* so-called “three sigma rule”

Kst = card(ee);

*--- average consumption of good by commune
avgc(j)$(sum(h, 1$jcons(h,j)) gt 0)= sum(h, jcons(h,j))/sum(h, 1$jcons(h,j));

*---standar deviation of consumption and expenditure in good j
std_les(j) = sqrt({sum(h,sqr(jcons(h,j)-avgc(j)))/Kst});
std_les('nagr-g')= sqrt({sum(h,sqr(bdgtshr(h,'nagr-g')-avs('nagr-g')))/Kst});


* --- Support points for the error term mhu
Z3(h,'e1',j) = -3*std_les(j);
Z3(h,'e2',j) = 0;
Z3(h,'e3',j) =  3*std_les(j);


display jcons, jprice, exinc, sb, Y_0, bdgtshr, avs, Z1, avg_hougamma, avg_comgamma, Z2, avgc, std_les, Z3;

********************************************************************************
*                  DEFINE CORE MODEL AND CALIBRATION DATA                      *
********************************************************************************

****************************CALIBRATION AND CORE MODEL DATA*********************
*   ---- Gross Margin observed per household per activity per system
grmrg0(h,a,s)$(sum(c, p_householdData(h,c,a,s,'gmar')) gt 0) = sum(c, p_householdData(h,c,a,s,'gmar'))/sum(c, 1$p_householdData(h,c,a,s,'gmar'));

*   ---- crop area (ha) (only activities with gmar >0) household.comunne level-----
***Note !! --> If we take into account only activities with gmar > 0 subsistence farm types are ignored
*so we eliminate the condition under wich the statement is executed????? (i.e.
x0(h,a,s)$(grmrg0(h,a,s) gt 0)= sum(c, p_householdData(h,c,a,s,'area'));

*x0(h,a,s)= p_householdData(h,c,a,s,'area');
x0(h,a,'tot')= x0(h,a,'dry')+ x0(h,a,'irr');

*   ---- farmland availability (ha) regional level
tland       =  sum((h,a),X0(h,a,'tot'));

* --- Total land of household within the region
thland(h)   = sum(a,X0(h,a,'tot'));

* --- Irrigated land regional level
icland      = sum((h,a),X0(h,a,'irr'));

*   ---- household weight within the commune
w(h)= thland(h)/tland ;

*   ---- crop data household
* --- yield (ton/ha)
yld(h,a,s)$(sum(c, p_householdData(h,c,a,s,'yld')) gt 0)= sum(c, p_householdData(h,c,a,s,'yld'))/sum(c, 1$p_householdData(h,c,a,s,'yld'));

*   ---- labour
labreq(h,a,s)$(sum(c, p_householdData(h,c,a,s,'tot_lab'))gt 0)= sum(c, p_householdData(h,c,a,s,'tot_lab'))/sum(c, 1$p_householdData(h,c,a,s,'tot_lab')) ;
labrnt(h,a,s)$(sum(c, p_householdData(h,c,a,s,'hrd_lab'))gt 0)= sum(c, p_householdData(h,c,a,s,'hrd_lab'))/sum(c, 1$p_householdData(h,c,a,s,'hrd_lab'));
labfam(h,a,s)$(sum(c, p_householdData(h,c,a,s,'fam_lab'))gt 0)= sum(c, p_householdData(h,c,a,s,'fam_lab'))/sum(c, 1$p_householdData(h,c,a,s,'fam_lab'));

totLab = sum((h,a,s), [labrnt(h,a,s) +  labfam(h,a,s)]*x0(h,a,s));

** --- average labour input per activity and system
avgLab(a,s)$(sum(h,labreq(h,a,s)) gt 0) = sum(h,labreq(h,a,s))/sum(h,1$labreq(h,a,s))   ;

** --- average family labour available per household and commune
avFamLab(h)$(sum((a,s),labfam(h,a,s)) gt 0) = sum((a,s),labfam(h,a,s))/sum((a,s),1$labfam(h,a,s));

** ---- Average price Hired labour by activity and system
LabWage$(sum((h,c,a,s),p_householdData(h,c,a,s,'HLab_Price')) gt 0) = [sum((h,c,a,s),p_householdData(h,c,a,s,'HLab_Price'))/sum((h,c,a,s),1$p_householdData(h,c,a,s,'HLab_Price'))] * (1/1000000) ;

** ---- hire-out  wage rate (millions $CLP per day)
owage$(sum((h,c,a,s),p_householdData(h,c,a,s,'FLab_Price')) gt 0) = [sum((h,c,a,s),p_householdData(h,c,a,s,'FLab_Price'))/sum((h,c,a,s),1$p_householdData(h,c,a,s,'FLab_Price'))] * (1/1000000) ;

*   ---- Matrix of technical coefficients
Am(h,a,s,'land')$yld(h,a,s) = 1;
Am(h,a,s,'lab')$yld(h,a,s)= labreq(h,a,s);

*   ---- Initial resource endowment
B(h,'land')= thland(h);
B(h,'lab') = sum((a,s),labreq(h,a,s));

* ---economic output coefficient (yield of activiti a)
yl(h,a,s,j)$(aj(a,j) and (1$yld(h,a,s)) gt 0)= yld(h,a,s)/1$yld(h,a,s);

*   ---- Accounting costs (variable costs millions $CLP) without Labour Cost per commune
acst_com(h,c,a,s) = [p_householdData(h,c,a,s,'vcost') * (1/1000000)] - {[[p_householdData(h,c,a,s,'hrd_lab')*p_householdData(h,c,a,s,'HLab_Price')] - [p_householdData(h,c,a,s,'fam_lab')*p_householdData(h,c,a,s,'FLab_Price')]]*(1/1000000)}  ;

** --- Accounting cost per household Accounting costs per household
acst(h,a,s)$(sum(c,acst_com(h,c,a,s)) gt 0) = sum(c,acst_com(h,c,a,s))/sum(c,1$acst_com(h,c,a,s));


*   ---- Producer prices (millions $CLP/ton)
pprice(a) = p_supplyData(a,'prd_prc') * (1/1000000);



*   ---- Multiplicative transaction costs of goods (tb = buyer; ts = seller) ????
***This multiplicative must be put by commune, probably each commune have different transaction costs
$ontext
"In the absence of transaction costs the multiplicative buyer and seller transaction
costs (t) are equal to one. and the farm household prices are equal to market prices
In such situation, the farm household model is collapsed to a farm supply model working
with exogenous prices and an additional constraint of consumption. In contrary, in the
presence of transaction costs, farm household's prices are different to market prices and
production and consumption decisions are non-separable and the household may choose to live
in partial or total autarky"
$offtext
tb(h,j)=1;
ts(h,j)=1;

$ontext
tb(h,'PEN',j) = 1;
tb(h,'SC',j) = 1;
tb(h,'CAU',j) = 1.2;
tb(h,'PAR',j) = 1.1;

ts(h,'PEN',j) = 1;
ts(h,'SC',j) = 1;
ts(h,'CAU',j) = 1.4;
ts(h,'PAR',j) = 1.3;
$offtext

selas(a)= p_supplyData(a,'selast');

* Elasticities not supported by literature!!! (Just for testing)
** Elastic activities
selas('mel')= 1.1;
selas('wtm')= 1.25;

**Inelastic activities
selas('tom')= 0.9;
selas('oni')= 0.85;

display x0, tland, thland, icland, w, yld, labreq, labrnt, labfam, totLab, Am, B, yl, acst, tb, ts, selas, pprice, avgLab, avFamLab, LabWage, consval;




*   ---- crop area (ha) (only activities with gmar >0) household.comunne level-----
***Note !! --> If we take into account only activities with gmar > 0 subsistence farm types are ignored
*so we eliminate the condition under wich the statement is executed (i.e.
*x0(h,c,a,s)$(p_householdData(h,c,a,s,'gmar') gt 0)= p_householdData(h,c,a,s,'area');

*x0(h,c,a,s)= p_householdData(h,c,a,s,'area');
*x0(h,c,a,'tot')= x0(h,c,a,'dry')+ x0(h,c,a,'irr');
