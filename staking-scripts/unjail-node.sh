#!/bin/bash


# Array of BLS keys to be unjailed
# Quoting is optional, commas not required at end-of-line
declare -a BLS_KEYS
BLS_KEYS=(
"10177728 ... 477f3609"
"2d0a36dd ... 0f6c1b89"
"36882474 ... 411eb782"
"388bd521 ... 8c3dad83"
)


PROXY="https://gateway.validators.onefinity.network"

NODES=1
VALUE=$(echo "2.5 * $NODES * 10^18 /1" | bc)
GAS_LIMIT=$(echo "25 * 10^6 * $NODES /1" | bc)


function do_unjail_nodes {
    KEYS="${1}"

    mxpy validator unjail \
        --pem=walletKey.pem \
        --nodes-public-keys="$KEYS" \
        --proxy=${PROXY} \
        --value $VALUE \
        --gas-limit=${GAS_LIMIT} \
        --recall-nonce \
        --send
}


# set INTERVAL to the number of seconds between successive transactions ...
INTERVAL=18


for KEY in "${BLS_KEYS[@]}"
do
    front_key=$(echo ${KEY} | head -c12)
    back_key=$(echo ${KEY} | tail -c12)
    short_key="${front_key}...${back_key}"

    printf "\n"
    printf "Time is: %s\n" "$(date)"

    # compute sleep time
    SLEEP=$(( $INTERVAL - $(date "+%s") % $INTERVAL ))
    printf "Sleep is: %s seconds\n" "$SLEEP"
    sleep ${SLEEP}

    printf "\n"
    printf "Time is: %s\n" "$(date)"

    printf "calling do_unjail_nodes() with key: \n%s\n" "${short_key}"
    do_unjail_nodes "${KEY}"
    printf "return from do_unjail_nodes().\n"
done

