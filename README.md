# keenetic-setup

One-shot setup script for a Keenetic router running Entware. It:

- installs [nfqws-keenetic](https://github.com/nfqws/nfqws-keenetic) (DPI bypass) + its web UI,
- optionally applies custom `nfqws.conf` / `user.list` [templates](templates/nfqws-keenetic) from this repo,
- configures encrypted DNS (DNS-over-TLS + DNS-over-HTTPS upstreams),
- optionally makes the router ignore ISP-provided DNS.

## Prerequisites

- **Entware installed** on the router (OPKG on internal storage or a USB drive).
- Connected to the **Entware shell as root** — e.g.
  `ssh root@192.168.1.1 -p 222` (default password `keenetic`),
  or `telnet 192.168.1.1` then `exec sh`.

## Quick start

Run one of these from the router's root shell.

**curl** — recommended (installs an HTTPS-capable downloader, so it works on a fresh Entware):

```sh
opkg update && opkg install curl && curl -L -o /tmp/setup.sh https://raw.githubusercontent.com/softhoz/keenetic-setup/main/setup.sh && chmod +x /tmp/setup.sh && /tmp/setup.sh
```

**wget** — if you already have an SSL-capable `wget` (i.e. `wget-ssl`):

```sh
wget -O /tmp/setup.sh https://raw.githubusercontent.com/softhoz/keenetic-setup/main/setup.sh && chmod +x /tmp/setup.sh && /tmp/setup.sh
```

> If wget prints `wget: not an http or ftp url: https://...`, your `wget` is the
> busybox build without TLS. Install the SSL version first —
> `opkg update && opkg install wget-ssl ca-certificates` — or just use the curl
> command above.

## What the script asks

1. **NFQWS variant** — `1` nfqws-keenetic (stable) or `2` nfqws2-keenetic (alternative).
2. **Apply config templates? `[Y/n]`** (stable only) — overwrites
   `/opt/etc/nfqws/nfqws.conf` and `user.list` with this repo's templates.
   - **ISP_INTERFACE source? `[T/p]`** — `T` use the template's broad multi-WAN
     list, or `P` preserve the interface auto-detected at install time.
3. **Ignore ISP DNS? `[y/N]`** — off by default; enable to resolve only via the
   configured DoT/DoH upstreams.

## Notes

- Use the **raw** URL (`raw.githubusercontent.com/.../main/setup.sh`), not the
  `github.com/.../blob/...` page — the latter returns HTML, not the script.
- The script must run as **root** (it uses `opkg` and `ndmc`).
- Re-running is safe (idempotent): already-installed packages are skipped, DNS
  upstreams are de-duplicated by KeeneticOS, and templates are simply re-applied.
- Override where templates are fetched from with `REPO_RAW_BASE`, e.g.
  `REPO_RAW_BASE=https://raw.githubusercontent.com/softhoz/keenetic-setup/main`.
```
