# gen-openvpn-cert

Self-signed openvpn TLS certificate generator script. Quickly generate a certificate authority, server TLS key and certificate, and one or more client TLS keys and certificates.

# Requirements

Required dependencies:

- openvpn
- openssl

# Usage

`gen-server-cert.sh` needs a number of positional arguments:

```
    Usage: ./gen-server-cert.sh [output directory] [ca cn] [server cn] [keysize] [days]

    > ./gen-server-cert.sh example rootCA example.com 2048 365
    > ls example

    01.pem  ca.key      example.com.crt  example.com.key  index.txt.attr  serial      ta.key
    ca.crt  dh2048.pem  example.com.csr  index.txt        index.txt.old   serial.old
```

After creating a certificate authority and server TLS key and certificate, create client TLS keys and certificates using `gen-client-cert.sh`: 

```
    Usage: ./gen-client-cert.sh [server directory] [output directory] [client cn] [keysize] [days]

    > ./gen-client-cert.sh example client01 client01 2048 365
    > ls client01

    client01.crt  client01.csr  client01.key    
```