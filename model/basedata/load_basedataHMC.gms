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
* --- Consumption (ton)
jcons(h,c,j)= sum(s, p_houGdsData(h,c,j,s,'cons'));

* --- Consummer price (millions of $CLP/ton)
jprice(j)= p_consumptiondata(j,'prc')*(1/1000000);

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

*Farm household full income - Assuming that Agricultural revenue represent 55% of total income
**Sources:
* -INDAP -PUC (2013) ANALISIS DE LA VARIABLE INGRESO DE LAS EXPLOTACIONES DEL SEGMENTO PRODUCTOR VULNERABLE DE LA PEQUEÑA AGRICULTURA ATENDIDA POR INDAP
* -FAO 2009
Y_0(h,c) = [[[sum((a,s), p_householdData(h,c,a,s,'gmar'))]*(1/1000000)] + exinc(h) + sb(h)];

* --- budget share of agricultural activities (p(j)*c(j)/Y)
bdgtshr(h,c,j) = [jcons(h,c,j)*jprice(j)]/Y_0(h,c);


** --- Average budget share
avs(c,j)$(sum(h, 1$bdgtshr(h,c,j)) gt 0)= sum(h, bdgtshr(h,c,j))/sum(h, 1$bdgtshr(h,c,j))    ;      ;
*avs(c,'nagr-g') = 1 - sum(j, avs(c,j));

*--- Values of support points for beta
Z1(eb,c,j) = za(eb,j)*ielas(j)*avs(c,j) ;

