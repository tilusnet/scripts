#!/bin/sh

WIFIMOD=iwlwifi

echo "rmmod ${WIFIMOD}..."
sudo rmmod ${WIFIMOD} 
echo "Done. Waiting 10 seconds..."
sleep 10
echo "modprobing ${WIFIMOD}..."
sudo modprobe ${WIFIMOD}
echo "Done. Good luck."
