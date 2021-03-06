//+------------------------------------------------------------------+
//|                                                        Stats.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Stats
  {
public:
   template<typename T>
   static T          AbsoluteValue(T a);
   template<typename T>
   static T          Sum(T a,T b);
   template<typename T>
   static T          Sum(T &array[]);
   template<typename T>
   static T          Difference(T a,T b);
   template<typename T>
   static T          Difference(T &array[]);
   template<typename T>
   static T          Product(T a,T b);
   template<typename T>
   static T          Product(T &array[]);
   template<typename T>
   static T          Quotient(T a,T b);
   template<typename T>
   static T          Quotient(T &array[]);
   template<typename T>
   static T          Square(T a);
   template<typename T>
   static T          SquareRoot(T a);
   template<typename T>
   static T          Min(T &array[]);
   template<typename T>
   static T          Max(T &array[]);
   template<typename T>
   static T          Range(T &array[]);
   template<typename T>
   static T          Median(T &array[]);
   template<typename T>
   static T          InterquartileRange(T &array[]);
   template<typename T>
   static T          Average(T &array[]);
   template<typename T>
   static T          Mean(T &array[]);
   template<typename T>
   static T          StandardDeviation(T &array[]);
   template<typename T>
   static T          SampleStandardDeviation(T &array[]);
   template<typename T>
   static T          Variance(T &array[]);
   template<typename T>
   static T          SampleVariance(T &array[]);
   template<typename T>
   static T          Rank(double percent,T &array[]);
   template<typename T>
   static int        Count(T &array[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
int Stats::Count(T &array[])
  {
   return ArraySize(array);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
static T Stats::AbsoluteValue(T a)
  {
   return ((T)MathAbs((double)a));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Rank(double percentRank,T &array[])
  {
   T result=0;
   T copy[];
   int len=ArraySize(array);
   int rank=((int)MathFloor((len) *(percentRank/100)));
   int idx = rank;
   if(idx<0)
     {
      idx=0;
     }
   if(idx>len-1)
     {
      idx=len-1;
     }

   ArrayResize(copy,len);
   ArrayCopy(copy,array,0,0,WHOLE_ARRAY);
   ArraySort(copy,WHOLE_ARRAY,0,MODE_ASCEND);

   return ((T)copy[idx]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Min(T &array[])
  {
   int idx=ArrayMinimum(array);
   return array[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Max(T &array[])
  {
   int idx=ArrayMaximum(array);
   return array[idx];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Range(T &array[])
  {
   return Stats::Difference(Stats::Max(array),Stats::Min(array));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Difference(T a,T b)
  {
   return a-b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Difference(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T accumulator=0;
   int i;
   T currentElement;
   for(i=0;i<total;i++)
     {
      currentElement=array[i];
      accumulator=Stats::Difference(accumulator,currentElement);
     }
   return ((T)(accumulator));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Product(T a,T b)
  {
   return a*b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Product(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T accumulator=0;
   int i;
   T currentElement;
   for(i=0;i<total;i++)
     {
      currentElement=array[i];
      accumulator=Stats::Product(accumulator,currentElement);
     }
   return ((T)(accumulator));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Quotient(T a,T b)
  {
   return a/b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Quotient(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T accumulator=0;
   int i;
   T currentElement;
   for(i=0;i<total;i++)
     {
      currentElement=array[i];
      accumulator=Stats::Quotient(accumulator,currentElement);
     }
   return ((T)(accumulator));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Square(T a)
  {
   return a*a;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::InterquartileRange(T &array[])
  {
   T r=0;
   T copy[];
   int len=ArraySize(array);
   int midIdx=0;
   ArrayResize(copy,len);
   ArrayCopy(copy,array,0,0,WHOLE_ARRAY);
   ArraySort(copy,WHOLE_ARRAY,0,MODE_ASCEND);
   if(len%2==0)
     {
      midIdx=len/4;
      T i1 = copy[midIdx-1];
      T i2 = copy[midIdx];
      T r1=(i1+i2)/((T)2);

      midIdx=midIdx*3;
      T i3 = copy[midIdx-1];
      T i4 = copy[midIdx];
      T r2=(i3+i4)/((T)2);

      r=r2-r1;
     }
   else
     {
      midIdx=((int)MathRound(len/4));
      T r1=copy[midIdx];

      midIdx=((int)MathRound((len/4)*3));
      T r2=copy[midIdx];

      r=r2-r1;
     }
   return((T)(r));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Median(T &array[])
  {
   T median=0;
   T copy[];
   int len=ArraySize(array);
   int midIdx=0;
   ArrayResize(copy,len);
   ArrayCopy(copy,array,0,0,WHOLE_ARRAY);
   ArraySort(copy,WHOLE_ARRAY,0,MODE_ASCEND);
   if(len%2==0)
     {
      midIdx=len/2;
      T i1 = copy[midIdx-1];
      T i2 = copy[midIdx];
      T r=(i1+i2)/((T)2);
      median=r;
     }
   else
     {
      midIdx=((int)MathCeil(len/2));
      median=copy[midIdx];
     }
   return((T)(median));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Sum(T a,T b)
  {
   return a+b;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Sum(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T accumulator=0;
   int i;
   T currentElement;
   for(i=0;i<total;i++)
     {
      currentElement=array[i];
      accumulator=Stats::Sum(accumulator,currentElement);
     }
   return ((T)(accumulator));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Average(T &array[])
  {
   T total=(T)ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T sum=Stats::Sum(array);
   return Stats::Quotient(sum,total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Mean(T &array[])
  {
   return Stats::Average(array);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::Variance(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T mean=Stats::Average(array);
   T variance[];
   ArrayResize(variance,total,0);

   int i;
   for(i=0;i<total;i++)
     {
      variance[i]=Stats::Square(Stats::Difference(array[i],mean));
     }
   return ((T)Stats::Average(variance));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::SampleVariance(T &array[])
  {
   int total= ArraySize(array);
   if(total<=0)
     {
      return 0;
     }
   T mean=Stats::Average(array);
   T variance[];
   ArrayResize(variance,total,0);

   int i;
   for(i=0;i<total;i++)
     {
      variance[i]=Stats::Square(Stats::Difference(array[i],mean));
     }
   T sum=Stats::Sum(variance);
   T sampleSize=((T)(ArraySize(variance)-1);
                 if(sampleSize==0)
     {
      return 0;
     }
   return Stats::Quotient(sum,sampleSize);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::SquareRoot(T a)
  {
   T out=((T)MathSqrt((double)a));
   return out;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::StandardDeviation(T &array[])
  {
   T out=((T)Stats::Variance(array));
   return Stats::SquareRoot(out);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
template<typename T>
T Stats::SampleStandardDeviation(T &array[])
  {
   T out=((T)Stats::SampleVariance(array));
   return Stats::SquareRoot(out);
  }
//+------------------------------------------------------------------+
