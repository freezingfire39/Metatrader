//+------------------------------------------------------------------+
//|                          BollingerBandPullbackTraderSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

sinput string BollingerBandPullbackTraderSettings4; // ####
sinput string BollingerBandPullbackTraderSettings5; // #### Signal Entry
sinput string BollingerBandPullbackTraderSettings6; // ####

input int BollingerBandPullbackBbPeriod=30; // Period for Bollinger Bands.
input bool BollingerBandPullbackFadeTouch=false; // Fade the BB touch?
input int BollingerBandPullbackTouchPeriod=30; // How many bars is a BB touch valid?
input double BollingerBandPullbackBbDeviation=2; // BB standard deviation(s).
input ENUM_APPLIED_PRICE BollingerBandPullbackBbAppliedPrice=PRICE_OPEN; // BB Applied Price
input int BollingerBandPullbackTouchShift=0; // Touch Detection Offset
input int BollingerBandPullbackBbShift=0; // BB Shift
input color BollingerBandPullbackBbIndicatorColor=clrMagenta; // BB Indicator Color
input color BollingerBandPullbackTouchIndicatorColor=clrAqua; // Touch Detection Indicator Color

input int BollingerBandPullbackMaPeriod=30; // MA Period
input int BollingerBandPullbackMaShift=0; // MA Shift
input ENUM_MA_METHOD BollingerBandPullbackMaMethod=MODE_EMA; // MA Method
input ENUM_APPLIED_PRICE BollingerBandPullbackMaAppliedPrice=PRICE_TYPICAL; // MA Applied Price
input color BollingerBandPullbackMaColor=clrHotPink; // MA Indicator Color

sinput string BollingerBandPullbackTraderSettings7; // ####
sinput string BollingerBandPullbackTraderSettings8; // #### Signal Exit
sinput string BollingerBandPullbackTraderSettings9; // ####

input int BollingerBandPullbackAtrPeriod=30; // ATR Period
input double AtrSkew=0; // ATR Vertical Skew
input double BollingerBandPullbackAtrMultiplier=4; // ATR Multiplier
input color BollingerBandPullbackAtrColor=clrWheat; // ATR Indicator Color

sinput string BollingerBandPullbackTraderSettings1; // ####
sinput string BollingerBandPullbackTraderSettings2; // #### Signal Settings
sinput string BollingerBandPullbackTraderSettings3; // ####

input int BollingerBandPullbackShift=0; // Signal Shift
input double BollingerBandPullbackMinimumTpSlDistance=5; // Tp/Sl minimum distance, in spreads.
input int BollingerBandPullbackParallelSignals=2; // Quantity of parallel signals to use.
#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
