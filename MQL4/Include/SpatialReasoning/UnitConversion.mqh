//+------------------------------------------------------------------+
//|                                               UnitConversion.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class UnitConversion
  {
public:

   static double TangentToRadians(double tangent)
     {
      return MathArctan(tangent);
     }

   static double RadiansToDegrees(double radians)
     {
      return radians*(180.0/M_PI);
     }

   static double TangentToDegrees(double tangent)
     {
      return RadiansToDegrees(TangentToRadians(tangent));
     }
  };
//+------------------------------------------------------------------+
