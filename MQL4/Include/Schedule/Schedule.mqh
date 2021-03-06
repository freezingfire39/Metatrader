//+------------------------------------------------------------------+
//|                                                     Schedule.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property version   "1.00"
#property description "Scheduling helper."
#property strict

#include <Common\TimeStamp.mqh>
//+------------------------------------------------------------------+
//| Defines a schedule.                                              |
//+------------------------------------------------------------------+
class Schedule
  {
public:
   ENUM_DAY_OF_WEEK  DayStart;
   TimeStamp        *TimeStart;
   ENUM_DAY_OF_WEEK  DayEnd;
   TimeStamp        *TimeEnd;

   void              Schedule(ENUM_DAY_OF_WEEK startDay,
                              string startTime,
                              ENUM_DAY_OF_WEEK endDay,
                              string endTime);
   void             ~Schedule();
   string            ToString();
   bool              IsActive(datetime when);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Schedule::Schedule(ENUM_DAY_OF_WEEK startDay,
                        string startTime,
                        ENUM_DAY_OF_WEEK endDay,
                        string endTime)
  {
   DayStart=startDay;
   DayEnd=endDay;
   TimeStart=new TimeStamp(startTime);
   TimeEnd=new TimeStamp(endTime);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Schedule::IsActive(datetime when)
  {
   ENUM_DAY_OF_WEEK d=(ENUM_DAY_OF_WEEK)TimeDayOfWeek(when);
   bool activeAllDay=(d>DayStart && d<DayEnd);
   if(activeAllDay)
                 {
      return true;
     }

   int h = TimeHour(when);
   int m = TimeMinute(when);

   bool isStartDay=d==DayStart;
   bool isEndDay=d==DayEnd;
   bool isSingleDay=isStartDay && isEndDay;
   bool isActiveHour=h>TimeStart.Hour && h<TimeEnd.Hour;
   bool isStartHour=h==TimeStart.Hour;
   bool isActiveStartHour=(isStartHour && m>=TimeStart.Minute);
   bool isActiveStartDay=(isStartDay && (h>TimeStart.Hour || isActiveStartHour));
   bool isEndHour=h==TimeEnd.Hour;
   bool isActiveEndHour=(isEndHour && m<TimeEnd.Minute);
   bool isActiveEndDay=(isEndDay && (h<TimeEnd.Hour || isActiveEndHour));
   bool isActiveIntraday=(isActiveHour || isActiveStartHour || isActiveEndHour);
   bool isActiveNow=(
                     (isSingleDay && isActiveIntraday)
                     || (!isSingleDay && (isActiveStartDay || isActiveEndDay))
                     );

   return false || isActiveNow;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Schedule::ToString()
  {
   return (StringConcatenate(EnumToString(DayStart), " at ", TimeStart.ToString()," to ",EnumToString(DayEnd), " at ", TimeEnd.ToString()));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Schedule::~Schedule()
  {
   delete TimeStart;
   delete TimeEnd;
  }
//+------------------------------------------------------------------+
