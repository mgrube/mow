# VERY Simple task
# Grabs most recent batch of trades for all available pairs, inserts into DB

import btceapi
import sys
import time

while True:
	time.sleep(30)
	alltrades = btceapi.getTradeHistory(sys.argv[1])
	for t in alltrades:
		print str(t.pair) + ',' +  str(t.price) + ',' +  str(t.amount) + ',' +  str(t.tid) + ',' + str(t.trade_type) + ',' + str(t.date)
	
