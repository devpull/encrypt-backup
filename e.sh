#!/bin/bash
# encrypting archives

# inc
. ./log.sh
. ./reg.sh

log "+++ Starting session"

DATE=$(date +%d%m%Y)

# required dirs
if [[ ! -d bck ]]; then mkdir bck ; fi
if [[ ! -d enc ]]; then mkdir enc ; fi
if [[ ! -d logs ]]; then mkdir logs ; fi
if [[ ! -d reg ]]; then mkdir reg ; fi

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
if [[ ! -z ${REM_GZ_LST// } ]]; then
    log $'Removing...\n'"$REM_GZ_LST"
    rm -f ${REM_GZ_LST}
else
    log 'Nothing to remove.'
fi

# getting latest archive to enc
LATEST_GZIP=$(ls -t $PWD/bck/* | awk 'NR==1')
LATEST_NAME=$(ls -t ./bck | awk 'NR==1')
log "Latest - ${LATEST_NAME}"

# check if archive is present in archiving registry(reg.lst)
REG_CHECK=$(grep "$LATEST_NAME" ./reg/reg.lst)
if [[ ! -z ${REG_CHECK// } ]]; then
    log "Already enc'ted ${LATEST_NAME}. Exiting."
    log "--- Ending session"
    exit 0
fi

# enc
log "Starting to enc $LATEST_NAME"
openssl smime -encrypt -aes256 -in ${LATEST_GZIP} -binary -outform DEM -out ./enc/${LATEST_NAME}.enc bckpub.pem
log "${LATEST_NAME} encted successfuly."

reg "$LATEST_NAME"
log "--- Ending session"
