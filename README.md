# gen-openvpn-cert

Self-signed OpenVPN TLS certificate generator script. Quickly generate a certificate authority, server, and client keys and certificates.

Generated are `secp384r1` ECC keys, Diffie-Hellman parameters (`dh[dh keysize].pem`), OpenVPN v1 tls-crypt (`ta.key`) and tls-crypt-v2 (`[server|client]-tlsv2.key`) symmetric keys.

# Requirements

Required dependencies:

- openvpn
- openssl

# Usage

`gen-server-cert.sh` needs a number of positional arguments:

```
    Usage: ./gen-server-cert.sh [output directory] [ca cn] [server cn] [dh keysize] [days]

    > ./gen-server-cert.sh example rootCA example.com 2048 365
    > ls example

    01.pem  ca.crt  ca.key  dh2048.pem  example.com.crt  example.com.csr  example.com.key 
    index.txt  index.txt.attr  index.txt.old  serial  serial.old  server-tlsv2.key  ta.key
```

Create client keys and certificates using `gen-client-cert.sh`: 

```
    Usage: ./gen-client-cert.sh [server directory] [output directory] [client cn] [days]

    > ./gen-client-cert.sh example client01 client01 365
    > ls client01

    client01.crt  client01.csr  client01.key  client01-tlsv2.key    
```

See [dotfiles/openvpn/etc/openvpn](https://github.com/gnortt/dotfiles/tree/master/openvpn/etc/openvpn) for compatible OpenVPN server and client configs.