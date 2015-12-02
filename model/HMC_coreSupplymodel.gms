*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Householdmodel Maule Region Chile

   Name      :   household_core Supply Model.gms
   Purpose   :   Core model definition
   Author    :   F Fernández
   Date      :   30.09.15
   Since     :   September 2015
   CalledBy  :

   Notes     :   This file includes
                 + definition of main model equations
                 + definition of core supply model without consumption equations

$offtext
$onmulti ;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         CORE MODEL DEFINITION                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*---Variables declaration
Variables
U               Weigthed sum of representative farm households' expected income

;

Positive Variables
x
R               Farm household expected income
Z               Agricultural expected income
sldq            Sold quantities of goods - rented-out tradable factors
bght            Bought quantities of goods- rented-in tradable factors
*;

*---Equation declaration
Equation
eq_Obj                Objective function
eq_FarmHhinc          Farm household expected income

eq_AgrInc_LP          Agricultural Income with linear Costs
eq_AgrInc_NLP         Agricultural Income with PMP Cost parameters
eq_RscConst           Resource constraints at farm household level (land-labour-water-capital)
;

*---Equation definition
eq_Obj..                  U =e=sum((h,c), w(h,c)*R(h,c));

eq_FarmHhinc(h,c)..       R(h,c) =e= Z(h,c) + exinc(h);

eq_AgrInc_LP(h,c)..       Z(h,c) =e= sum((a,s)$map_hcas(h,c,a,s),[yld(h,c,a,s)*x(h,c,a,s)]*pprice(a))+ sb(h)
                          - sum((a,s)$map_hcas(h,c,a,s), acst(h,c,a,s)*x(h,c,a,s));

eq_AgrInc_nlp(h,c)..      Z(h,c) =e= sum((a,s)$map_hcas(h,c,a,s),[yld(h,c,a,s)*x(h,c,a,s)]*pprice(a)) + sb(h)
                          - sum((a,s)$map_hcas(h,c,a,s), ALPHACST(h,c,a,s)*x(h,c,a,s)**BETACST(h,c,a,s)) ;


eq_RscConst(h,c,f)..      sum((a,s)$map_hcas(h,c,a,s), Am(h,c,a,s,f)*x(h,c,a,s)) =l= B(h,c,f) + sldq(h,c,f) - bght(h,c,f);


*---Model definition
Model  household_supply model for the Maule region Chile /
eq_Obj
eq_FarmHhinc
eq_RscConst
/;