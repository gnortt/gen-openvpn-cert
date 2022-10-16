#!/usr/bin/env bash

set -e

usage() {
    echo "Usage: $0 [output directory] [ca cn] [server cn] [dh keysize] [days]"
    exit
}

if [ "$#" -lt 5 ]; then
    usage
fi

OUT_DIR=$1
CA_CN=$2
SERVER_CN=$3
KEY_SIZE=$4
DAYS=$5

mkdir "$OUT_DIR"
OUT_DIR="$(pwd)/$OUT_DIR"

SERIAL=01
echo $SERIAL > "$OUT_DIR"/serial
touch "$OUT_DIR"/index.txt

export KEY_DIR="$OUT_DIR"
export KEY_SIZE=$KEY_SIZE

export KEY_CN="$CA_CN"
openssl req \
    -config "openssl.cnf" \
    -batch \
    -nodes \
    -x509 \
    -new \
    -sha256 \
    -days $DAYS \
    -newkey ec:<(openssl ecparam -name secp521r1) \
    -keyout "$OUT_DIR"/ca.key \
    -out "$OUT_DIR"/ca.crt

export KEY_CN="$SERVER_CN"
openssl req \
    -config "openssl.cnf" \
    -batch \
    -nodes \
    -extensions server \
    -new \
    -newkey ec:<(openssl ecparam -name secp521r1) \
    -keyout "$OUT_DIR/$SERVER_CN.key" \
    -out "$OUT_DIR/$SERVER_CN.csr"

openssl ca \
    -config "openssl.cnf" \
    -batch \
    -notext \
    -extensions server \
    -md sha256 \
    -days $DAYS \
    -in "$OUT_DIR/$SERVER_CN.csr" \
    -out "$OUT_DIR/$SERVER_CN.crt"

openssl dhparam \
    -out "$OUT_DIR/dh$KEY_SIZE.pem" $KEY_SIZE

openvpn --genkey tls-crypt "$OUT_DIR"/ta.key
openvpn --genkey tls-crypt-v2-server "$OUT_DIR"/server-tlsv2.key

chmod 0600 "$OUT_DIR"/*.key