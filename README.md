egoEconomotrics
============

This project uses Apache Spark run on a Single Node Hadoop/Yarn.

# Warning:
  This install will play with your ~/.ssh folder, more specifically the <i>.ssh/authorized_keys</i> file<br>
  It will allow hadoop to run the <i>ssh localhost</i> command using  a DSA PassPhraseLess key

* Defintion:
  - Hadoop HDFS (Hadoop Distributed File System)<br>
  - Yarn, MapReduce 2.0<br> 
  - Spark general engine for large-scale data processing 

* Languages:
  - Scala and Python

# Prerequisites:
- wget
- java (JVM)
- *nix - Darwin, Cygwin (not yet)
- Python (if running Python)
- sbt to run the Scala examples

# Running the install:

> ./bootstrap/install.sh

## Hadoop NameNode Daemons

- Set the Hadoop Home
> HDFS_HOME=~/bin/local/bigdata/hadoop

- Starting the services

> $HDFS_HOME/sbin/start-dfs.sh

Note: On MacOS, make sure SSH is started. System Preferences/Sharing/Remote Login [ON]

-  Checking Services are running

> jps

13049 NameNode (HDFS Name Node) -- Make sure this is running<br>
13241 DataNode (HDFS Data Node)<br>
22752 ResourceManager (Yarn Resource)<br>
22894 NodeManager (Yarn Node)<br>

---

### Monitoring DFS Health

Browsing the File System's health

http://localhost:50070


### Yarn Daemons

- Start ResourceManager daemon and NodeManager daemon:

> $HDFS_HOME/sbin/start-yarn.sh

### Monitoring Resource Manager

If you want to look at the running jobs or already executed (Jobwatch Equivalent)

http://localhost:8088

### Hadoop Distributed File System (Hadoop DFS) handling

- Create and Mount a new Hadoop DFS

> ${HDFS_HOME}/bin/hdfs namenode -format 

Note: You need to restart HDFS


- Create a directory in Hadoop DFS

Create the user directory along with the owner directory

> ${HDFS_HOME}/bin/hdfs dfs -mkdir -p /user/${USER}


## Running the example

### Package a jar containing your application
> sbt package

...
[success] Total time: ...

#### Set SPARK HOME

> SPARK_HOME=~/bin/local/bigdata/spark

#### Use spark-submit to run your application
> ${SPARK_HOME}/bin/spark-submit --class "SimpleApp" --master local[4] target/scala-2.10/egoeconometrics_2.10-0.1-SNAPSHOT.jar

...
Lines with a: 41, Lines with b: 17

## Running Interactive Shell

* Scala
> ${SPARK_HOME}/bin/spark-shell

* Python
> ${SPARK_HOME}/bin/bin/pyspark --master local[4]

## Running Spark Streaming 

* You will first need to run Netcat (a small utility found in most Unix-like systems) as a data server by using

> nc -lk 9999

* Then, in a different terminal, you can start the example by using

> ${SPARK_HOME}/bin/spark-submit --class "QuickStreamingApp" --master local[4] target/scala-2.10/egoeconometrics_2.10-0.1-SNAPSHOT.jar localhost 9999

# Stopping the Services

When you're done, stop the daemons with:

> $HDFS_HOME/sbin/stop-yarn.sh

> $HDFS_HOME/sbin/stop-dfs.sh

# AWS Ubuntu

* installing SBT<br>
    http://www.scala-sbt.org/release/tutorial/Installing-sbt-on-Linux.html<br>
* Install Java:<br>
    - http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html<br>
    - Add JAVA_HOME in profile (i.e. export JAVA_HOME=/usr/lib/jvm/java-8-oracle in .bashrc)<br>
    - After the install change the ${JAVA_HOME} with /usr/lib/jvm/java-8-oracle<br>
      in ~/bin/local/bigdata/hadoop/etc/hadoop/hadoop-env.sh <br>
* Add a new spark user and allow remote connection
* Micro Instance out of memory - add swap<br>
     http://developer24hours.blogspot.ca/2013/02/micro-instance-out-of-memory-add-swap.html<br>
     Here are the commands to add a 1GB swap<br>
> sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024<br>
> sudo /sbin/mkswap /var/swap.1<br>
> sudo /sbin/swapon /var/swap.1<br>
     To turn off the swap do the following:<br>
> sudo /sbin/swapoff /var/swap.1

Recommended reading for AWS http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/

# Kwown issues:
* Not working under Cygwin
  - Install and run SSH Daemon on Cygwin <br>
     http://docs.oracle.com/cd/E24628_01/install.121/e22624/preinstall_req_cygwin_ssh.htm
  - After the install change the ${JAVA_HOME} with i.e. /cygdrive/c/opt/bin/java<br>
     in ~/bin/local/bigdata/hadoop/etc/hadoop/hadoop-env.sh <br>

## License

Copyleft © 2014 EgoOyiri [AfricaCoin]

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
