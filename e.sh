#!/bin/bash
# encrypting archives
# can process one archive at a time!


# logs & registry dirsç
if [[ ! -d logs ]]; then mkdir logs ; fi
if [[ ! -d reg ]]; then mkdir reg ; fi
# inc
. ./log.sh
. ./reg.sh
. ./conf.sh
# required dirs
if [[ ! -d ${BCK_DIR} ]]; then mkdir ${BCK_DIR} ; fi
if [[ ! -d ${ENC_DIR} ]]; then mkdir ${ENC_DIR} ; fi


log "+++ Starting session"


# bck dir
# we only need last $HOLD_BCKS newest files in bck directory
# sorted by modified time
log "Checking for gzip's to remove"
REM_GZ_LST=$(ls -t ${BCK_DIR}/*.tar.gz | awk "NR>${HOLD_BCKS}")
if [[ ! -z ${REM_GZ_LST// } ]]; then
    log $'Removing...\n'"$REM_GZ_LST"
    rm -f ${REM_GZ_LST}
else
    log "Nothing to remove in bck: ${BCK_DIR}"
fi


# enc dir
# clearing stored enc'ted archives && enc'ted keys
log "Checking for .enc archives to remove"
REM_ENC_LST=$(ls -t ${ENC_DIR}/*tar.gz.enc | awk "NR>${HOLD_ENC}")
if [[ ! -z ${REM_ENC_LST// } ]]; then
    log $'Removing...\n'"$REM_ENC_LST"
    rm -f ${REM_ENC_LST}
else
    log "Nothing to remove in enc: ${ENC_DIR}"
fi
log "Checking for .enc keys to remove"
REM_KEY_LST=$(ls -t ${ENC_DIR}/*key.enc | awk "NR>${HOLD_ENC}")
if [[ ! -z ${REM_KEY_LST// } ]]; then
    log $'Removing keys...\n'"$REM_ENC_LST"
    rm -f ${REM_KEY_LST}
else
    log "No keys to remove in enc: ${ENC_DIR}"
fi


# getting latest archive to enc
LATEST_GZIP=$(ls -t ${BCK_DIR}/* | awk 'NR==1')
LATEST_NAME=$(ls -t ${BCK_DIR} | awk 'NR==1')
if [[ ! -f $LATEST_GZIP ]]; then log "$LATEST_GZIP is not a file, exiting..." ; fi
if [[ ! -f $LATEST_NAME ]]; then log "$LATEST_NAME is not a file, exiting..." ; fi

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
# 1. gen key for archive
openssl rand -base64 32 -out ${ENC_DIR}/${LATEST_NAME}.key
# 2. enc archive with key
penssl enc -aes-256-cbc -salt -in "${LATEST_GZIP}" -out "${ENC_DIR}/${LATEST_NAME}.enc" -pass file:${ENC_DIR}/${LATEST_NAME}.key
# 3. enc key for that archive
openssl rsautl -encrypt -inkey public.pem -pubin -in "${ENC_DIR}/${LATEST_NAME}.key" -out "${ENC_DIR}/${LATEST_NAME}.key.enc"
# 4. removinng unenc'ted key
rm -f ${ENC_DIR}/${LATEST_NAME}.key
log "${LATEST_NAME} encted successfuly."

# registering latest name TODO: do with md5sum
reg "$LATEST_NAME"
log "--- Ending session"
