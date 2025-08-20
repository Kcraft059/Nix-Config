#!/bin/bash
export RELPATH=$(dirname $0)/../..;
$RELPATH/menubar -s "$(echo "$NAME" | cut -d '.' -f 2)"