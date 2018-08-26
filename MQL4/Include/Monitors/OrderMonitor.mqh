//+------------------------------------------------------------------+
//|                                                 OrderMonitor.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\CsvFileWriter.mqh>
#include <Common\OrderManager.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderMonitor : private CsvFileWriter
  {
private:

   string            _columnNames[];

   void ResetFile()
     {
      this.Open(this.FileName(),false);
      this.SetColumnNames(this._columnNames);
     }
public:

   void OrderMonitor(string fileName="Orders.csv"):CsvFileWriter(fileName,false)
     {
      string columns[]=
        {
            "Date"
            ,"Time"
            ,"Ticket ID"
            ,"Order Open Date"
            ,"Order Open Time"
            ,"Type"
            ,"Size"
            ,"Symbol"
            ,"Order Price"
            ,"Stop Loss"
            ,"Take Profit"
            ,"Commission"
            ,"Swap"
            ,"Profit"
            ,"Comment"
            ,"Order Magic Number"
        };
      ArrayCopy(this._columnNames,columns);
      this.SetColumnNames(this._columnNames);
     };

   bool RecordData()
     {
      this.ResetFile();
      bool out=true;
      Order orders[];
      int ct=OrderManager::GetOrdersArray(orders);
      for(int i=0;i<ct;i++)
        {
         this.SetPendingDataItem("Date",StringFormat("%i/%i/%i",Year(),Month(),Day()));
         this.SetPendingDataItem("Time",StringFormat("%i:%i:%i",Hour(),Minute(),Seconds()));
         this.SetPendingDataItem("Ticket ID",(string)orders[i].ticketID);
         this.SetPendingDataItem("Order Open Date",StringFormat("%i/%i/%i",TimeYear(orders[i].openTime),TimeMonth(orders[i].openTime),TimeDay(orders[i].openTime)));
         this.SetPendingDataItem("Order Open Time",StringFormat("%i:%i:%i",TimeHour(orders[i].openTime),TimeMinute(orders[i].openTime),TimeSeconds(orders[i].openTime)));
         this.SetPendingDataItem("Type",EnumToString(orders[i].orderType));
         this.SetPendingDataItem("Size",(string)orders[i].lotSize);
         this.SetPendingDataItem("Symbol",orders[i].symbol);
         this.SetPendingDataItem("Order Price",(string)orders[i].openPrice);
         this.SetPendingDataItem("Stop Loss",(string)orders[i].stopLoss);
         this.SetPendingDataItem("Take Profit",(string)orders[i].takeProfit);
         this.SetPendingDataItem("Commission",(string)orders[i].commission);
         this.SetPendingDataItem("Swap",(string)orders[i].swap);
         this.SetPendingDataItem("Profit",(string)orders[i].profit);
         this.SetPendingDataItem("Comment",orders[i].comment);
         this.SetPendingDataItem("Order Magic Number",(string)orders[i].magicNumber);
         out=out && (this.WritePendingDataRow()>0);
        }
      return out;
     };
  };
//+------------------------------------------------------------------+
