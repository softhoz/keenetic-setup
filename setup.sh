#!/bin/sh

# Function to log messages
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Install dependencies
log "Updating package lists..."
opkg update || log "Failed to update package lists"

log "Installing dependencies..."
opkg install ca-certificates wget-ssl || log "Failed to install CA certificates and wget"
opkg remove wget-nossl || log "Failed to remove non-SSL wget"

# Configure NFQWS repository
log "Configuring NFQWS repository..."
mkdir -p /opt/etc/opkg || log "Failed to create opkg directory"
echo "src/gz nfqws-keenetic https://anonym-tsk.github.io/nfqws-keenetic/all" >/opt/etc/opkg/nfqws-keenetic.conf || log "Failed to add NFQWS repository"

# Install NFQWS
log "Updating package lists again..."
opkg update || log "Failed to update package lists"

log "Installing NFQWS..."
opkg install nfqws-keenetic || log "Failed to install NFQWS"

# Install web interface (optional)
log "Installing NFQWS web interface..."
opkg install nfqws-keenetic-web || log "Failed to install NFQWS web interface"

# DNS Configuration
log "Configuring DNS servers..."
ndmc -c dns-proxy tls upstream 217.160.70.42 sni ns1.opennameserver.org || log "Failed to set TLS upstream 1"
ndmc -c dns-proxy tls upstream 213.202.211.221 sni ns2.opennameserver.org || log "Failed to set TLS upstream 2"
ndmc -c dns-proxy tls upstream 81.169.136.222 sni ns3.opennameserver.org || log "Failed to set TLS upstream 3"
ndmc -c dns-proxy tls upstream 185.181.61.24 sni ns4.opennameserver.org || log "Failed to set TLS upstream 4"

ndmc -c dns-proxy https upstream https://ns1.opennameserver.org/dns-query || log "Failed to set HTTPS upstream 1"
ndmc -c dns-proxy https upstream https://ns2.opennameserver.org/dns-query || log "Failed to set HTTPS upstream 2"
ndmc -c dns-proxy https upstream https://ns3.opennameserver.org/dns-query || log "Failed to set HTTPS upstream 3"
ndmc -c dns-proxy https upstream https://ns4.opennameserver.org/dns-query || log "Failed to set HTTPS upstream 4"

ndmc -c system configuration save || log "Failed to save system configuration"

log "Setup complete!"
