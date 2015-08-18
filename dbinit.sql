CREATE DATABASE TDB;
CREATE USER 'trading'@'localhost' IDENTIFIED BY 'ilikeponies';
GRANT ALL ON TDB.* TO 'trading'@'localhost';
