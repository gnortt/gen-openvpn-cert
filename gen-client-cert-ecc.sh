#!/usr/bin/env bash

set -e

usage() {
    echo "Usage: $0 [server directory] [output directory] [client cn] [dh keysize] [days]"
    exit
}

if [ "$#" -lt 5 ]; then
    usage
fi

IN_DIR=$1
OUT_DIR=$2
CLIENT_CN=$3
KEY_SIZE=0
DAYS=$5

mkdir "$OUT_DIR"
OUT_DIR="$(pwd)/$OUT_DIR"

export KEY_DIR="$IN_DIR"
export KEY_SIZE=$KEY_SIZE
export KEY_CN="$CLIENT_CN"

openssl req \
    -config "openssl.cnf" \
    -batch \
    -nodes \
    -new \
    -newkey ec:<(openssl ecparam -name secp521r1) \
    -keyout "$OUT_DIR/$CLIENT_CN.key" \
    -out "$OUT_DIR/$CLIENT_CN.csr" \

openssl ca \
    -config "openssl.cnf" \
    -batch \
    -notext \
    -md sha256 \
    -days $DAYS \
    -in "$OUT_DIR/$CLIENT_CN.csr" \
    -out "$OUT_DIR/$CLIENT_CN.crt" \

openvpn \
    --tls-crypt-v2 "$IN_DIR"/server-tlsv2.key \
    --genkey tls-crypt-v2-client "$OUT_DIR/$CLIENT_CN"-tlsv2.key

chmod 0600 "$OUT_DIR"/*.key