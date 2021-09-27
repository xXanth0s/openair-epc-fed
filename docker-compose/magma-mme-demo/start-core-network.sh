#!/bin/sh

echo "Starting the 4g core network with docker-composen"

echo "\n0. Destroying existing container to ensure a clean start of the core network"
sudo docker-compose down

echo "\n1. Init of the cassandra db"
sudo docker-compose up -d db_init

echo "\n2. Wait to finish the initialisation of the cassandra db"
sleep_count=10
sleep $sleep_count # Wait some time, before we start to poll the status

while ! sudo docker logs demo-db-init | grep -q "OK";
do
   delay_in_sec=1
   sleep $delay_in_sec
   sleep_count=$((sleep_count+delay_in_sec))
   echo "Waited $sleep_count secounds for the db\n"
done
echo "Cassandra DB is up!"

echo "\n3. Removing the used container for the initialisation process"
sudo docker rm demo-db-init

echo "\n4. Starting the rest of the core network"
sudo docker-compose up -d oai_spgwu

echo "\n5.Wait until all containers are started"
sleep_count=5
sleep $sleep_count # Wait some time, before we start to poll the status

while sudo docker ps -a | grep -q "starting";
do
   delay_in_sec=1
   sleep $delay_in_sec
   sleep_count=$((sleep_count+delay_in_sec))
   echo "Waited $sleep_count secounds for the container"
done
echo "\nThe core network is up!"
sshpass -p admin42 ssh admin42@obelix.hm.edu cvlc --play-and-exit ready.mp3 &
sudo docker ps -a

echo "\n6. Starting to watch over the docker container of the 4g core network"
frequency=2
echo "Checking the status every $frequency seconds"

time_tracker=0
while ! sudo docker ps -a | grep -q "Exited";
do
   sleep $frequency
   time_tracker=$((time_tracker+frequency))
   echo "Everything is fine for already $time_tracker seconds"
done

echo "\n\nAt least one container exited!!!"
echo "\nCurrent status of the docker container: "
sudo docker ps -a
sshpass -p admin42 ssh admin42@obelix.hm.edu cvlc --play-and-exit alarm.mp3 &
