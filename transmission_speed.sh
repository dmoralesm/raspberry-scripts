#!/bin/bash

WORKING_DIR=$( dirname $0 )
. $WORKING_DIR/pushover_config.sh

TR_SUMMARY=$( transmission-remote -n $TR_USER:$TR_PASSWORD -l | grep '^Sum' )
UP_SPEED=$( awk '{print $4}' <<< $TR_SUMMARY )
DOWN_SPEED=$( awk '{print $5}' <<< $TR_SUMMARY )

echo "Upload speed: $UP_SPEED kB/s"
echo "Download speed: $DOWN_SPEED kB/s"
