USE TDB;
CREATE TABLE BTCE_TRADES (Pair varchar(50), price decimal(30, 15), amount decimal(30,15), tid int, trade_type varchar(50), time datetime);
ALTER TABLE BTCE_TRADES ADD PRIMARY KEY (tid);
COMMIT;
