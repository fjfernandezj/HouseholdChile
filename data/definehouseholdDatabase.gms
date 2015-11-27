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
*---- total production in  (t/h)

