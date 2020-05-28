* Encoding: UTF-8.

DATASET ACTIVATE DataSet2.
MIXED pain WITH age STAI_trait pain_cat cortisol_serum mindfulness female
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female | SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT age STAI_trait pain_cat cortisol_serum mindfulness female | SUBJECT(ID) 
    COVTYPE(UN).

MIXED pain WITH age STAI_trait pain_cat cortisol_serum mindfulness female
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=| SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT age STAI_trait pain_cat cortisol_serum mindfulness female | SUBJECT(ID) 
    COVTYPE(UN)
  /SAVE=PRED RESID.

COMPUTE RES_eq2=3.502 - (0.298 * female) - (0.055 * age) + (0.001 * STAI_trait) + (0.037 * pain_cat
    )+ (0.61 * cortisol_serum) - (0.262 * mindfulness).
EXECUTE.
DESCRIPTIVES VARIABLES=RES_eq RES_eq2
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

DESCRIPTIVES VARIABLES=RES_eq RES_eq2 pain
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

COMPUTE TSS=pain - 5.2.
EXECUTE.
COMPUTE TSS2=TSS * TSS.
EXECUTE.
DESCRIPTIVES VARIABLES=RES_eq RES_eq2 pain TSS2
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

COMPUTE RSS=pain - RES_eq.
EXECUTE.
COMPUTE RSS1=RSS * RSS.
EXECUTE.
DESCRIPTIVES VARIABLES=TSS2 RSS1
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

COMPUTE predicted_value=3.502 - (0.298 * female) - (0.055 * age) + (0.001 * STAI_trait) + (0.037 *
    pain_cat) + (0.61 * cortisol_serum) - (0.262 * mindfulness).
EXECUTE.
COMPUTE res_value=(pain - predicted_value) * (pain - predicted_value).
EXECUTE.
DESCRIPTIVES VARIABLES=res_value
  /STATISTICS=MEAN SUM STDDEV MIN MAX.







