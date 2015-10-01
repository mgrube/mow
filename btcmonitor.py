#This is a modified version of the network wordcount example.
#Exercise: Do something useful with the output

from __future__ import print_function

import sys
import time
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
import datetime

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
    #lines.pprint(250)
    prices = lines.filter(lambda line: len(line.split(',')) > 5)\
		  .filter(lambda line: isWithin30Sec(line.split(',')[5]))\
                  .map(lambda line: float(line.split(',')[1])) 

    #agg = prices.reduce(lambda a, b : (a + b)).map(lambda a: a/count)
    prices.count().pprint()
    prices.pprint()
    ssc.start()
    ssc.awaitTermination()
