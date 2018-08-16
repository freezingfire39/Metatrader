//+------------------------------------------------------------------+
//|                                          BasketSignalScanner.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Common\Comparators.mqh>
#include <Common\BaseSymbolScanner.mqh>
#include <Common\OrderManager.mqh>
#include <Signals\SignalSet.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BasketSignalScanner : public BaseSymbolScanner
  {
private:
   Comparators       _compare;
   OrderManager      orderManager;
   SignalSet        *signalSet;
   double            lotSize;
   int               maxOpenOrders;
   double            gridStepSizeUp;
   double            gridStepSizeDown;
   bool              averageUp;
   bool              averageDown;
   bool              hedgingAllowed;
   bool              CanMarketOrderForOp(SignalResult &r);
   bool              CanMarketOrderStepForOp(SignalResult &r);
   bool              CanSendMarketOrder(SignalResult &r);
   bool              MustCloseOppositePositions(SignalResult &r);

public:
   bool              disableExitsBacksliding;
   bool              closePositionsOnOppositeSignal;
   void              BasketSignalScanner(
                                         SymbolSet *aSymbolSet,SignalSet *aSignalSet,
                                         double lotSize,bool allowExitsToBackslide,
                                         bool closePositionsOnOppositeSignal,
                                         int maxOpenOrderCount=1,
                                         double gridStepUpSizeInPricePercent=1.25,
                                         double gridStepDownSizeInPricePercent=1.25,
                                         bool averageUpStrategy=false,
                                         bool averageDownStrategy=false,
                                         bool allowHedging=false);
   void              PerSymbolAction(string symbol);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BasketSignalScanner::BasketSignalScanner(
                                              SymbolSet *aSymbolSet,SignalSet *aSignalSet,double aLotSize,
                                              bool allowExitsToBackslide,
                                              bool closeOrdersOnOppositeSignal,
                                              int maxOpenOrderCount=1,
                                              double gridStepUpSizeInPricePercent=1.25,
                                              double gridStepDownSizeInPricePercent=1.25,
                                              bool averageUpStrategy=false,
                                              bool averageDownStrategy=false,
                                              bool allowHedging=false):BaseSymbolScanner(aSymbolSet)
  {
   this.signalSet=aSignalSet;
   this.lotSize=aLotSize;
   this.disableExitsBacksliding=!allowExitsToBackslide;
   this.closePositionsOnOppositeSignal=closeOrdersOnOppositeSignal;
   this.maxOpenOrders=maxOpenOrderCount;
   this.gridStepSizeUp=gridStepUpSizeInPricePercent;
   this.gridStepSizeDown=gridStepDownSizeInPricePercent;
   this.averageUp=averageUpStrategy;
   this.averageDown=averageDownStrategy;
   this.hedgingAllowed=allowHedging;
  }
//+------------------------------------------------------------------+
//|Returns true when there are no open positions or when all open    |
//|positions are of the given orderType                              |
//+------------------------------------------------------------------+
bool BasketSignalScanner::CanMarketOrderForOp(SignalResult &r)
  {
   if(!r.isSet)
     {
      return false;
     }
   bool result;

   result=true;
   if(this.hedgingAllowed==true)
     {
      return true;
     }
   if(r.orderType==OP_BUY && OrderManager::PairHighestPricePaid(r.symbol,OP_SELL)>0)
     {
      result=false;
     }
   if(r.orderType==OP_SELL && OrderManager::PairHighestPricePaid(r.symbol,OP_BUY)>0)
     {
      result=false;
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketSignalScanner::CanMarketOrderStepForOp(SignalResult &r)
  {
   if(!r.isSet)
     {
      return false;
     }
   if(!this.CanMarketOrderForOp(r))
     {
      return false;
     }

   bool send=false;

   if(r.orderType==OP_BUY)
     {
      if(this.averageUp==true)
        {
         send=send || (MarketWatch::GetAsk(r.symbol)>this.orderManager.GetHighStep(r.symbol,OP_BUY,this.gridStepSizeUp));
        }
      if(this.averageDown==true)
        {
         send=send || (MarketWatch::GetAsk(r.symbol)<this.orderManager.GetLowStep(r.symbol,OP_BUY,this.gridStepSizeDown));
        }
     }

   if(r.orderType==OP_SELL)
     {
      if(this.averageUp==true)
        {
         send=send || (MarketWatch::GetBid(r.symbol)<this.orderManager.GetLowStep(r.symbol,OP_SELL,this.gridStepSizeUp));
        }
      if(this.averageDown==true)
        {
         send=send || (MarketWatch::GetBid(r.symbol)>this.orderManager.GetHighStep(r.symbol,OP_SELL,this.gridStepSizeDown));
        }
     }

   return send;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketSignalScanner::CanSendMarketOrder(SignalResult &r)
  {
   if(!r.isSet)
     {
      return false;
     }
   bool result=false;
   double openPositionCount=this.orderManager.PairOpenPositionCount(r.symbol,TimeCurrent());
   if(openPositionCount<this.maxOpenOrders)
     {
      if(openPositionCount==0)
        {
         result=true;
        }
      else if(openPositionCount>0)
        {
         if(this.CanMarketOrderStepForOp(r))
           {
            result=true;
           }
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool BasketSignalScanner::MustCloseOppositePositions(SignalResult &r)
  {
   if(!r.isSet)
     {
      return false;
     }
   bool result=false;
   if(0==this.orderManager.PairOpenPositionCount(r.orderType,r.symbol,TimeCurrent()))
     {
      if(closePositionsOnOppositeSignal)
        {
         result=true;
        }
     }
   return result;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BasketSignalScanner::PerSymbolAction(string symbol)
  {
   this.signalSet.Analyze(symbol,this.closePositionsOnOppositeSignal);
   if(this.signalSet.Signal==NULL)
     {
      return;
     }

   if(!this.signalSet.Signal.isSet)
     {
      return;
     }

   SignalResult *r=this.signalSet.Signal;

   if(this.CanSendMarketOrder(r))
     {
      this.orderManager.SendOrder(r,this.lotSize);
     }
   else
     {
      // could not send the order because there were opposite positions and hedging is disabled
      if(this.MustCloseOppositePositions(r))
        {
         // closing orders on opposite signal is enabled
         // close the open orders and begin trading in the opposite direction.
         this.orderManager.CloseOrders(r.symbol,TimeCurrent());
         this.orderManager.SendOrder(r,this.lotSize);
        }
      else
        {
         // if there are open orders in the signal direction, normalize the sl/tp
         if(0<this.orderManager.PairOpenPositionCount(r.orderType,r.symbol,TimeCurrent()))
           {
            // modifies the sl and tp according to the signal given.
            this.orderManager.NormalizeExits(
                                             r.symbol,r.orderType,r.stopLoss,
                                             r.takeProfit,this.disableExitsBacksliding);
           }
        }
     }
  }
//+------------------------------------------------------------------+
