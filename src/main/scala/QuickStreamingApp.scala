import org.apache.spark._
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._

object QuickStreamingApp {
  def main(args: Array[String]) {
    val logFile = "README.md" // Should be some file on your system
    val conf = new SparkConf().setMaster("local[2]").setAppName("NetworkWordCount")
    val ssc = new StreamingContext(conf, Seconds(1))
    
    // Create a DStream that will connect to hostname:port, like localhost:9999
    val lines = ssc.socketTextStream("localhost", 9999)
    // Split each line into words
    val words = lines.flatMap(_.split(" "))
    
    // Count each word in each batch
    val pairs = words.map(word => (word, 1))
	val wordCounts = pairs.reduceByKey(_ + _)
	
	// Print the first ten elements of each RDD generated in this DStream to the console
	wordCounts.print()
	ssc.start()             // Start the computation
	ssc.awaitTermination()  // Wait for the computation to terminate
  }
}