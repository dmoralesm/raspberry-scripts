#!/bin/bash

WORKING_DIR=$( dirname $0 )
cd $WORKING_DIR

COUNTRY_CODE=US
MAX_LOAD=20
SURFSHARK_CONFIG_FILE=surfshark.conf
OVPN_CONFIG_FILE=/etc/openvpn/${SURFSHARK_CONFIG_FILE}
PROTOCOL=udp
PREV_BEST_CONN_ID_STORAGE=prevbestid.txt
LOG=log.txt

SURFSHARK_CLUSTERS=https://account.surfshark.com/api/v1/server/clusters
SURFSHARK_CONFIGS=https://account.surfshark.com/api/v1/server/configurations

COUNTRY_LOCATIONS=$(curl -s $SURFSHARK_CLUSTERS \
  | jq "map(select( .countryCode == \"$COUNTRY_CODE\" )) | sort_by(.load)")

log_to_file () {
  echo `date +"%Y-%m-%d %T"` $1 >> $LOG
}

# Load previous connection id, if exists
if [ -f "$PREV_BEST_CONN_ID_STORAGE" ]; then
  PREV_BEST_CONN_ID=$(cat $PREV_BEST_CONN_ID_STORAGE)
  PREV_CONNECTION=$(echo $COUNTRY_LOCATIONS | jq ".[] | select( .id == \"$PREV_BEST_CONN_ID\" )")
  PREV_CONN_NAME=$(echo $PREV_CONNECTION | jq -r '.connectionName')
  PREV_CONN_LOAD=$(echo $PREV_CONNECTION | jq -r '.load')

  if [ "$PREV_CONN_LOAD" -lt "$MAX_LOAD" ]; then
    echo "Current load is $PREV_CONN_LOAD and is less than $MAX_LOAD. No changes."
    exit 0;
  else
    log_msg_disconnect="Disconnect from $PREV_CONN_NAME. Load $PREV_CONN_LOAD."
    echo $log_msg_disconnect; log_to_file "$log_msg_disconnect"
  fi
fi

# Get new configuration file
BEST_CONNECTION=$(echo $COUNTRY_LOCATIONS |
  jq "map(select( .countryCode == \"$COUNTRY_CODE\" )) | sort_by(.load) | .[0]")

BEST_CONN_ID=$(echo $BEST_CONNECTION | jq -r '.id')
BEST_CONN_NAME=$(echo $BEST_CONNECTION | jq -r '.connectionName')
BEST_CONN_LOAD=$(echo $BEST_CONNECTION | jq -r '.load')

echo "Update Surfshark configuration..."

wget --quiet -O $SURFSHARK_CONFIG_FILE "$SURFSHARK_CONFIGS/$BEST_CONN_ID/$PROTOCOL"

# echo "$SURFSHARK_CONFIGS/$BEST_CONN_ID/$PROTOCOL"

echo "Replace OpenVPN configuration..."
cp --verbose $SURFSHARK_CONFIG_FILE $OVPN_CONFIG_FILE
sed -i 's/auth-user-pass/auth-user-pass login/g' $OVPN_CONFIG_FILE

echo "Restarting OpenVPN..."
service openvpn restart

log_msg_connect="Connect to $BEST_CONN_NAME. Load $BEST_CONN_LOAD."
echo $log_msg_connect; log_to_file "$log_msg_connect"

# Store current connection id
echo $BEST_CONN_ID > $PREV_BEST_CONN_ID_STORAGE;
