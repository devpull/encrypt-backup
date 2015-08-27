#!/bin/bash
function log() {

    DATE=$(date +%d%m%Y)
    DTIME=$(date +%d.%m.%Y[%H:%M])

    echo "${DTIME} - $1" >> "./logs/${DATE}.log"
}