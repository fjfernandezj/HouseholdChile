*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Household model Chile

   Name      :   sets_householdChile.gms
   Purpose   :   general sets and mappings
   Author    :   F Fern�ndez
   Date      :   30.09.15
   Since     :   September 2015
   CalledBy  :

   Notes     :

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$onmulti

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*  COMMON SETS AND MAPPINGS                                                    *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
Sets
hou     Farm households
/ H1 Household-type 1
  H2 Household-type 2
  H3 Household-type 3
  H4 Household-type 4
  H5 Household-type 5 /

com     Communes
/ PEN Pencahue
  SC  San Clemente
  CAU Cauquenes
  PAR Parral /

act    Household Activities
/mze  Maize
 mzes Maize for seed
 cmb  Common Bean
 gbn  Green Bean
 pot  Potatoes
 wht  Wheat
 oat  Oat
 pea  Peas
 oni  Onions
 tom  Tomato
 mel  Melon
 mels Melon for seed
 wtm  Water Melon
 wtms water melon for seed
 cuc  Cucumber
 cucs Cucumber for seed
 sqh  Squash
 snf  Sunflower
 soy  Soya
 tob  Tobacco
 cbg  Cabbage
 cbgs Cabbagge for seed
 chk  Chikpea
 ric  Rice
 sgb  Sugar beet/

sys   System
/irr irrigated
 dry rainfed /

agds  Agricultural Goods
/mze  Maize
 mzes Maize for seed
 cmb  Common Bean
 gbn  Green Bean
 pot  Potatoes
 wht  Wheat
 oat  Oat
 pea  Peas
 oni  Onions
 tom  Tomato
 mel  Melon
 mels Melon for seed
 wtm  Water Melon
 wtms water melon for seed
 cuc  Cucumber
 cucs Cucumber for seed
 sqh  Squash
 snf  Sunflower
 soy  Soya
 tob  Tobacco
 cbg  Cabbage
 cbgs Cabbagge for seed
 chk  Chikpea
 ric  Rice
 sgb  Sugar beet    /

m non agricultural goods (market goods)
/nagr-g Non-agricultural goods /

fct   Factors
/lnd Land
 lab Labour
 wat Water
 cap Capital/


eb  ME supports beta LES       /e1*e11/
eg  ME supports gamma LES      /e1*e5/
ee  ME supports mhu LES        /e1*e3/


;





*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* Define aggregates
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set
  jf  Goods and Factors     /set.agds, set.m, set.fct/
  gds Goods                 /set.agds, set.m/

set
var       'variables'             /Area,yld,prd,cons,prc,hrd_lab,fam_lab,TtlLab_Cst,
                                  inpCst,RntCst,TtlCst,srev,gmar,consPrice,gdsCons,
                                  tot_lab,vcost,selast,prd_prc,HLab_Price,FLab_Price/

;

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*  SETS DEFINITION                                                             *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$GDXIN ..\data\sets\sets.gdx
$LOAD hou com fct act sys gds jf fct
$GDXIN


*   ---- subsets
set
   h(hou)   'households and household aggregates'
   c(com)   'communes and regional aggregates'
   s(sys)   'production system'     /dry,irr/
   f(fct)   'factors'

*---subsets of agricultural products
grn(act) grains
/wht,oat/
*/wht,oat,ric/

sc(act) spring crops
/mze,cmb,pot/
*gbn and chk no supply elasticities --> original /mze,cmb, gbn, chk, pot/

sv(act) sprig vegetables
/oni,tom,mel,wtm /
* /pea,oni,tom,mel,wtm,cuc,sqh /

oc(act) other crops
/snf,tob,cbg,sgb,soy /

sdp(act) seed production
/mzes, cbgs, cucs, mels,wtms /

a(act)     'activities to be modeled'

*---factor subsets
tf(fct)    Tradable factors
/lnd,lab,cap/

*---subsets of Goods
grnj(gds) grains
/wht,oat/
*/wht,oat,ric/

scj(gds) spring crops
/mze,cmb,pot/
*gbn and chk no supply elasticities --> original /mze,cmb, gbn, chk, pot/

svj(gds) sprig vegetables
/oni,tom,mel,wtm/
*/pea,oni,tom,mel,wtm,cuc,sqh /

ocj(gds) other crops
/snf,tob,cbg,sgb,soy /

sdpj(gds) seed production
/mzes, cbgs, cucs, mels,wtms /

nagr(gds) non agricultural goods
/nagr-g/

j(gds) 'goods to be modeled'
;

h(hou)=yes;
c(com)=yes;
s(sys)=yes;
j(gds)=yes;
f(fct)=yes;
a(act)= grn(act)+ sc(act)+sv(act)   ;
j(gds)= grnj(gds)+ scj(gds)+ svj(gds) + nagr(gds) ;
;

Alias
(j,jj)
(a,aa)

;

set aj(act,gds) mapping activities-goods
/mze.mze
 cmb.cmb
 gbn.gbn
 pot.pot
 wht.wht
 oat.oat
 pea.pea
 oni.oni
 tom.tom
 mel.mel
 wtm.wtm
 cuc.cuc
 sqh.sqh
 snf.snf
 soy.soy
 tob.tob
 cbg.cbg
 chk.chk
 ric.ric
 sgb.sgb
/
;

*   ---- current activities
set
  map_hcas   'mapping household-communes-activities-systems'
  map_has    'mapping household-activities-systems'
  map_hcj    'mapping household-communes-goods'
  map_hj     'mapping household-goods'

;
display c,h,a,aa,s,jf,j,jj,f,tf,m,aj ;
