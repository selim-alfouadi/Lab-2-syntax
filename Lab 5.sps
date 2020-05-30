* Encoding: UTF-8.
GET
  FILE='C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\lab_5_assignment_dataset (3).sav'.
DATASET NAME DataSet1 WINDOW=FRONT.
DATASET ACTIVATE DataSet1.
RECODE sex ('male'=0) ('female'=1) INTO female.
EXECUTE.
DATASET ACTIVATE DataSet1.

SAVE OUTFILE=
    'C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\'+
    'lab_5_assignment_dataset (3).sav'
  /COMPRESSED.
VARSTOCASES
  /MAKE pain_long FROM pain1 pain2 pain3 pain4
  /INDEX=time(4)
  /KEEP=ID sex age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness weight IQ household_income female
  /NULL=KEEP.

MIXED pain_long WITH age STAI_trait pain_cat cortisol_serum mindfulness female time
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female time | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(ID) COVTYPE(VC)
  /SAVE=PRED.

SAVE OUTFILE=
    'C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\'+
    'lab_5_assignment_dataset the new one before revert.sav'
  /COMPRESSED.
VARSTOCASES
  /MAKE pain_long_pred FROM pain_long PRED_INT PRED_slope
  /INDEX=data_type(pain_long_pred)
  /KEEP=ID sex age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness weight IQ household_income female time
  /NULL=KEEP.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time pain_long_pred data_type MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: pain_long_pred=col(source(s), name("pain_long_pred"), unit.category())
  DATA: data_type=col(source(s), name("data_type"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("pain_long_pred"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("data_type"))
  GUIDE: text.title(label("Multiple Line of pain_long_pred by time by data_type"))
  ELEMENT: line(position(time*pain_long_pred), color.interior(data_type), missing.wings())
END GPL.

SPLIT FILE OFF.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time pain_long_pred data_type MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: pain_long_pred=col(source(s), name("pain_long_pred"), unit.category())
  DATA: data_type=col(source(s), name("data_type"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("pain_long_pred"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("data_type"))
  GUIDE: text.title(label("Multiple Line of pain_long_pred by time by data_type"))
  ELEMENT: line(position(time*pain_long_pred), color.interior(data_type), missing.wings())
END GPL.

DATASET CLOSE DataSet1.
GET
  FILE='C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\lab_5_assignment_dataset the new one before revert.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.
COMPUTE center_time=time - 2.50.
EXECUTE.
COMPUTE center_time_sq=center_time * center_time.
EXECUTE.
DATASET ACTIVATE DataSet2.
MIXED pain_long WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED.

DATASET ACTIVATE DataSet2.

SAVE OUTFILE=
    'C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\'+
    'lab_5_assignment_dataset the new one before revert.sav'
  /COMPRESSED.
VARSTOCASES
  /MAKE Pain_long_new FROM pain_long PRED_slope pred_slope_sqtime
  /INDEX=data_file(Pain_long_new)
  /KEEP=ID sex age STAI_trait pain_cat cortisol_serum cortisol_saliva mindfulness weight IQ household_income female time PRED_INT center_time center_time_sq
  /NULL=KEEP.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time Pain_long_new data_file MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time Pain_long_new[LEVEL=SCALE] data_file
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: Pain_long_new=col(source(s), name("Pain_long_new"))
  DATA: data_file=col(source(s), name("data_file"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("Pain_long_new"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("data_file"))
  GUIDE: text.title(label("Multiple Line of Pain_long_new by time by data_file"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(time*Pain_long_new), color.interior(data_file), missing.wings())
END GPL.

SPLIT FILE OFF.
DATASET ACTIVATE DataSet2.

SAVE OUTFILE=
    'C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\'+
    'lab_5_assignment_dataset the new one before revert.sav'
  /COMPRESSED.
GET
  FILE='C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\lab_5_assignment_dataset the new one before revert.sav'.

>Warning # 67.  Command name: GET FILE
>The document is already in use by another user or process.  If you make
>changes to the document they may overwrite changes made by others or your
>changes may be overwritten by others.
>File opened C:\Users\Dator\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\TempState\Downloads\lab_5_assignment_datase
DATASET NAME DataSet3 WINDOW=FRONT.
DATASET ACTIVATE DataSet2.
DATASET CLOSE DataSet3.
MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID)
  /SAVE=PRED RESID.

EXAMINE VARIABLES=RESID_1
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time MEAN(Pain_long_new)[name="MEAN_Pain_long_new"
    LEVEL=SCALE] ID MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: MEAN_Pain_long_new=col(source(s), name("MEAN_Pain_long_new"))
  DATA: ID=col(source(s), name("ID"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("Mean Pain_long_new"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("ID"))
  GUIDE: text.title(label("Multiple Line Mean of Pain_long_new by time by ID"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(time*MEAN_Pain_long_new), color.interior(ID), missing.wings())
END GPL.

EXAMINE VARIABLES=Pain_long_new BY ID
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID).

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=PRED_1 RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: PRED_1=col(source(s), name("PRED_1"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Predicted Values"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by Predicted Values"))
  ELEMENT: point(position(PRED_1*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by STAI_trait"))
  ELEMENT: point(position(STAI_trait*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum RESID_1 MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*RESID_1))
END GPL.

 * Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by mindfulness"))
  ELEMENT: point(position(mindfulness*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=female RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: female=col(source(s), name("female"), unit.category())
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("female"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by female"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: point(position(female*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=center_time RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: center_time=col(source(s), name("center_time"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("center_time"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by center_time"))
  ELEMENT: point(position(center_time*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=center_time_sq RESID_1 MISSING=LISTWISE
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: center_time_sq=col(source(s), name("center_time_sq"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("center_time_sq"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Simple Scatter of Residuals by center_time_sq"))
  ELEMENT: point(position(center_time_sq*RESID_1))
END GPL.

CORRELATIONS
  /VARIABLES=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID).

NEW FILE.
DATASET NAME DataSet4 WINDOW=FRONT.
EXAMINE VARIABLES=VAR00001
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID).

MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID).

MIXED Pain_long_new WITH age STAI_trait pain_cat cortisol_serum mindfulness female center_time
    center_time_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1)
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness female center_time center_time_sq |
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT center_time center_time_sq | SUBJECT(ID) COVTYPE(ID) SOLUTION
  /SAVE=PRED RESID.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT resid_sq
  /METHOD=ENTER ID_dummy_2 ID_dummy_3 ID_dummy_4 ID_dummy_5 ID_dummy_6 ID_dummy_7 ID_dummy_8
    ID_dummy_9 ID_dummy_10 ID_dummy_11 ID_dummy_12 ID_dummy_13 ID_dummy_14 ID_dummy_15 ID_dummy_16
    ID_dummy_17 ID_dummy_18 ID_dummy_19 ID_dummy_20.

NEW FILE.
DATASET NAME DataSet4 WINDOW=FRONT.
EXAMINE VARIABLES=VAR00001
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


