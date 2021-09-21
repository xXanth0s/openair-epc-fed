#!/bin/bash

echo "Starting the 4g core network with docker-composen"

echo "\n0. Destroying existing container to ensure a clean start of the core network"
sudo docker-compose down

echo "\n1. Init of the cassandra db"
sudo docker-compose up -d db_init

echo "\n2. Wait to finish the initialisation of the cassandra db"
sleep_count=5
sleep $sleep_count # Wait some time, before we start to poll the status

while ! sudo docker logs demo-db-init | grep -q "OK";
do
   delay_in_sec=1
   sleep $delay_in_sec
   echo "Waited $sleep_count secounds for the db"
   docker_logs_of_the_db_init=$(sudo docker logs demo-db-init)
   sleep_count=$((sleep_count+delay_in_sec))
done
echo "Cassandra DB is up!"

echo "\n3. Removing the used container for the initialisation process"
sudo docker rm demo-db-init

echo "\n4. Starting the rest of the core network"
sudo docker-compose up -d oai_spgwu

echo "\n5. Checking the status of the docker container"
sudo docker ps -a