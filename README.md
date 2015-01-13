egoEconomotrics
============

# this project uses Apache Spark run on a Single Node Hadoop/Yarn

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

Monitoring DFS Health

Browsing the File System's health

http://localhost:50070


Yarn Daemons
Start ResourceManager daemon and NodeManager daemon:

> $HDFS_HOME/sbin/start-yarn.sh

When you're done, stop the daemons with:

> $HDFS_HOME/sbin/stop-yarn.sh

Monitoring Resource Manager

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
[info] Packaging {..}/{..}/target/scala-2.10/simple-project_2.10-1.0.jar

### Set SPARK HOME

> SPARK_HOME=~/bin/local/bigdata/spark

### Use spark-submit to run your application
> ${SPARK_HOME}/bin/spark-submit --class "SimpleApp" --master local[4] target/scala-2.10/egoeconometrics_2.10-0.1-SNAPSHOT.jar

...
Lines with a: 41, Lines with b: 17


## License

Copyleft © 2014 EgoOyiri [AfricaCoin]

Distributed under the Eclipse Public License either version 1.0 or (at
your option) any later version.
