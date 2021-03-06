#!/usr/bin/env bash

#The next two lines determine what the root password for mysql is. Change if you like.
debconf-set-selections <<< 'mysql-server mysql-server/root_password password iliketurtles'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password iliketurtles'
apt-get update
apt-get -y install mysql-server
apt-get -y install python-pip
apt-get -y install python-mysqldb
apt-get -y install git
apt-get -y install default-jre
apt-get -y install default-jdk
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
wget http://downloads.typesafe.com/scala/2.11.7/scala-2.11.7.tgz?_ga=1.262311372.1507431377.1443137757
mv scala-2.11.7.tgz?_ga=1.262311372.1507431377.1443137757 ./scala.tgz
tar -xzf ./scala.tgz
cd ./scala-2.11.7
cp -rf ./bin/* /bin/
cp -rf ./lib/* /lib/
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.7.tgz
tar -xzf ./spark-2.1.0-bin-hadoop2.7.tgz
mv ./spark-2.1.0-bin-hadoop2.7 /home/vagrant/spark-2.1.0
cp /home/vagrant/spark-2.1.0/lib/* /lib/
cp -rf /home/vagrant/spark-2.1.0/python/pyspark/ /usr/lib/python2.7/
cp /vagrant/environment /etc/environment
pip install py4j
cd
wget http://apache.claz.org/hadoop/common/hadoop-2.6.2/hadoop-2.6.2.tar.gz
tar -xzf ./hadoop-2.6.2.tar.gz
cp -rf ./hadoop-2.6.2/ /home/vagrant/
