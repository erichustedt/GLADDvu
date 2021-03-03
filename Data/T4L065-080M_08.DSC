#DESC	1.2 * DESCRIPTOR INFORMATION ***********************
*
*	Dataset Type and Format:
*
DSRC	EXP
BSEQ	BIG
IKKF	CPLX
XTYP	IDX
YTYP	NODATA
ZTYP	NODATA
*
*	Item Formats:
*
IRFMT	D
IIFMT	D
*
*	Data Ranges and Resolutions:
*
XPTS	344
XMIN	-100.000000
XWID	2058.000000
*
*	Documentational Text:
*
TITL	'DEER'
IRNAM	'Intensity'
IINAM	'Intensity'
XNAM	'Time'
IRUNI	''
IIUNI	''
XUNI	'ns'
*
************************************************************
*
#SPL	1.2 * STANDARD PARAMETER LAYER
*
OPER    xuser
DATE    02/25/20
TIME    12:53:56
CMNT    
SAMP    
SFOR    
STAG    C
EXPT    
OXS1    
AXS1    
AXS2    
AXS3    
MWPW    0.02
A1CT    1.223
B0VL    1.222502
A1SW    0.02
MWFQ    3.418441e+10
AVGS    4
*
************************************************************
*
#DSL	1.0 * DEVICE SPECIFIC LAYER
*

.DVC     acqStart, 1.0


.DVC     cwBridge, 1.0

AcqFineTuning      Never
Power              20.00 mW
PowerAtten         0.00 dB

.DVC     fieldCtrl, 1.0

AllegroMode        True
CenterField        12230.00 G
Delay              0.0 s
FieldFlyback       On
FieldPosition      12225.020 G
FieldWait          Wait LED off
GFactor            2.000000
MeasuringHall      False
SetToSampleG       False
StaticFieldMon     12140.000 G
SweepDirection     Up
SweepWidth         200.0 G

.DVC     freqCounter, 1.0

FrequencyMon       34.184413 GHz
QMonitBridge       Off

.DVC     ftBridge, 1.0

Attenuation        60.00 dB
ELDORAtt           0 dB
FrequencyA         34.246673 GHz
QLCWPower          1200
VideoBW            200 MHz
VideoGain          36 dB

.DVC     ftEpr, 1.0

AutoTimeOut        True
AveragesPerScan    256
FTEzB0SettlDel     0 s
FTEzB0Step         0 G
FTEzCurrELDOR      34.246673 GHz
FTEzD11deer        200 ns
FTEzD20deer        2000 ns
FTEzD3deer         100 ns
FTEzDXdeer         6 ns
FTEzDelay0         574 ns
FTEzDelay1         0 ns
FTEzDelay2         0 ns
FTEzDelay4         0 ns
FTEzDeltaX         0 ns
FTEzDeltaY         0 ns
FTEzELDORStart     33.400000 GHz
FTEzELDORWidth     0.000000 GHz
FTEzENDORDetDel    0 ns
FTEzExtTrgDel      0 ns
FTEzIntgBase       1 ns
FTEzIntgGate       40 ns
FTEzMWPiHalf       6 ns
FTEzNPls           1
FTEzP20deer        36 ns
FTEzP3             0 ns
FTEzRF1Pi          0 ns
FTEzRF1PlsSep      2 ns
FTEzRF1Pump        0.500 MHz
FTEzRF1Start       0.500 MHz
FTEzRF1Width       0.000 MHz
FTEzSRELDORExp     False
FTEzSXdeer         344
FTEzSXdeerExp      True
FTEzSleep          0 s
PCycleAllowed      True
PCycleOn           True
PPExtTrg           False
PPExtTrgSlope      Rising
PlsSPELEXPSlct     4P-DEER
PlsSPELLISTSlct    2-step
PlsSPELPhPrgEx     Normal
QuadDetect         True
ReplaceMode        Off
ShotRepTime        799.68 us
ShotsPLoop         256
SmoothAllowed      False
SmoothPoints       1
SptProgress        100 %
StochMode          False
SweepsPExp         4
TriggerTimeOut     164 s
XSpecRes           344
YSpecRes           1

.DVC     recorder, 1.0

BaselineCorr       Off
NbScansAcc         4
NbScansDone        4
NbScansToDo        4
ReplaceMode        Off
SmoothMode         Auto
SmoothPoints       1

.DVC     routeTrg, 1.0


.DVC     sigChanSmall, 1.0


.DVC     transRec, 1.0


*
************************************************************
