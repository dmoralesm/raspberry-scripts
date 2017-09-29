#!/bin/bash

TORRENT_PATH=$TR_TORRENT_DIR/$TR_TORRENT_NAME
EXTRACT_FOLDER=extracted
EXTRACTED_LIST=.extractedlist

# Exit extraction if TORRENT_PATH is not a directory
if [ ! -d "$TORRENT_PATH" ]
then
  echo "$TORRENT_PATH is not a directory"
  exit 0
fi

cd "$TORRENT_PATH"

# If the TORRENT_PATH contains a file called .noextract
# is because I created the file manually to skip the extraction
if [ -f ".noextract" ]
then
  echo "Skipped torrent"
  exit 0
fi

find -name "*.rar" -not -path "./$EXTRACT_FOLDER/*" | while read rar_file; do
  # Skip the extraction of a file previously extracted
  FILE_WAS_EXTRACTED=$( grep -sR "$rar_file" $EXTRACTED_LIST )
  if [ $FILE_WAS_EXTRACTED ]
  then
    echo "Skip $rar_file"
    continue
  fi

  CONTAINER_FOLDER=$(dirname "$rar_file")
  DESTINATION_FOLDER=$EXTRACT_FOLDER/$CONTAINER_FOLDER

  echo "Extracting $rar_file"
  mkdir -p "$DESTINATION_FOLDER"

  if unrar e -y "$rar_file" "$DESTINATION_FOLDER"; then
    echo $rar_file >> $EXTRACTED_LIST
  fi

done
