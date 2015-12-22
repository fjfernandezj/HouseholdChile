*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Householdmodel Maule Region Chile

   Name      :   household_coreModel_noRisk.gms
   Purpose   :   Core model definition
   Author    :   F Fernández
   Date      :   30.09.15
   Since     :   September 2015
   CalledBy  :

   Notes     :   This file includes
                 + definition of main model equations
                 + definition of core model
$offtext
$onmulti ;
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         CORE MODEL DEFINITION                                *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*---Variables declaration
Variables
U               Weigthed sum of representative farm households' expected income
R               Farm household expected income
*INCF            Farm household full income
Z               Agricultural expected income
x               Agricultural activity levels (ha)
prdq            Produced quantities of goods
sldq            Sold quantities of goods - rented-out tradable factors
bght            Bought quantities of goods- rented-in tradable factors
cnsq            consumed quantities of goods
cs              Self-consumed quantities of goods
prcg            Prices of goods and tradable factors faced by households
IM               Imported quantities of goods and tradable factors
EX               Exported quantities of goods and tradable factors
;

Positive Variables
x
prdq
sldq
bght
cnsq
cs
prcg
IM
EX
HLAB            Hired Labour (working days)
;

*---Equation declaration
Equation
eq_Obj                Objective function
eq_FarmHhinc          Farm household expected income
*eq_FarmHhfullinc      Farm household full income
eq_AgrInc_LP          Agricultural Income with linear Costs
eq_AgrInc_NLP         Agricultural Income with PMP Cost parameters
eq_tLAND              Land constraint
eq_TotLab             Labour constraint
eq_Qttyblnce          Quantity balance for goods at farm household level
eq_prdGds             Produced goods at farm household level
eq_prdGds2            Produced goods constraint
eq_prcbnd1            Price band 1
eq_prcbnd2            Price band 2
eq_slknss1            Complementary slackness condition 1
eq_slknss2            Complementary slackness condition 2
eq_buyorsell          Households buy or sell goods not both
eq_cshcnstrnt_LP      Cash constraint Linear
eq_cshcnstrnt_NLP     Cash constraint PMP lambda parameter
*eq_expfunct           Farm household expenditure function
eq_qttbalgood         Quantity balance of goods at aggregated level (commune)
eq_qttbaltrf          Quantity balance of tradable factors at aggregated level (commune)


;

*---Equation definition
eq_Obj..                  U =e=sum((h,c), w(h,c)*R(h,c));

*eq_FarmHhinc(h,c)..       R(h,c) =e= Z(h,c) + exinc(h);

eq_FarmHhinc(h,c)..       R(h,c) =e= Z(h,c) -sum(j, bght(h,c,j)*prcg(h,c,j))+ exinc(h) ;

*eq_FarmHhfullinc(h,c)..   INCF(h,c) =e= R(h,c) + sum(tf, B(h,c,'land')*bght(h,c,'land'));

*eq_AgrInc_LP(h,c)..       Z(h,c) =e= sum((a,s)$map_hcas(h,c,a,s),[yld(h,c,a,s)*x(h,c,a,s)]*pprice(a))+ sb(h)
*                          - sum((a,s)$map_hcas(h,c,a,s), acst(h,c,a,s)*x(h,c,a,s)) ;


eq_AgrInc_LP(h,c)..       Z(h,c) =e= sum(j, [sldq(h,c,j)+ cs(h,c,j)]*prcg(h,c,j)) + sb(h)
                          - sum((a,s)$map_hcas(h,c,a,s), acst(h,c,a,s)*x(h,c,a,s))- LabWage*HLAB(h,c);

********************************************Original FSSIM Agricultural Income eq**********************************************************
*eq_AgrInc_nlp(h,c)..      Z(h,c) =e= sum(j, [sldq(h,c,j)+ cs(h,c,j)]*prcg(h,c,j)) + sb(h)
*                          - sum((a,s), acst(h,c,a,s)*x(h,c,a,s)) - sum((a,aa,s), [d(h,c,a,s) + 0.5*Q(a,aa)*x(h,c,a,s)]*x(h,c,a,s))
*                          - sum(tf, [bght(h,c,tf)+lambda(h,c,tf)]*prcg(h,c,tf)) ;
**************************************************************************************************************************************

*eq_AgrInc_nlp(h,c)..      Z(h,c) =e= sum((a,s)$map_hcas(h,c,a,s),[yld(h,c,a,s)*x(h,c,a,s)]*pprice(a)) + sb(h)
*                          - sum((a,s)$map_hcas(h,c,a,s), ALPHACST(h,c,a,s)*x(h,c,a,s)**BETACST(h,c,a,s)) ;

