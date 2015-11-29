*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Basin Agricultural Model

   Name      :   defineHouseholdDatabase
   Purpose   :   define model database
   Author    :   F Fernández
   Date      :   29.09.15
   Since     :   September 2015
   CalledBy  :

   Notes     :   Import excel data into gdx
                 Build model database

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$onmulti
* Mode database to generate GDX files with base data
* Mode datacheck to check market balances and common data

$setglobal database on
$setglobal datacheck off

*-------------------------------------------------------------------------------
*
*   Common sets and parameters
*
*-------------------------------------------------------------------------------
set
   hou                'households'
   com                'communes'
   act                'activities'
   sys                'production system'
   jf                 'good and factors'
   fct                'factors'
   gds                'goods'
   var                'variables'             /land, yield, price, hrdlab, famlab, hrdLabPr, famLabPr, selas /
   eb                 'ME supports beta'       /e1*e11/
   eg                 'ME supports gamma'      /e1*e5/

;

parameter
   p_householdData   'crop management data Farm level'
   p_houGdsData      'Goods and Factors  Data'
   p_marketdata      'Elasticities data'


;

$if %database%==on $goto database
$if %datacheck%==on $goto datacheck

$label database
*-------------------------------------------------------------------------------
*
*   Import raw data (from XLS to GDX)
*
*-------------------------------------------------------------------------------
*   ---- auxiliary parameters

parameter
   t_householdData     'Household activities data'
   t_houGdsData        'Household goods and factors data'
   t_selasticities     'supply elasticities'
   t_cnsPrcs           'Consumer prices of agricultural goods'
   za(eb,gds)          'pre-support points for beta parameter of LES'
   zb(eg,gds)          'pre-support points for gamma parameter of LES'

;

*   ---- import sets (from xls to gdx)
$call "gdxxrw.exe ..\data\household_DB_SETS.xlsx o=..\data\sets\sets.gdx se=2 index=indexSet!A3"

$gdxin ..\data\sets\sets.gdx
$load  hou com act sys jf fct gds
$gdxin


*   ---- import data (from xls to gdx)
$call "gdxxrw.exe ..\data\activities\FinalDB_2910.xlsx o=..\data\activities\FinalDB_2910.gdx se=2 index=indexData!A3"
$call "gdxxrw.exe ..\data\supportpoints\supportpoints.xlsx o=..\data\supportpoints\supportpoints.gdx se=2 index=indexData!A3"
$call "gdxxrw.exe ..\data\markets\HousModel_supElast.xlsx o=..\data\markets\HousModel_supElast.gdx se=2 index=index!A3"
$call "gdxxrw.exe ..\data\markets\Consumer_prices.xlsx o=..\data\markets\Consumer_prices.gdx se=2 index=index!A3"


$gdxin ..\data\activities\FinalDB_2910.gdx
$load  t_householdData t_houGdsData
$gdxin

$gdxin ..\data\supportpoints\supportpoints.gdx
$load    za zb
$gdxin

$gdxin ..\data\markets\HousModel_supElast.gdx
$load  t_selasticities
$gdxin

$gdxin ..\data\markets\Consumer_prices.gdx
$load  t_cnsPrcs
$gdxin

*-------------------------------------------------------------------------------
*
*   Define model database
*
*-------------------------------------------------------------------------------
*---- total production in  (ton)
p_householdData(hou,com,act,sys,'area') = t_householdData(hou,com,act,sys,'Area');

