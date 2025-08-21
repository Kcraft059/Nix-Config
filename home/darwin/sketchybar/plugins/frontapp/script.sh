#!/bin/bash
export RELPATH=$(dirname $0)/../..;
source $RELPATH/icon_map.sh

if [[ -n "$INFO" ]];then
  sketchybar --set $NAME label="$INFO" icon=$(map_skappicon "$INFO")
fi