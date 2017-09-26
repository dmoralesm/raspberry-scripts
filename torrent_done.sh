#!/bin/bash

SCRIPTS_FOLDER=/home/pi/raspberry-scripts
TORRENT_PATH=$TR_TORRENT_DIR/$TR_TORRENT_NAME
NOTIFICATION_TYPE="download_complete"

RAR_FILES=$( find "$TORRENT_PATH" -name "*.rar" )

if [ "$RAR_FILES" ]; then
  NOTIFICATION_TYPE="pending_extraction"
  $SCRIPTS_FOLDER/pushover.sh $NOTIFICATION_TYPE
  $SCRIPTS_FOLDER/unrar.sh
  NOTIFICATION_TYPE="extraction_complete"
fi

$SCRIPTS_FOLDER/pushover.sh $NOTIFICATION_TYPE