*--- Support points for the beta parameter of the additional goods ("market goods)
Z1(eb,c,'nagr') = za(eb,'nagr-g');

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                   Gamma parameter (uncompressible consumption)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* for the gamma parameter, 5 support points are chosen (i.e. K’ = 5), ranging between
* ± 100% times the average uncompressible consumption across farm households for
* each good. The 11 support points are represented by:
* zb(eg,j) =[0,0.5,1,1.5,2]

*   ----Income elasticity from (Seale et al. 2003)
Scalar
lambda Frisch parameter                                  /-0.474/
;

* --- average Gamma parameter by household -  average uncompressible consumption
avg_hougamma(h,c,j) =  [Y_0(h,c)/jprice(j)]*[avs(c,j)+([ielas(j)*avs(c,j)]/lambda)];

* --- average Gamma parameter by commune -  average uncompressible consumption
avg_comgamma(c,j)$(sum(h, 1$avg_hougamma(h,c,j)) gt 0) = sum(h, avg_hougamma(h,c,j))/sum(h, 1$avg_hougamma(h,c,j));

* --- Support points for gamma
Z2(eg,c,j) = zb(eg,j) * avg_comgamma(c,j)   ;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                                 Error term (mhu)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* For the error term m we use the common assumption where three support points
*(i.e., K” = 3) are symmetrically defined around zero and bounded by the
* so-called “three sigma rule”

Kst = card(ee);

*--- average consumption of good by commune
avgc(c,j)$(sum(h, 1$jcons(h,c,j)) gt 0)= sum(h, jcons(h,c,j))/sum(h, 1$jcons(h,c,j));

*---standar deviation of consumption and expenditure in good j
std_les(c,j) = sqrt({sum(h,sqr(jcons(h,c,j)-avgc(c,j)))/Kst});

* --- Support points for the error term mhu
Z3(h,c,'e1',j) = -3*std_les(c,j);
Z3(h,c,'e2',j) = 0;
Z3(h,c,'e3',j) =  3*std_les(c,j);


display jcons, jprice, exinc, sb, Y_0, bdgtshr, avs, Z1, avg_hougamma, avg_comgamma, Z2, avgc, std_les, Z3;


****************************CALIBRATION AND CORE MODEL DATA*********************

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*                   Beta parameter (marginal budget share)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*   ---- crop area (ha) (only activities with gmar >0) household.comunne level-----
***Note !! --> If we take into account only activities with gmar > 0 subsistence farm types are ignored
*so we eliminate the condition under wich the statement is executed (i.e.
*x0(h,c,a,s)$(p_householdData(h,c,a,s,'gmar') gt 0)= p_householdData(h,c,a,s,'area');

x0(h,c,a,s)= p_householdData(h,c,a,s,'area');
x0(h,c,a,'tot')= x0(h,c,a,'dry')+ x0(h,c,a,'irr');

*   ---- farmland availability (ha) commune level
tcland(c)   = sum((h,a),X0(h,c,a,'tot'));

* --- Total land of household per commune
thland(h,c) = sum(a,X0(h,c,a,'tot'));

* --- Irrigated land per commune
icland(c)   = sum((h,a),X0(h,c,a,'irr'));

*   ---- household weight within the commune
w(h,c)= thland(h,c)/tcland(c) ;

*   ---- crop data household
* --- yield (ton/ha)
yld(h,c,a,s)= p_householdData(h,c,a,s,'yld');

*   ---- labour
lab(h,c,a,s)= p_householdData(h,c,a,s,'tot_lab') ;
labrnt(h,c,a,s)= p_householdData(h,c,a,s,'hrd_lab');
labfam(h,c,a,s)= p_householdData(h,c,a,s,'fam_lab');

** --- average labour input per activity and system
avgLab(a,s)$(sum((h,c),lab(h,c,a,s)) gt 0) = sum((h,c),lab(h,c,a,s))/sum((h,c),1$lab(h,c,a,s))   ;

** --- average family labour available per household and commune
avFamLab(h,c)$(sum((a,s),labfam(h,c,a,s)) gt 0) = sum((a,s),labfam(h,c,a,s))/sum((a,s),1$labfam(h,c,a,s));

** ---- Average price Hired labour by activity and system
HrdPrice(a,s)$(sum((h,c),p_householdData(h,c,a,s,'HLab_Price')) gt 0) = [sum((h,c),p_householdData(h,c,a,s,'HLab_Price'))/sum((h,c),1$p_householdData(h,c,a,s,'HLab_Price'))] * (1/1000000) ;


*   ---- Matrix of technical coefficients
Am(h,c,a,s,'land')$yld(h,c,a,s) = 1;
Am(h,c,a,s,'lab')$yld(h,c,a,s)= lab(h,c,a,s);

*   ---- Initial resource endowment
B(h,c,'land')= thland(h,c);
B(h,c,'lab') = sum((a,s),lab(h,c,a,s));

* ---economic output coefficient (yield of activiti a)
yl(h,c,a,s,j)$(aj(a,j) and (1$yld(h,c,a,s)) gt 0)= yld(h,c,a,s)/1$yld(h,c,a,s);

*   ---- Accounting costs (variable costs millions $CLP)
acst(h,c,a,s) = p_householdData(h,c,a,s,'vcost') * (1/1000000);

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
tb(h,c,jf)=1;
ts(h,c,jf)=1;

$ontext
tb(h,'PEN',jf) = 1;
tb(h,'SC',jf) = 1;
tb(h,'CAU',jf) = 1.2;
tb(h,'PAR',jf) = 1.1;

ts(h,'PEN',jf) = 1;
ts(h,'SC',jf) = 1;
ts(h,'CAU',jf) = 1.4;
ts(h,'PAR',jf) = 1.3;
$offtext

selas(a)= p_supplyData(a,'selast');

display x0, tcland, thland, icland, w, yld, lab, labrnt, labfam, Am, B, yl, acst, tb, ts, selas, pprice, avgLab, avFamLab, HrdPrice;




*   ---- crop area (ha) (only activities with gmar >0) household.comunne level-----
***Note !! --> If we take into account only activities with gmar > 0 subsistence farm types are ignored
*so we eliminate the condition under wich the statement is executed (i.e.
*x0(h,c,a,s)$(p_householdData(h,c,a,s,'gmar') gt 0)= p_householdData(h,c,a,s,'area');

*x0(h,c,a,s)= p_householdData(h,c,a,s,'area');
*x0(h,c,a,'tot')= x0(h,c,a,'dry')+ x0(h,c,a,'irr');
