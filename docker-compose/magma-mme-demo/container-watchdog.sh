#!/bin/bash

echo "Starting to watch over the docker container of the 4g core network"
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
sshpass -p admin42 ssh admin42@obelix.hm.edu vlc alarm.mp3