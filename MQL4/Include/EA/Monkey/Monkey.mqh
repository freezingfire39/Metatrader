//+------------------------------------------------------------------+
//|                                                       Monkey.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
#include <Signals\CellularAutomata.mqh>
#include <EA\PortfolioManagerBasedBot\BasePortfolioManagerBot.mqh>
#include <EA\Monkey\MonkeyConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Monkey : public BasePortfolioManagerBot
  {
public:
   void              Monkey(MonkeyConfig &config);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Monkey::Monkey(MonkeyConfig &config):BasePortfolioManagerBot(config)
  {
   this.signalSet.Add(new CellularAutomata(
                      config.botPeriod,
                      config.botTimeframe,
                      config.botMinimumTpSlDistance,
                      config.botSkew,
                      config.botAtrMultiplier,
                      config.botRangePeriod,
                      config.botIntradayTimeframe,
                      config.botIntradayPeriod));
   this.Initialize();
  }
//+------------------------------------------------------------------+
