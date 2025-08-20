#!/bin/bash
export RELPATH=$(dirname $0)/../..;

WIFI_PORT=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')
WIFI=$(ipconfig getsummary $WIFI_PORT | awk -F': ' '/ SSID : / {print $2}')
if [ $BUTTON = "left" ]; then 
  $RELPATH/menubar -s "Control Center,WiFi"
else 
  if [[ $WIFI != "" ]]; then 
    sudo ifconfig $WIFI_PORT down
  else 
    sudo ifconfig $WIFI_PORT up
  fi
fi