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
avs(c,'nagr-g') = 1 - sum(j, avs(c,j)); 


display jcons, jprice, exinc, sb, Y_0, bdgtshr, avs;
$exit




*Farm household full income - Assuming that Agricultural revenue represent 55% of total income
**Sources:
* -INDAP -PUC (2013) ANALISIS DE LA VARIABLE INGRESO DE LAS EXPLOTACIONES DEL SEGMENTO PRODUCTOR VULNERABLE DE LA PEQUEÑA AGRICULTURA ATENDIDA POR INDAP
* -FAO 2009
Y_0(h,c) = [[sum((a,s), p_householdData(h,c,a,s,'srev'))] + exinc(h)] * (1/1000000);




*   ---- crop area (ha) (only activities with gmar >0) household.comunne level-----
***Note !! --> If we take into account only activities with gmar > 0 subsistence farm types are ignored
*so we eliminate the condition under wich the statement is executed (i.e.
*x0(h,c,a,s)$(p_householdData(h,c,a,s,'gmar') gt 0)= p_householdData(h,c,a,s,'area');

x0(h,c,a,s)= p_householdData(h,c,a,s,'area');
x0(h,c,a,'tot')= x0(h,c,a,'dry')+ x0(h,c,a,'irr');
