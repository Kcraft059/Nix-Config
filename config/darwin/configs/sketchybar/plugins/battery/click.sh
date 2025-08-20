#!/bin/bash
export RELPATH=$(dirname $0)/../..;

if [ $BUTTON = "right" ]; then 
  $RELPATH/menubar -s "Control Center,Battery"
else 
  $RELPATH/menubar -s "Battery Toolkit,Item-0"
fi
