#!/bin/sh

# MAKE SURE AN RCLONE CONFIG IS MOUNTED
if [ ! -f /rclone.conf ]; then
    echo "/rclone.conf not found! Exiting..."
    exit 1
fi

# MAKE SURE REMOTE NAME IS DEFINED
if ! grep -q $1 /rclone.conf; then
    echo "Remote $1 not found in /rclone.conf ! Exiting..."
    exit 1
fi

# CREATE NECESSARY CONFIG FOR RCLONE
awk '{print}' /rclone.conf /cryptomator_webdav.conf > $HOME/.config/rclone/rclone.conf

# SYNC ENCRYPTED REMOTE TO LOCAL FOLDER
rclone sync $1: /import/

# MAKE SURE AN RCLONE CONFIG IS MOUNTED
if [ ! -f /import/masterkey.cryptomator ]; then
    echo "masterkey.cryptomator not found at the root of $1! Exiting..."
    exit 1
fi

# SERVE CONTENTS AND RECORD PID
java -jar /usr/bin/cryptomator.jar --bind 127.0.0.1 --port 8080 --vault export=/import --password export=$2 &
CRYPTOMATOR_PID=$!
sleep 5

# SYNC DECRYPTED CONTENTS TO EXPORT DIR
rclone sync cryptomator: /export/

# KILL CRYPTOMATOR WEBDAV SERVER AND EXIT
kill -SIGHUP $CRYPTOMATOR_PID
exit 0