eq_AgrInc_nlp(h,c)..      Z(h,c) =e= sum(j, [sldq(h,c,j)+ cs(h,c,j)]*prcg(h,c,j)) + sb(h)
                          - sum((a,s)$map_hcas(h,c,a,s), ALPHACST(h,c,a,s)*x(h,c,a,s)**BETACST(h,c,a,s))- LabWage*HLAB(h,c) ;


*eq_RscConst(h,c,f)..      sum((a,s)$map_hcas(h,c,a,s), Am(h,c,a,s,f)*x(h,c,a,s)) =l= B(h,c,f) + sldq(h,c,f) - bght(h,c,f);


eq_tLAND(c)..             sum((h,a,s)$map_hcas(h,c,a,s), X(h,c,a,s)) =L= tcland(c);

eq_TotLab(c)..            sum((h,a,s)$map_hcas(h,c,a,s), labreq(h,c,a,s)* X(h,c,a,s))=l= sum(h, avFamLab(h) + HLAB(h,c));


eq_Qttyblnce(h,c,j)..     prdq(h,c,j)+ bght(h,c,j) =e= sldq(h,c,j) + cnsq(h,c,j);

eq_prdGds(h,c,j)..        prdq(h,c,j) =e= sum((a,s)$map_hcas(h,c,a,s), yl(h,c,a,s,j)*x(h,c,a,s));


eq_prdGds2(h,c,j)..       sum((a,s)$map_hcas(h,c,a,s), yl(h,c,a,s,j)*x(h,c,a,s)) =e= sldq(h,c,j) + cs(h,c,j)    ;


eq_prcbnd1(h,c,j)..       prcg(h,c,j) =l= jprice(j)*tb(h,c,j);

eq_prcbnd2(h,c,j)..       jprice(j)*ts(h,c,j) =l= prcg(h,c,j);

eq_slknss1(h,c,j)..       sldq(h,c,j)*(prcg(h,c,j)-[jprice(j)*ts(h,c,j)]) =e= 0;

eq_slknss2(h,c,j)..       bght(h,c,j)*(prcg(h,c,j)-[jprice(j)*tb(h,c,j)]) =e= 0;

eq_buyorsell(h,c,j)..     sldq(h,c,j)*bght(h,c,j) =e= 0;

eq_cshcnstrnt_LP(h,c)..      sum(j, sldq(h,c,j)*prcg(h,c,j)) + sb(h)+ exinc(h)
                         =g= sum(j, bght(h,c,j)*prcg(h,c,j)) + sum((a,s)$map_hcas(h,c,a,s), acst(h,c,a,s)*x(h,c,a,s)) + LabWage*HLAB(h,c) ;


********************************************Original FSSIM Cash Const eq**********************************************************
*eq_cshcnstrnt_NLP(h,c)..      sum(j, sldq(h,c,j)*prcg(h,c,j)) + sum(tf, sldq(h,c,tf)*prcg(h,c,tf)) + sb(h)
*                          + exinc(h) =g= sum(j, bght(h,c,j)*prcg(h,c,j)) + sum(tf, [bght(h,c,tf)+lambda(h,c,tf)]*prcg(h,c,tf))
*                          + sum((a,s), acst(h,c,a,s)*x(h,c,a,s)) ;
********************************************************************************************************************************

eq_cshcnstrnt_NLP(h,c)..      sum(j, sldq(h,c,j)*prcg(h,c,j))+ sb(h) + exinc(h)
                         =g= sum(j, bght(h,c,j)*prcg(h,c,j)) + sum((a,s)$map_hcas(h,c,a,s), ALPHACST(h,c,a,s)*x(h,c,a,s)**BETACST(h,c,a,s)) + LabWage*HLAB(h,c) ;



*eq_expfunct(h,c,j)..      cnsq(h,c,j)*prcg(h,c,j) =e= beta(h,c,j)*[R(h,c)- sum(jj, gamma(h,c,jj)*prcg(h,c,jj))]+ gamma(h,c,j)*prcg(h,c,j);


eq_qttbalgood(j)..        sum((h,c), w(h,c)*sldq(h,c,j)+IM(j)) =e= sum((h,c), w(h,c)*b(h,c,j)+EX(j));


*eq_qttbaltrf(tf)..        sum((h,c), w(h,c)*sldq(h,c,tf)+IM(tf)) =e= sum((h,c), w(h,c)*b(h,c,tf)+EX(tf));

*---Model definition
Model  household_noRisk model for the Maule region Chile /
eq_Obj
eq_FarmHhinc
*eq_FarmHhfullinc
eq_tLAND
eq_TotLab
eq_Qttyblnce
eq_prdGds
eq_prdGds2
eq_prcbnd1
eq_prcbnd2
eq_slknss1
eq_slknss2
eq_buyorsell
*eq_expfunct
eq_qttbalgood
*eq_qttbaltrf

/;

********************************Solve statement*****************************

*Solve household_noRisk using nlp maximizing U;