*---Yield (ton/ha)
*- Raw Yield data does not used the same unit of measurement (e.g. kg, units and qq)
* -- Crops with yield in qqm/ha
p_householdData(hou,com,'mze',sys,'yld')$(p_householdData(hou,com,'mze',sys,'area'))= t_householdData(hou,com,'mze',sys,'Yield')*(1/10);
p_householdData(hou,com,'wht',sys,'yld')$(p_householdData(hou,com,'wht',sys,'area'))= t_householdData(hou,com,'wht',sys,'Yield')*(1/10);
p_householdData(hou,com,'mzes',sys,'yld')$(p_householdData(hou,com,'mzes',sys,'area'))= t_householdData(hou,com,'mzes',sys,'Yield')*(1/10);
p_householdData(hou,com,'snf',sys,'yld')$(p_householdData(hou,com,'snf',sys,'area'))= t_householdData(hou,com,'snf',sys,'Yield')*(1/10);
p_householdData(hou,com,'soy',sys,'yld')$(p_householdData(hou,com,'soy',sys,'area'))= t_householdData(hou,com,'soy',sys,'Yield')*(1/10);
p_householdData(hou,com,'tob',sys,'yld')$(p_householdData(hou,com,'tob',sys,'area'))= t_householdData(hou,com,'tob',sys,'Yield')*(1/10);
p_householdData(hou,com,'cmb',sys,'yld')$(p_householdData(hou,com,'cmb',sys,'area'))= t_householdData(hou,com,'cmb',sys,'Yield')*(1/10);
p_householdData(hou,com,'pot',sys,'yld')$(p_householdData(hou,com,'pot',sys,'area'))= t_householdData(hou,com,'pot',sys,'Yield')*(1/10);
p_householdData(hou,com,'chk',sys,'yld')$(p_householdData(hou,com,'chk',sys,'area'))= t_householdData(hou,com,'chk',sys,'Yield')*(1/10);
p_householdData(hou,com,'ric',sys,'yld')$(p_householdData(hou,com,'ric',sys,'area'))= t_householdData(hou,com,'ric',sys,'Yield')*(1/10);
p_householdData(hou,com,'gbn',sys,'yld')$(p_householdData(hou,com,'gbn',sys,'area'))= t_householdData(hou,com,'gbn',sys,'Yield')*(1/10);
p_householdData(hou,com,'oat',sys,'yld')$(p_householdData(hou,com,'oat',sys,'area'))= t_householdData(hou,com,'oat',sys,'Yield')*(1/10);
p_householdData(hou,com,'pea',sys,'yld')$(p_householdData(hou,com,'pea',sys,'area'))= t_householdData(hou,com,'pea',sys,'Yield')*(1/10);
p_householdData(hou,com,'len',sys,'yld')$(p_householdData(hou,com,'len',sys,'area'))= t_householdData(hou,com,'len',sys,'Yield')*(1/10);

* -- Crops with yield in kg/ha
p_householdData(hou,com,'cbg',sys,'yld')$(p_householdData(hou,com,'cbg',sys,'area'))= t_householdData(hou,com,'cbg',sys,'Yield')*(1/1000);
p_householdData(hou,com,'tom',sys,'yld')$(p_householdData(hou,com,'tom',sys,'area'))= t_householdData(hou,com,'tom',sys,'Yield')*(1/1000);
p_householdData(hou,com,'cucs',sys,'yld')$(p_householdData(hou,com,'cucs',sys,'area'))= t_householdData(hou,com,'cucs',sys,'Yield')*(1/1000);
p_householdData(hou,com,'mels',sys,'yld')$(p_householdData(hou,com,'mels',sys,'area'))= t_householdData(hou,com,'mels',sys,'Yield')*(1/1000);
p_householdData(hou,com,'cbgs',sys,'yld')$(p_householdData(hou,com,'cbgs',sys,'area'))= t_householdData(hou,com,'cbgs',sys,'Yield')*(1/1000);
p_householdData(hou,com,'wtms',sys,'yld')$(p_householdData(hou,com,'wtms',sys,'area'))= t_householdData(hou,com,'wtms',sys,'Yield')*(1/1000);
p_householdData(hou,com,'sgb',sys,'yld')$(p_householdData(hou,com,'sgb',sys,'area'))= t_householdData(hou,com,'sgb',sys,'Yield')*(1/1000);

* -- Crops with yield in un/ha
*We assume the following coefficients to transform for 1 unit to kg
p_householdData(hou,com,'mel',sys,'yld')$(p_householdData(hou,com,'mel',sys,'area'))= t_householdData(hou,com,'mel',sys,'Yield')*(0.4/1000);
p_householdData(hou,com,'wtm',sys,'yld')$(p_householdData(hou,com,'wtm',sys,'area'))= t_householdData(hou,com,'wtm',sys,'Yield')*(0.7/1000);
p_householdData(hou,com,'oni',sys,'yld')$(p_householdData(hou,com,'oni',sys,'area'))= t_householdData(hou,com,'oni',sys,'Yield')*(0.3/1000);
p_householdData(hou,com,'sqh',sys,'yld')$(p_householdData(hou,com,'sqh',sys,'area'))= t_householdData(hou,com,'sqh',sys,'Yield')*(1.2/1000);

