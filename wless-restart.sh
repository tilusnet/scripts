#!/bin/sh

echo "rmmod iwlwifi..."
sudo rmmod iwlwifi 
echo "Done. Waiting 10 seconds..."
sleep 10
echo "modprobing iwlwifi..."
sudo modprobe iwlwifi
echo "Done. Good luck."
