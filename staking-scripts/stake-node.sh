#!/bin/bash


PROXY="https://gateway.validators.onefinity.network"

NODES=1

# stake amount for each individual node - 2500 $ONE x the number of nodes
VALUE=$(echo "2500 * $NODES * 10^18" | bc)

# gas limit of 6,000,000 gas units x the number of nodes
GAS_LIMIT=$(echo "6 * 10^6 * $NODES" | bc)


mxpy validator stake \
  --pem=walletKey.pem \
  --value=${VALUE} \
  --validators-file=validator.json \
  --proxy=${PROXY} \
  --gas-limit=${GAS_LIMIT} \
  --recall-nonce \
  --send

