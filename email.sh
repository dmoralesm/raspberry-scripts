#!/bin/bash

WORKING_DIR=$( dirname $0 )
. $WORKING_DIR/config.sh

NOTIFICATION_TYPE=$1
SUBJECT=$TR_TORRENT_NAME
MESSAGE="Download complete"

if [ "$NOTIFICATION_TYPE" == "pending_extraction" ]; then
  MESSAGE="Download complete. Extraction in progress."
elif [ "$NOTIFICATION_TYPE" == "extraction_complete" ]; then
  MESSAGE="Extraction complete"
fi


curl -s --user "api:$API_KEY" $API_URL -F from="$FROM" -F to="$TO" -F subject="$SUBJECT" -F text="$MESSAGE"
