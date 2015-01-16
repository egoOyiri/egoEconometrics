#!/bin/bash

set -e

# Let's make room for this
ROOT_DIST=$HOME/bin/local/bigdata

# Is it cleaned up?
rm -rf ${ROOT_DIST}
mkdir -p ${ROOT_DIST}

# Installing Hadoop and Yarn
HADOOP_VERSION=2.5.2
wget http://mirror.reverse.net/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -O ${ROOT_DIST}/hadoop-${HADOOP_VERSION}.tar.gz
tar zxvf ${ROOT_DIST}/hadoop-${HADOOP_VERSION}.tar.gz -C ${ROOT_DIST}
ln -s ${ROOT_DIST}/hadoop-${HADOOP_VERSION} ${ROOT_DIST}/hadoop
rm ${ROOT_DIST}/hadoop-${HADOOP_VERSION}.tar.gz

SPARK_VERSION=1.2.0
HADOOP_SPARK_VERSION=2.4
wget http://www.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz  -O ${ROOT_DIST}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz
tar zxvf ${ROOT_DIST}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz -C ${ROOT_DIST}
ln -s ${ROOT_DIST}//spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION} ${ROOT_DIST}/spark
rm ${ROOT_DIST}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_SPARK_VERSION}.tgz

#
#
# The below configuration is to allow Hadoop to run on a single node
#
#

# Setup passphraseless ssh
# If you cannot ssh to $hostname without a passphrase, execute the following commands:
rm ~/.ssh/id_dsa     || { echo "rm ~/.ssh/id_dsa command failed"; }
rm ~/.ssh/id_dsa.pub || { echo "rm ~/.ssh/id_dsa.pub command failed"; }
ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys 

# enable ssh localhost access for Hadoop Services
rm ~/.ssh/config     || { echo "rm ~/.ssh/config command failed"; }
echo "Host localhost"                    >  ~/.ssh/config
echo "HostName ${HOSTNAME}"              >> ~/.ssh/config
echo "Port 22"                           >> ~/.ssh/config

system=`uname -s`

case $system in
Darwin)
echo "User ${LOGNAME}"                   >> ~/.ssh/config
;;
*)
echo "User ${USERNAME}"                  >> ~/.ssh/config
;;
esac

# The below example were taken from Hadoop websites
# For some reasons , the hadoop-site.xml is split in multiple files
mkdir -p ${ROOT_DIST}/hadoop/etc/hadoop

# conf/core-site.xml:
cp ${ROOT_DIST}/hadoop/share/hadoop/common/templates/core-site.xml ${ROOT_DIST}/hadoop/etc/hadoop/core-site.xml.orig

#conf/hdfs-site.xml:
cp ${ROOT_DIST}/hadoop/share/hadoop/hdfs/templates/hdfs-site.xml ${ROOT_DIST}/hadoop/etc/hadoop/hdfs-site.xml.orig

# conf/mapred-site.xml:
cp ${ROOT_DIST}/hadoop/share/hadoop/common/templates/core-site.xml ${ROOT_DIST}/hadoop/etc/hadoop/mapred-site.xml.orig

# conf/yarn-site.xml:
cp ${ROOT_DIST}/hadoop/share/hadoop/common/templates/core-site.xml ${ROOT_DIST}/hadoop/etc/hadoop/yarn-site.xml.orig

case $system in
Darwin)
/usr/bin/sed -e '/<configuration>/ a \'$'\n <property><name>fs.defaultFS</name><value>hdfs:\/\/'${HOSTNAME}':9000</value></property>'               < ${ROOT_DIST}/hadoop/etc/hadoop/core-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/core-site.xml
/usr/bin/sed -e '/<configuration>/ a \'$'\n <property><name>dfs.replication</name><value>1</value></property>'                                      < ${ROOT_DIST}/hadoop/etc/hadoop/hdfs-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/hdfs-site.xml
/usr/bin/sed -e '/<configuration>/ a \'$'\n <property><name>mapreduce.framework.name</name><value>yarn</value></property>'                          < ${ROOT_DIST}/hadoop/etc/hadoop/mapred-site.xml.orig > ${ROOT_DIST}/hadoop/etc/hadoop/mapred-site.xml
/usr/bin/sed -e '/<configuration>/ a \'$'\n <property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>'        < ${ROOT_DIST}/hadoop/etc/hadoop/yarn-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/yarn-site.xml
;;
*)
sed -e '/<configuration>/ a \\t <property>\n\t\t<name>fs.defaultFS<\/name>\n\t\t<value>hdfs:\/\/'${HOSTNAME}':9000<\/value>\n\t<\/property>'        < ${ROOT_DIST}/hadoop/etc/hadoop/core-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/core-site.xml
sed -e '/<configuration>/ a \\t <property>\n\t\t<name>dfs.replication<\/name>\n\t\t<value>1<\/value>\n\t<\/property>'                               < ${ROOT_DIST}/hadoop/etc/hadoop/hdfs-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/hdfs-site.xml
sed -e '/<configuration>/ a \\t <property>\n\t\t<name>mapreduce.framework.name<\/name>\n\t\t<value>yarn<\/value>\n\t<\/property>'                   < ${ROOT_DIST}/hadoop/etc/hadoop/mapred-site.xml.orig > ${ROOT_DIST}/hadoop/etc/hadoop/mapred-site.xml
sed -e '/<configuration>/ a \\t <property>\n\t\t<name>yarn.nodemanager.aux-services<\/name>\n\t\t<value>mapreduce_shuffle<\/value>\n\t<\/property>' < ${ROOT_DIST}/hadoop/etc/hadoop/yarn-site.xml.orig   > ${ROOT_DIST}/hadoop/etc/hadoop/yarn-site.xml
;;
esac

