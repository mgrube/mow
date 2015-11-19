#Exercise: Do something useful with the output

from __future__ import print_function

import sys
import time
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
import datetime

#Normally in Spark you'd use a Window. 
#We cannot do this with our stream because it simply returns the last 150 trades
def isWithin30Sec(time):
	if datetime.datetime.strptime(time, '%Y-%m-%d %H:%M:%S') >= datetime.datetime.now() - datetime.timedelta(0, 30):
		return True
	else:
		return False

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: btcmonitor.py <hostname> <port>", file=sys.stderr)
        exit(-1)

    sc = SparkContext(appName="BTCPriceMonitor")
    ssc = StreamingContext(sc, 1)

    lines = ssc.socketTextStream(sys.argv[1], int(sys.argv[2]))
   
    prices = lines.filter(lambda line: len(line.split(',')) > 5)\
		  .filter(lambda line: isWithin30Sec(line.split(',')[5]))
            
    sums = prices.map(lambda line: (line.split(',')[0], float(line.split(',')[1]))).reduceByKey(lambda a,b: a+b)
    counts = prices.map(lambda line: (line.split(',')[0], 1)).reduceByKey(lambda a,b: a+b)
    sums = sums.join(counts)
    avg = sums.map(lambda k: (k[0], k[1][0]/k[1][1]))


    avg.pprint()
 
    ssc.start()
    ssc.awaitTermination()
