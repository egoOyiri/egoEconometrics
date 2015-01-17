egoEconomotrics
============

This project uses Apache Spark run on a Single Node Hadoop/Yarn

# Warning:
* Carefully use this script under AWS as it messes the .ssh folder by adding a DSA PassPhraseLess key in .ssh/authorized_keys<br>
      Recommended reading for AWS http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/

# Kwown issues:
* Not working well under Cygwin
  Install SSH Daemon on Cygwin <br>
  http://docs.oracle.com/cd/E24628_01/install.121/e22624/preinstall_req_cygwin_ssh.htm
* Ubuntu EC2
  - Install Java:<br>
     http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html<br>
  - After the install change the ${JAVA_HOME} with /usr/lib/jvm/java-8-oracle<br>
     in ~/bin/local/bigdata/hadoop/etc/hadoop/hadoop-env.sh <br>
  - Micro Instance out of memory - add swap<br>
     http://developer24hours.blogspot.ca/2013/02/micro-instance-out-of-memory-add-swap.html<br>
     Here are the commands to add a 1GB swap<br>
    > sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024<br>
    > sudo /sbin/mkswap /var/swap.1<br>
    > sudo /sbin/swapon /var/swap.1<br>
     To turn off the swap do the following:<br>
    > sudo /sbin/swapoff /var/swap.1


# Prerequisites:
- wget
- java (JVM)
- *nix - Darwin, Linux, Cygwin
* sbt to run the examples

* Warning:
This will mess up with your ~/.ssh folder

To run the install:

> bootstrap/install.sh

Set the Hadoop Home
> HDFS_HOME=~/bin/local/bigdata/hadoop

### NameNode Daemons
Starting the services

> $HDFS_HOME/sbin/start-dfs.sh

Note: On MacOS, make sure SSH is started. System Preferences/Sharing/Remote Login [ON]

 Checking Services are running

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
Start ResourceManager daemon and NodeManager daemon:

> $HDFS_HOME/sbin/start-yarn.sh

### Monitoring Resource Manager

If you want to look at the running jobs or already executed (Jobwatch Equivalent)

http://localhost:8088
Hadoop Distributed File System (Hadoop DFS) handling
Create and Mount a new Hadoop DFS

> hdfs namenode -format


Create a directory in Hadoop DFS

Create the user directory along with the owner directory

> hdfs dfs -mkdir -p /user/${USER}


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

> ${SPARK_HOME}/bin/spark-shell

## Running Spark Streaming 

* You will first need to run Netcat (a small utility found in most Unix-like systems) as a data server by using

> nc -lk 9999

* Then, in a different terminal, you can start the example by using

> ${SPARK_HOME}/bin/spark-submit --class "QuickStreamingApp" --master local[4] target/scala-2.10/egoeconometrics_2.10-0.1-SNAPSHOT.jar localhost 9999

# Stopping the Services

When you're done, stop the daemons with:

> $HDFS_HOME/sbin/stop-yarn.sh

> $HDFS_HOME/sbin/stop-dfs.sh


## License

Copyleft © 2014 EgoOyiri [AfricaCoin]

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
