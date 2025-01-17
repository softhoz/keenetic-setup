#!/bin/sh

# Create storage directory
mkdir -p /storage/install

# Download installer
cd /storage/install
wget https://bin.entware.net/aarch64-k3.10/installer/aarch64-installer.tar.gz

# Extract and run installer
tar -xzvf aarch64-installer.tar.gz
./installer/install

# Install dependencies
opkg update
opkg install ca-certificates wget-ssl
opkg remove wget-nossl

# Configure NFQWS repository
mkdir -p /opt/etc/opkg
echo "src/gz nfqws-keenetic https://anonym-tsk.github.io/nfqws-keenetic/aarch64" >/opt/etc/opkg/nfqws-keenetic.conf

# Install NFQWS
opkg update
opkg install nfqws-keenetic

# Install web interface (optional)
opkg install nfqws-keenetic-web
