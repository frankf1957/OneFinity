#!/bin/bash


GAS_LIMIT=25000000
PROXY="https://gateway.validators.onefinity.network"

NODES=1
VALUE=$(echo "2500 * $NODES * 10^18" | bc)


mxpy validator stake \
  --pem=walletKey.pem \
  --value=${VALUE} \
  --validators-file=validator.json \
  --proxy=${PROXY} \
  --gas-limit=${GAS_LIMIT} \
  --recall-nonce \
  --send

