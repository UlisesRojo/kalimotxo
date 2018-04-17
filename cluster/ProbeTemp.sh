#!/bin/bash
# USAGE: bash ProbeTemp.sh <log file>
# A bash utility for recording the 'System Temperature' of nodes in a cluster.
# Creates a log file containing the node names, date, time, and temperature
# reading in deg C. This file can then be sorted and processed for plotting.

function sense () {
    local hosts=$1
    local sensor=$2
    ipmi-sensors --no-header-output --no-sensor-type-output --comma-separated-output --quiet-cache -r $sensor -h $hosts -u ADMIN -p ADMIN
}

OUTPUT=$1

LIST_FATS=$(nodeset -f < /usr/cia-7.0/config/node_groups/FATS)
LIST_HEXAS=$(nodeset -f < /usr/cia-7.0/config/node_groups/HEXAS)

TFATS=$(sense i${LIST_FATS} 272 | awk -F'[:,]' '{print strftime("%Y-%m-%d  %H:%M")"  "$4"  "$1}' | sed 's/i//g' | sort --version-sort -k4)
THEXAS=$(sense i${LIST_HEXAS} 4 | awk -F'[:,]' '{print strftime("%Y-%m-%d  %H:%M")"  "$4"  "$1}' | sed 's/i//g' | sort --version-sort -k4)

printf "$TFATS\n$THEXAS\n" >> $OUTPUT
