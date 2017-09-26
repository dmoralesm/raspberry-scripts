#!/bin/bash

. pushover_config.sh

NOTIFICATION_TYPE=$1
TITLE="Download complete"
MESSAGE="$TR_TORRENT_NAME."

if [ "$NOTIFICATION_TYPE" == "pending_extraction" ]; then
  TITLE="Download complete"
  MESSAGE="$TR_TORRENT_NAME. Extraction in progress."
elif [ "$NOTIFICATION_TYPE" == "extraction_complete" ]; then
  TITLE="Extraction complete"
  MESSAGE="$TR_TORRENT_NAME."
fi

curl -X POST https://api.pushover.net/1/messages.json -d \
"token=$TOKEN&user=$USER&device=$DEVICES&title=$TITLE&message=$MESSAGE"
