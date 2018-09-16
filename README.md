# deploy-local-ambari
dependencies:
- docker

How to run:
~~~
./run.sh # default with 3 nodes
./run.sh --nodes=10 # run with 10 nodes
~~~

you can modify the run.sh to allow docker to allocation different resource to server and client containers.

It probably will end up with a error like this:
~~~
About to start PostgreSQL
ERROR: Exiting with exit code 1.
~~~
do not worry. You can continue to manually start it again with this command:
~~~
docker exec tongjiyiming-ambari-0 ambari-server start
~~~
Then, you will be fine.

go to "http://localhost:8080" and connect to ambari server.

ignore the "iptables running" and "npd not runnning" warning when register the containers.

To test hadoop/yarn:
~~~
docker exec -it tongjiyiming-ambari-0 bash && su hdfs
~~~
you will in the bash command interface. Then, use:
~~~
yarn jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-mapreduce-examples.jar pi 16 1000
~~~
congrat if you get a pi value. Check the outputed message to see if there is not failed node.
