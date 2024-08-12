Sukhum Boondecharak
S3940976

Instructions:

1. Go to the local directory where all the files are
2. From your local directory, enter these commands: 
	scp -r task1.pig jumphost:~/
	scp -r task2.pig jumphost:~/
	scp -r note.py jumphost:~/
	scp -r cust_order.csv jumphost:~/
	scp -r order_line.csv jumphost:~/
3. After all files are copied to jumphost, enter the following command to enter jumphost:
	ssh jumphost
4. From jumphost, enter these commands: 
	scp -r task1.pig hadoop:~/
	scp -r task2.pig hadoop:~/
	scp -r note.py hadoop:~/
	scp -r cust_order.csv hadoop:~/
	scp -r order_line.csv hadoop:~/

The above instruction are with the expectation that you used to enter jumphost and hadoop before, as well as having created an EMR master node in hadoop. If it is not the case, from your jumphost, enter the following command and wait about 15 minutes:
	./create_cluster.sh

5. After all files are copied to hadoop, enter the following command to enter hadoop:
	ssh hadoop
6. Enter the following command to see if all flies are already in hadoop:
	ls
7. Follow each instruction for each task


===== TASK 1 =====

Enter the following commands to ensure directories does not exist in hdfs:
	hadoop fs -rm -r /input
	hadoop fs -rm -r /output/task1

Enter the following commands to create input directory and put necessary file into it:
	hadoop fs -mkdir /input
	hadoop fs -put ./cust_order.csv /input/cust_order.csv
	hadoop fs -put ./order_line.csv /input/order_line.csv

Enter the following command to see if all files are in hdfs:
	hadoop fs -ls /input

Enter the following command to run pig file:
	pig -x mapreduce task1.pig

After completion, enter the following command to see if there is a result file:
	hadoop fs -ls /output/task1

Enter the following command to see the result:
	hadoop fs -cat /output/task1/p*


===== TASK 2 =====

Enter the following commands to ensure directories does not exist in hdfs:
	hadoop fs -rm -r /input
	hadoop fs -rm -r /output/task2

Enter the following commands to create input directory and put necessary file into it:
	hadoop fs -mkdir /input
	hadoop fs -put ./cust_order.csv /input/cust_order.csv
	hadoop fs -put ./order_line.csv /input/order_line.csv
	hadoop fs -put ./note.py /input/note.py

Enter the following command to see if all files are in hdfs:
	hadoop fs -ls /input

Enter the following command to run pig file:
	pig -x mapreduce task2.pig

After completion, enter the following command to see if there is a result file:
	hadoop fs -ls /output/task2

Enter the following command to see the result:
	hadoop fs -cat /output/task2/p*