p_householdData(hou,com,act,sys,'prd')  =
p_householdData(hou,com,act,sys,'yld')*p_householdData(hou,com,act,sys,'area');

p_householdData(hou,com,act,'tot','area') = p_householdData(hou,com,act,'irr','area') + p_householdData(hou,com,act,'dry','area');

p_householdData(hou,com,act,'tot','prd')= p_householdData(hou,com,act,'irr','prd')+ p_householdData(hou,com,act,'dry','prd');


p_householdData(hou,com,act,'tot','yld')$(p_householdData(hou,com,act,'tot','area'))=
p_householdData(hou,com,act,'tot','prd')/p_householdData(hou,com,act,'tot','area');


*-----------------Cost per hectare ($CLP/h) (CLP$ 2011)-----------------
*------------------Even if the household doesnt grown the crop---------

p_householdData(hou,com,act,'irr','vcost')= t_householdData(hou,com,act,'irr','TotalCosts');
p_householdData(hou,com,act,'dry','vcost')= t_householdData(hou,com,act,'dry','TotalCosts');

parameter t_rawprices 'producer price observed in the survey'  ;
*---- Producer Prices ($CLP/ton)
*- Raw Price data does not used the same unit of measurement (e.g. $CLP/kg, $CLP/units and $CLP/qqm)

* -- Crops with Price in $CLP/qqm
t_rawprices(hou,com,'mze',sys,'prc')$(p_householdData(hou,com,'mze',sys,'area'))= t_householdData(hou,com,'mze',sys,'CropPrice')*(10);
t_rawprices(hou,com,'wht',sys,'prc')$(p_householdData(hou,com,'wht',sys,'area'))= t_householdData(hou,com,'wht',sys,'CropPrice')*(10);
t_rawprices(hou,com,'mzes',sys,'prc')$(p_householdData(hou,com,'mzes',sys,'area'))= t_householdData(hou,com,'mzes',sys,'CropPrice')*(10);
t_rawprices(hou,com,'snf',sys,'prc')$(p_householdData(hou,com,'snf',sys,'area'))= t_householdData(hou,com,'snf',sys,'CropPrice')*(10);
t_rawprices(hou,com,'soy',sys,'prc')$(p_householdData(hou,com,'soy',sys,'area'))= t_householdData(hou,com,'soy',sys,'CropPrice')*(10);
t_rawprices(hou,com,'tob',sys,'prc')$(p_householdData(hou,com,'tob',sys,'area'))= t_householdData(hou,com,'tob',sys,'CropPrice')*(10);
t_rawprices(hou,com,'cmb',sys,'prc')$(p_householdData(hou,com,'cmb',sys,'area'))= t_householdData(hou,com,'cmb',sys,'CropPrice')*(10);
t_rawprices(hou,com,'pot',sys,'prc')$(p_householdData(hou,com,'pot',sys,'area'))= t_householdData(hou,com,'pot',sys,'CropPrice')*(10);
t_rawprices(hou,com,'chk',sys,'prc')$(p_householdData(hou,com,'chk',sys,'area'))= t_householdData(hou,com,'chk',sys,'CropPrice')*(10);
t_rawprices(hou,com,'ric',sys,'prc')$(p_householdData(hou,com,'ric',sys,'area'))= t_householdData(hou,com,'ric',sys,'CropPrice')*(10);
t_rawprices(hou,com,'gbn',sys,'prc')$(p_householdData(hou,com,'gbn',sys,'area'))= t_householdData(hou,com,'gbn',sys,'CropPrice')*(10);
t_rawprices(hou,com,'oat',sys,'prc')$(p_householdData(hou,com,'oat',sys,'area'))= t_householdData(hou,com,'oat',sys,'CropPrice')*(10);
t_rawprices(hou,com,'pea',sys,'prc')$(p_householdData(hou,com,'pea',sys,'area'))= t_householdData(hou,com,'pea',sys,'CropPrice')*(10);
t_rawprices(hou,com,'len',sys,'prc')$(p_householdData(hou,com,'len',sys,'area'))= t_householdData(hou,com,'len',sys,'CropPrice')*(10);

