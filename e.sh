#!/bin/bash
# encrypting archives

# inc
. ./log.sh
. ./reg.sh

log "+++ Starting session"

# conf
#
# ammount of backups in days
# last are erased before begin to enc one more
HOLD_BCKS=3
# how much new archives will stay
HOLD_ENC=1

# raw storage
BCK_DIR='/d/www/encr_bck/bck'
# enc storage
ENC_DIR='/d/www/encr_bck/enc'

# required dirs
if [[ ! -d ${BCK_DIR} ]]; then mkdir ${BCK_DIR} ; fi
if [[ ! -d ${ENC_DIR} ]]; then mkdir ${ENC_DIR} ; fi
if [[ ! -d logs ]]; then mkdir logs ; fi
if [[ ! -d reg ]]; then mkdir reg ; fi

# we only need last $HOLD_BCKS newest files in bck directory
# sorted by modified time
log "Checking for gzip's to remove"
REM_GZ_LST=$(ls -t ${BCK_DIR}/* | awk "NR>${HOLD_BCKS}")
if [[ ! -z ${REM_GZ_LST// } ]]; then
    log $'Removing...\n'"$REM_GZ_LST"
    rm -f ${REM_GZ_LST}
else
    log 'Nothing to remove.'
fi

# getting latest archive to enc
LATEST_GZIP=$(ls -t ${BCK_DIR}/* | awk 'NR==1')
LATEST_NAME=$(ls -t ${BCK_DIR} | awk 'NR==1')
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
