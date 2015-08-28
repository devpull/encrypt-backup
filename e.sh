#!/bin/bash
# encrypting archives

# inc
. ./log.sh
. ./reg.sh
. ./conf.sh

log "+++ Starting session"

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
    log "Nothing to remove in bck: ${BCK_DIR}"
fi

# clearing stored enc'ted files
log "Checking for .enc to remove"
if [[ ${HOLD_ENC} -le 1 ]]; then
    log "Storing one enc, so clearing enc dir: ${ENC_DIR}/"
    rm -f ${ENC_DIR}/*
else
    REM_ENC_LST=$(ls -t ${ENC_DIR}/* | awk "NR>${HOLD_ENC}")
    if [[ ! -z ${REM_ENC_LST// } ]]; then
        log $'Removing...\n'"$REM_ENC_LST"
        rm -f ${REM_ENC_LST}
    else
        log "Nothing to remove in enc: ${ENC_DIR}"
    fi
fi

# getting latest archive to enc
LATEST_GZIP=$(ls -t ${BCK_DIR}/* | awk 'NR==1')
LATEST_NAME=$(ls -t ${BCK_DIR} | awk 'NR==1')
log "Latest - ${LATEST_NAME}"

# check if archive is present in archiving registry(reg.lst)
if [[ -f ./reg/reg.lst ]]; then
    REG_CHECK=$(grep "$LATEST_NAME" ./reg/reg.lst)
else
    touch ./reg/reg.lst
fi
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
