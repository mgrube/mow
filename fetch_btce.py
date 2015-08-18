# VERY Simple task
# Grabs most recent batch of trades for all available pairs, inserts into DB

import btceapi
import MySQLdb as mdb
import sys

alltrades = btceapi.getTradeHistory(sys.argv[1])
data = list()

conn = mdb.connect('localhost', 'trading', 'ilikeponies', 'TDB')

try:

	cur = conn.cursor()
	for t in alltrades:
		cur.execute("INSERT INTO BTCE_TRADES (Pair, price, amount, tid, trade_type, time) VALUES (\'%s\', \'%s\', \'%s\', \'%s\', \'%s\', \'%s\');" % (str(t.pair), str(t.price), str(t.amount), str(t.tid), str(t.trade_type), str(t.date)) )
	
except mdb.IntegrityError:
	print 'Primary key duplicate'	

conn.commit()
