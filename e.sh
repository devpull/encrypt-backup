#!/bin/bash
# enc

DATE=$(date +%H:%M)

# required dirs
if [[ ! -e bck ]]; then mkdir bck fi
if [[ ! -e enc ]]; then mkdir enc fi

# ammount of backups in days
# last are erased before begin to enc one more
HOLD_BCKS=3
# raw storage
BCK_FOLDER='.'


# ls -p | grep -v /



#openssl smime -encrypt -aes256 -in secret.txt -binary -outform DEM -out secret.txt.enc bckpub.pem