#!/bin/bash
export RELPATH=$(dirname $0)/../..;

if which menubar;then
  menubar=$(which menubar)
else
  menubar=$RELPATH/menubar
fi

if [ $BUTTON = "right" ]; then 
  $menubar -s "Control Center,Battery"
else 
  $menubar -s "Battery Toolkit,Item-0"
fi
