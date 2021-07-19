# The csvserver assignment

Part I

Run the container image infracloudio/csvserver:latest in background and check if it's running.

Solution

I have docker  and docker-compose already installed in my ubuntu environment running in an AWS EC2 instance.

Step 1: Part I

Run the container image infracloudio/csvserver:latest in background and check if it's running.
Solution:
1.  run the following command in the terminal:
```
docker run -d infracloudio/csvserver:latest
```
2.  check if the container is running by running the following command:
docker ps
you will discover that the there's no container running

run the docker ps -a command to get the name of the container. in this case I also saw that the container has exited.

Troubleshoot the problem by running the command: docker logs container_name. 
I got the following error:
2021/07/18 22:26:44 error while reading the file "/csvserver/inputdata": open /csvserver/inputdata: no such file or directory.
meaning that the container was expecting the presence of a file in the directory "/csvserver/inputdata" but it was not present.

3. Write the bash script to gencsv.sh to generate a file named inputFile whose content looks like:
0, 234
1, 98
2, 34 as per the instructions found in the README.md file.

open the vi editor and write the file name:

vi gencsv.sh
paste the code save and close the file:
```
#!/bin/bash

range=( $(seq  $counter -1 8)  ) 

for (( i=0; i<${#range[@]}; i++ )); 

do
	echo "$i,$(($RANDOM))" >> inputFile
done
```

run the following command to execute the script:
```
chmod +x gencsv.sh
./gencsv.sh
```
this should generate a file named inputFile in the current directory.

run cat inputFile to check the content of the file.

4. run the container with the file with the following command in other to attach the inputfile as avolume to the container.

docker run -d -v /home/ubuntu/inputFile:/csvservveer/inputdata/ infracloudio/csvserver:latest

5. to get shell access to the container run the following command:
docker exec -it heuristic_snyder bin/bash 
type exit to exit the container.

stop/delete the container by running: 

docker stop heuristic_snyder (where heuristic_synder is my caontainer_name, yours might be different)

to delete the container run:
docker rm heuristic_snyder

6. run the command to access it at http://localhost:9393 by mapping the host port at 9393 to the container port which is 9300
and also with the environmental variable given in the README.md file.

in my case I had to create a inbound rule for the security group running my ec2 instance with ubuntu and allowed the port 9393
in order to access the container.

to generate the file with name part-1-cmd run:
curl -o ./part-1-output http://xxxxxxx:9393/raw (where xxxxxx is my AWS EC2 instance public ipv4 address)

to generate the file with the name part-1-logs run:
docker logs [container_id] >& part-1-logs (container_id is the name of your container from the command docker ps)

## Part II

0. to delete the running container run:
docker stop [container_name]
docker rm [container_name]

1. to create a docker-compose.yaml file for the setup from part 1.
open a new file with the command: vi docker-compose.yaml
and paste the following content:

```
 version: "3"
 services:
     csvserver:
         image: infracloudio/csvserver:latest
         container_name: csvserver
         environment:
             - "CSVSERVER_BORDER=Orange"

         ports:
             - 9393:9300
         volumes:
             - /home/ubuntu/inputFile:/csvserver/inputdata/
```


## Part III
0. Delete any running container by running:
docker stop [container_name]
docker rm [container_name]

1. Add prometheus container by adding the image specified including the volume to the attached and and ports that are to be mapped from the host to the container, in this case both are 9090.

run the docker ps command to be doubly sure that their are no running containers.

Write and copy and paste the prometheus configuration into the prometheus.yml file and reference as a volume mounted on the docker-compose.yml file








