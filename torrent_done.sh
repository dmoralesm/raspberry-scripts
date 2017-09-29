#!/bin/bash

WORKING_DIR=$( dirname $0 )
TORRENT_PATH=$TR_TORRENT_DIR/$TR_TORRENT_NAME
NOTIFICATION_TYPE="download_complete"

RAR_FILES=$( find "$TORRENT_PATH" -name "*.rar" )

if [ "$RAR_FILES" ]; then
  NOTIFICATION_TYPE="pending_extraction"
  $WORKING_DIR/pushover.sh $NOTIFICATION_TYPE
  $WORKING_DIR/unrar.sh
  NOTIFICATION_TYPE="extraction_complete"
fi

$WORKING_DIR/pushover.sh $NOTIFICATION_TYPE
