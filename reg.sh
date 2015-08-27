#!/bin/bash

function reg() {

    DATE=$(date +%d%m%Y)
    DTIME=$(date +%d.%m.%Y[%H:%M])

    echo "${DTIME} - $1" >> "./reg/reg.lst"
}