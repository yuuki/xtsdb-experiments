#!/bin/bash
set -ex

apt-get update -y
apt-get install -y software-properties-common vim git curl wget build-essential screen sysstat supervisor libjemalloc1

# Install Cassandra
echo "deb http://www.apache.org/dist/cassandra/debian 30x main" | tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl -sSL https://www.apache.org/dist/cassandra/KEYS | apt-key add -
apt-get update -y
apt-get install -y openjdk-8-jdk cassandra
systemctl start cassandra

# Install KairosDB
wget https://github.com/kairosdb/kairosdb/releases/download/v1.2.2/kairosdb_1.2.2-1_all.deb
dpkg -i kairosdb_1.2.2-1_all.deb

# Install kairos-carbon
export CLASSPATH=tools/tablesaw-1.2.0.jar
git clone https://github.com/kairosdb/kairos-carbon.git
cd kairos-carbon
wget https://repo1.maven.org/maven2/net/razorvine/pyrolite/4.22/pyrolite-4.22.jar
mv pyrolite-*.jar /opt/kairosdb/lib/
java make
mv build/jar/kairos-carbon-1.3.jar /opt/kairosdb/lib/
cp src/main/resources/kairos-carbon.properties /opt/kairosdb/conf/

/opt/kairosdb/bin/kairosdb.sh start
