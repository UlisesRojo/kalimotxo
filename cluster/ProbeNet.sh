#!/bin/bash
# USAGE: bash ProbeNet.sh <email file>
# A bash utility for testing the networking status of nodes in a cluster.
# Creates an email using a simple template that can notify users of the
# connectivity status of each node.

function servers_up () {
    local list=$1
    local status=$(clush -q -L -b -w $list -f 50 -o "-oConnectTimeout=5 -q" echo 2> /dev/null | awk -F ":" '{print $1}' | sed 's/ib//g')
    echo $status
}

function servers_down () {
    local list=$1
    local status=$(clush -q -L -b -w $list -f 50 -o "-oConnectTimeout=5 -q" echo 2>&1 > /dev/null | awk -F ":" '{print $2}' | sed 's/ib//g')
    echo $status
}

# LIST_FATS=$(nodeset -f < /usr/cia-7.0/config/node_groups/FATS)
# LIST_HEXAS=$(nodeset -f < /usr/cia-7.0/config/node_groups/HEXAS)
# FATS_UP=$(servers_up $LIST_FATS)
# HEXAS_UP=$(servers_up $LIST_HEXAS)

LIST_EN=$(nodeset -f < /usr/cia-7.0/config/node_groups/ALL)
LIST_IB=$(nodeset -f < /usr/cia-7.0/config/node_groups/ALL_IB)
EN_DOWN=$(servers_down $LIST_EN)
IB_DOWN=$(servers_down $LIST_IB)

printf $EN_DOWN > logs/EN_DOWN.txt
printf $IB_DOWN > logs/IB_DOWN.txt


