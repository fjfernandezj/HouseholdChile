*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$ontext
   Household model Chile, Maule region

   Name      :   household_GME_LESparameters.gms
   Purpose   :   Estimate gamma and beta parameters for LES
   Author    :   F Fernández
   Date      :   02.10.15
   Since     :   September 2015
   CalledBy  :   .......

   Notes     :

$offtext
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~**
$onmulti
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
*                         INCLUDE SETS AND BASE DATA                           *
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
$include basedata\load_basedataHMC.gms
;

*###############################################################################
*                    GENERAL MAXIMUM ENTROPY PROBLEM                           -
*###############################################################################
*---Variables declaration
Positive variables
prob_B           Probability for beta parameter (marginal budget share)
prob_G           Probability for gamma parameter (uncompresibble consumption)
prob_E           Probability for error
beta_v           beta parameter
gamma_v          gamma parameter


Free variables
ENTRPY           The entropy measure to be maximized
mhu_v            error term

;
*-------------------------------------------------------------------------------
EQUATIONS
eq_Entropy        The objective function - maximizing Entropy
eq_expfunct       linear expenditure system equation plus an error term
eq_beta           beta equation
eq_gamma          gamma equation
eq_mhu            mhu equation
eq_probB          Summing probabilities to 1 - beta
eq_probG          Summing probabilities to 1 - gamma
eq_probE          Summing probabilities to 1 - mhu
eq_betaAccnst     Accounting restriction for beta
eq_gammaAccnst    Accounting restriction for gamma
eq_mhuAccnst      Accounting restriction for mhu
eq_nonAgr         Accounting restriction for non-agricultural goods

;
*-------------------------------------------------------------------------------
**Objective function
eq_Entropy..      ENTRPY =E= -SUM((h,c,j,eb), prob_B(h,c,j,eb)*log(prob_B(h,c,j,eb)))
                      -SUM((h,c,j,eg), prob_G(h,c,j,eg)*log(prob_G(h,c,j,eg)))
                      -SUM((h,c,j,ee), prob_E(h,c,j,ee)*log(prob_E(h,c,j,ee)));


**Data consistency constraints
eq_expfunct(h,c,j)..   jcons(h,c,j)*jprice(j) =e= beta_v(h,c,j)*[(Y_0(h,c)- sum(jj, gamma_v(h,c,j)*jprice(j)))]
                                  + gamma_v(h,c,j)*jprice(j) + mhu_v(h,c,j);


eq_beta(h,c,j)..       beta_v(h,c,j)  =e= sum(eb, prob_B(h,c,j,eb)*Z1(eb,c,j))    ;


eq_gamma(h,c,j)..      gamma_v(h,c,j) =e= sum(eg, prob_G(h,c,j,eg)*Z2(eg,c,j))   ;


eq_mhu(h,c,j)..        mhu_v(h,c,j)   =e= sum(ee, prob_E(h,c,j,ee)*Z3(h,c,ee,j))   ;                            ;


** Adding-up or Normalization constraints
eq_probB(h,c,j).. SUM(eb, prob_B(h,c,j,eb)) =E= 1 ;
eq_probG(h,c,j).. SUM(eg, prob_G(h,c,j,eg)) =E= 1 ;
eq_probE(h,c,j).. SUM(ee, prob_E(h,c,j,ee)) =E= 1 ;

**Accounting restrictions

eq_betaAccnst(h,c)..  sum(j, beta_v(h,c,j)) =e= 1 ;
eq_gammaAccnst(h,c,j).. gamma_v(h,c,j) =l= jcons(h,c,j)    ;
eq_mhuAccnst(h,c)..   sum(j, mhu_v(h,c,j)) =e= 0  ;

* Accounting restriction (market goods)
eq_nonAgr(h,c,m)..   consval(h,c,'nagr-g') =e= Y_0(h,c) - sum(agds, gamma_v(h,c,agds)*jprice(agds));

*   SOLVING THE MODEL
*-------------------------------- Defining the model ------------------------------
MODEL household_GME_LES OPTIMIZATION
/eq_Entropy
 eq_expfunct
eq_beta
eq_gamma
eq_mhu
eq_probB
eq_probG
eq_probE
eq_betaAccnst
eq_gammaAccnst
eq_mhuAccnst
eq_nonAgr
/ ;
*--------------------- Initial values of variables and bounds ---------------------
prob_B.lo(h,c,j,eb) = 0.001 ;
prob_G.lo(h,c,j,eg) = 0.001;
prob_E.lo(h,c,j,ee)= 0.001;

*household_GME_LES.tolinfeas = 1e-3;
*
*
*--------------------------------- Solving the model ------------------------------

OPTION NLP = CONOPT3 ;

household_GME_LES.scaleopt=1;
eq_expfunct.scale(h,c,j) = 100000 ;
beta_v.scale(h,c,j) = 100000 ;
eq_beta.scale(h,c,j)= 100000 ;
gamma_v.scale(h,c,j)= 100000 ;
eq_gamma.scale(h,c,j)= 100000 ;


SOLVE household_GME_LES using NLP maximizing ENTRPY    ;
*----------------------------------------------------------------------------------

parameter lespar;

lespar(h,c,j,'beta')= beta_v.l(h,c,j);
lespar(h,c,j,'gamma')= gamma_v.l(h,c,j);

display lespar;

*   ---- create gdx file with LES parameter data

execute_unload 'basedata\lespar.gdx' lespar ;






