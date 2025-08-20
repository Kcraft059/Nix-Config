#!/bin/bash
export RELPATH=$(dirname $0)/../..;
if which menubar;then
  menubar=$(which menubar)
else
  menubar=$RELPATH/menubar
fi
$menubar -s "$NAME"