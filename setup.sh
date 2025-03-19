#!/bin/sh

# Install dependencies
opkg update
opkg install ca-certificates wget-ssl
opkg remove wget-nossl

# Configure NFQWS repository
mkdir -p /opt/etc/opkg
echo "src/gz nfqws-keenetic https://anonym-tsk.github.io/nfqws-keenetic/all" >/opt/etc/opkg/nfqws-keenetic.conf

# Install NFQWS
opkg update
opkg install nfqws-keenetic

# Install web interface (optional)
opkg install nfqws-keenetic-web