* -- Crops with price in $CLP/kg
t_rawprices(hou,com,'cbg',sys,'prc')$(p_householdData(hou,com,'cbg',sys,'area'))= t_householdData(hou,com,'cbg',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'tom',sys,'prc')$(p_householdData(hou,com,'tom',sys,'area'))= t_householdData(hou,com,'tom',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'cucs',sys,'prc')$(p_householdData(hou,com,'cucs',sys,'area'))= t_householdData(hou,com,'cucs',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'mels',sys,'prc')$(p_householdData(hou,com,'mels',sys,'area'))= t_householdData(hou,com,'mels',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'cbgs',sys,'prc')$(p_householdData(hou,com,'cbgs',sys,'area'))= t_householdData(hou,com,'cbgs',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'wtms',sys,'prc')$(p_householdData(hou,com,'wtms',sys,'area'))= t_householdData(hou,com,'wtms',sys,'CropPrice')*(1000);
t_rawprices(hou,com,'sgb',sys,'prc')$(p_householdData(hou,com,'sgb',sys,'area'))= t_householdData(hou,com,'sgb',sys,'CropPrice')*(1000);

* -- Crops with price in $CLP/un
t_rawprices(hou,com,'mel',sys,'prc')$(p_householdData(hou,com,'mel',sys,'area'))= t_householdData(hou,com,'mel',sys,'CropPrice')*(2500) ;
t_rawprices(hou,com,'wtm',sys,'prc')$(p_householdData(hou,com,'wtm',sys,'area'))= t_householdData(hou,com,'wtm',sys,'CropPrice')*(1430) ;
t_rawprices(hou,com,'oni',sys,'prc')$(p_householdData(hou,com,'oni',sys,'area'))= t_householdData(hou,com,'oni',sys,'CropPrice')*(3333);
t_rawprices(hou,com,'sqh',sys,'prc')$(p_householdData(hou,com,'sqh',sys,'area'))= t_householdData(hou,com,'sqh',sys,'CropPrice')*(833);


*-----------------Revenue ($CLP/h) ($CLP 2011)------------------
p_householdData(hou,com,act,'irr','srev')$p_householdData(hou,com,act,'irr','yld')= t_rawprices(hou,com,act,'irr','prc')*p_householdData(hou,com,act,'irr','yld');
p_householdData(hou,com,act,'dry','srev')$p_householdData(hou,com,act,'dry','yld')= t_rawprices(hou,com,act,'dry','prc')*p_householdData(hou,com,act,'dry','yld');


*----------------Gross Margin ($CLP/h) ($CLP 2011)----------------
*------Household---
p_householdData(hou,com,act,sys,'gmar')$p_householdData(hou,com,act,sys,'yld')
                                                                         = p_householdData(hou,com,act,sys,'srev') - p_householdData(hou,com,act,sys,'vcost')    ;


