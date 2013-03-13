#!/bin/sh

ETHMOD=r8169

echo "rmmod ${ETHMOD}..."
sudo rmmod ${ETHMOD} 
echo "Done. Waiting 10 seconds..."
sleep 10
echo "modprobing ${ETHMOD}..."
sudo modprobe ${ETHMOD}
echo "Done. Good luck."
