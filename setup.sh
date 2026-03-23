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

# Select NFQWS variant
echo ""
echo "Select NFQWS variant to install:"
echo "  1) nfqws-keenetic  (stable)"
echo "  2) nfqws2-keenetic (alternative)"
printf "Enter choice [1/2]: "
read NFQWS_VARIANT
case "$NFQWS_VARIANT" in
  2)
    NFQWS_PKG="nfqws2-keenetic"
    NFQWS_REPO_NAME="nfqws2-keenetic"
    NFQWS_REPO_URL="https://nfqws.github.io/nfqws2-keenetic/all"
    NFQWS_CONF="nfqws2-keenetic.conf"
    ;;
  *)
    NFQWS_PKG="nfqws-keenetic"
    NFQWS_REPO_NAME="nfqws-keenetic"
    NFQWS_REPO_URL="https://nfqws.github.io/nfqws-keenetic/all"
    NFQWS_CONF="nfqws-keenetic.conf"
    ;;
esac

# Configure NFQWS repository
log "Configuring NFQWS repository (${NFQWS_PKG})..."
mkdir -p /opt/etc/opkg || log "Failed to create opkg directory"
echo "src/gz ${NFQWS_REPO_NAME} ${NFQWS_REPO_URL}" >/opt/etc/opkg/${NFQWS_CONF} || log "Failed to add NFQWS repository"
echo "src/gz nfqws-keenetic-web https://nfqws.github.io/nfqws-keenetic-web/all" >/opt/etc/opkg/nfqws-keenetic-web.conf || log "Failed to add NFQWS-WEB repository"

# Install NFQWS
log "Updating package lists again..."
opkg update || log "Failed to update package lists"

log "Installing NFQWS..."
opkg install ${NFQWS_PKG} || log "Failed to install NFQWS"

# Install web interface (optional)
log "Installing NFQWS web interface..."
opkg install nfqws-keenetic-web || log "Failed to install NFQWS web interface"

# DNS Configuration
log "Configuring DNS servers..."
ndmc -c dns-proxy tls upstream 213.202.211.221 sni ns2.opennameserver.org || log "Failed to set TLS upstream 1"
ndmc -c dns-proxy tls upstream 77.88.8.8 sni common.dot.dns.yandex.net || log "Failed to set TLS upstream 2"
ndmc -c dns-proxy tls upstream 8.8.4.4 sni dns.google || log "Failed to set TLS upstream 3"

ndmc -c dns-proxy https upstream https://ns2.opennameserver.org/dns-query || log "Failed to set HTTPS upstream 1"
ndmc -c dns-proxy https upstream https://common.dot.dns.yandex.net/dns-query || log "Failed to set HTTPS upstream 2"
ndmc -c dns-proxy https upstream https://dns.google/dns-query || log "Failed to set HTTPS upstream 3"

ndmc -c system configuration save || log "Failed to save system configuration"

log "Setup complete!"
