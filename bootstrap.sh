#!/usr/bin/env bash

#The next two lines determine what the root password for mysql is. Change if you like.
debconf-set-selections <<< 'mysql-server mysql-server/root_password password iliketurtles'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password iliketurtles'
apt-get -y install mysql-server
apt-get -y install python-pip
apt-get -y install python-mysqldb
apt-get -y install git
git clone https://github.com/alanmcintyre/btce-api.git
cd btce-api
python setup.py install
cd
mysql < /vagrant/dbinit.sql -u root --password=iliketurtles
mysql TDB < /vagrant/createbtcetable.sql -u trading --password=ilikeponies
crontab -l > crontasks
echo "*/2 * * * * python /vagrant/fetch_btce.py btc_usd" >> crontasks
echo "*/2 * * * * python /vagrant/fetch_btce.py ltc_btc" >> crontasks
echo "*/2 * * * * python /vagrant/fetch_btce.py ltc_usd" >> crontasks
echo "*/2 * * * * python /vagrant/fetch_btce.py ppc_usd" >> crontasks
echo "*/2 * * * * python /vagrant/fetch_btce.py ppc_btc" >> crontasks
crontab crontasks
