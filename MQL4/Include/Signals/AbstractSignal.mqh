//+------------------------------------------------------------------+
//|                                               AbstractSignal.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\ValidationResult.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class AbstractSignal
  {
public:
   string            Symbol;
   ENUM_TIMEFRAMES   Timeframe;
   int               Period;
   int               Shift;
   int               Signal;
   virtual bool      Validate(ValidationResult *validationResult)=0;
   virtual bool      Validate()=0;
   virtual int       Analyze()=0;
   virtual int       Analyze(int shift)=0;
  };
//+------------------------------------------------------------------+
