#!/bin/bash
# enc

. ./log.sh

DATE=$(date +%d%m%Y)

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

# we only need last 3 newest files in bck directory
# sorted by modified time
log "Checking for gzip's to remove"
    REM_GZ_LST=$(ls -t $PWD/bck/* | awk 'NR>3')
echo $REM_GZ_LST
if [[ ! -z ${REM_GZ_LST// } ]]; then
    echo "Removing..."
    log "Removing..."
    log "${REM_GZ_LST}"
    rm -f ${REM_GZ_LST}
else
    echo 'Nothing to remove.'
    log 'Nothing to remove.'
fi
#rm -f $(ls -t $PWD/bck/* | awk 'NR>3')

# getting latest archive to enc
LATEST_GZIP=$(ls -t $PWD/bck/* | awk 'NR==1')
#echo $LATEST_GZIP


#openssl smime -encrypt -aes256 -in secret.txt -binary -outform DEM -out secret.txt.enc bckpub.pem

