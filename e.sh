#!/bin/bash
# enc

. ./log.sh

DATE=$(date +%H:%M)

# required dirs
if [[ ! -d bck ]]; then mkdir bck ; fi
if [[ ! -d enc ]]; then mkdir enc ; fi
if [[ ! -d logs ]]; then mkdir logs ; fi

# ammount of backups in days
# last are erased before begin to enc one more
HOLD_BCKS=3
# raw storage
BCK_DIR='./bck'
ENC_DIR='./enc'


# ls -p | grep -v /



#openssl smime -encrypt -aes256 -in secret.txt -binary -outform DEM -out secret.txt.enc bckpub.pem