*---- Consumption (ton)
*- Raw Consumption data does not used the same unit of measurement (e.g. kg, units and qq)
* -- Crops with Consumption in qqm
p_householdData(hou,com,'mze',sys,'cons')$(p_householdData(hou,com,'mze',sys,'area'))= t_householdData(hou,com,'mze',sys,'Consumption')*(1/10);
p_householdData(hou,com,'wht',sys,'cons')$(p_householdData(hou,com,'wht',sys,'area'))= t_householdData(hou,com,'wht',sys,'Consumption')*(1/10);
p_householdData(hou,com,'mzes',sys,'cons')$(p_householdData(hou,com,'mzes',sys,'area'))= t_householdData(hou,com,'mzes',sys,'Consumption')*(1/10);
p_householdData(hou,com,'snf',sys,'cons')$(p_householdData(hou,com,'snf',sys,'area'))= t_householdData(hou,com,'snf',sys,'Consumption')*(1/10);
p_householdData(hou,com,'soy',sys,'cons')$(p_householdData(hou,com,'soy',sys,'area'))= t_householdData(hou,com,'soy',sys,'Consumption')*(1/10);
p_householdData(hou,com,'tob',sys,'cons')$(p_householdData(hou,com,'tob',sys,'area'))= t_householdData(hou,com,'tob',sys,'Consumption')*(1/10);
p_householdData(hou,com,'cmb',sys,'cons')$(p_householdData(hou,com,'cmb',sys,'area'))= t_householdData(hou,com,'cmb',sys,'Consumption')*(1/10);
p_householdData(hou,com,'pot',sys,'cons')$(p_householdData(hou,com,'pot',sys,'area'))= t_householdData(hou,com,'pot',sys,'Consumption')*(1/10);
p_householdData(hou,com,'chk',sys,'cons')$(p_householdData(hou,com,'chk',sys,'area'))= t_householdData(hou,com,'chk',sys,'Consumption')*(1/10);
p_householdData(hou,com,'ric',sys,'cons')$(p_householdData(hou,com,'ric',sys,'area'))= t_householdData(hou,com,'ric',sys,'Consumption')*(1/10);
p_householdData(hou,com,'gbn',sys,'cons')$(p_householdData(hou,com,'gbn',sys,'area'))= t_householdData(hou,com,'gbn',sys,'Consumption')*(1/10);
p_householdData(hou,com,'oat',sys,'cons')$(p_householdData(hou,com,'oat',sys,'area'))= t_householdData(hou,com,'oat',sys,'Consumption')*(1/10);
p_householdData(hou,com,'pea',sys,'cons')$(p_householdData(hou,com,'pea',sys,'area'))= t_householdData(hou,com,'pea',sys,'Consumption')*(1/10);
p_householdData(hou,com,'len',sys,'cons')$(p_householdData(hou,com,'len',sys,'area'))= t_householdData(hou,com,'len',sys,'Consumption')*(1/10);

* -- Crops with Consumption in kg
p_householdData(hou,com,'cbg',sys,'cons')$(p_householdData(hou,com,'cbg',sys,'area'))= t_householdData(hou,com,'cbg',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'tom',sys,'cons')$(p_householdData(hou,com,'tom',sys,'area'))= t_householdData(hou,com,'tom',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'cucs',sys,'cons')$(p_householdData(hou,com,'cucs',sys,'area'))= t_householdData(hou,com,'cucs',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'mels',sys,'cons')$(p_householdData(hou,com,'mels',sys,'area'))= t_householdData(hou,com,'mels',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'cbgs',sys,'cons')$(p_householdData(hou,com,'cbgs',sys,'area'))= t_householdData(hou,com,'cbgs',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'wtms',sys,'cons')$(p_householdData(hou,com,'wtms',sys,'area'))= t_householdData(hou,com,'wtms',sys,'Consumption')*(1/1000);
p_householdData(hou,com,'sgb',sys,'cons')$(p_householdData(hou,com,'sgb',sys,'area'))= t_householdData(hou,com,'sgb',sys,'Consumption')*(1/1000);

* -- Crops with Consumption in un/ha
*We assume the following coefficients to transform for 1 unit to kg
p_householdData(hou,com,'mel',sys,'cons')$(p_householdData(hou,com,'mel',sys,'area'))= t_householdData(hou,com,'mel',sys,'Consumption')*(0.4/1000);
p_householdData(hou,com,'wtm',sys,'cons')$(p_householdData(hou,com,'wtm',sys,'area'))= t_householdData(hou,com,'wtm',sys,'Consumption')*(0.7/1000);
p_householdData(hou,com,'oni',sys,'cons')$(p_householdData(hou,com,'oni',sys,'area'))= t_householdData(hou,com,'oni',sys,'Consumption')*(0.3/1000);
p_householdData(hou,com,'sqh',sys,'cons')$(p_householdData(hou,com,'sqh',sys,'area'))= t_householdData(hou,com,'sqh',sys,'Consumption')*(1.2/1000);


option DECIMALS=1;
display  p_householdData;
$exit

