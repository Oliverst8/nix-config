# Attic cache on the Pi

Attic runs in Docker on `starpi` and is reachable only inside the tailnet at
`http://starpi.tailc0008.ts.net:47219` (plain HTTP inside Tailscale's encrypted tunnel;
`tailscale serve` stalls on large uploads, so there is no proxy). No secrets live in this repo; they are
generated on the Pi.

| Port | Where | Purpose |
|---|---|---|
| 47219 | the Pi's Tailscale address (`100.100.168.5`) only | Attic, for hosts and CI |

## Part A: server

### 1. Tailscale admin console

1. **DNS**: enable MagicDNS.
2. **Access controls**: add the tag and the grant.

   ```jsonc
   "tagOwners": { "tag:ci": ["autogroup:admin"] },

   "grants": [
     // CI runner: cache port on the Pi, nothing else
     { "src": ["tag:ci"], "dst": ["100.100.168.5"], "ip": ["tcp:47219"] }
   ],

   "tests": [
     {
       "src": "tag:ci",
       "accept": ["100.100.168.5:47219"],
       "deny": ["100.100.168.5:443", "100.100.168.5:22", "100.95.20.83:22"]
     }
   ]
   ```

3. **Check every other rule's `src`.** The default policy has a rule with
   `"src": ["*"]`, which would give the CI runner the whole tailnet. Change it to
   `["autogroup:member", "tag:<desktop's tag>"]`. `desktop` is a tagged device, so
   its tag (shown on the Machines page) must be listed or it loses access. If the
   policy is already customised, only confirm that no rule has `*` or `tag:ci` as
   source. Saving fails if the test above does not hold, which is the proof.
4. **Settings → Trust credentials → Credential → OpenID Connect**
   - Issuer: GitHub
   - Subject: `repo:Oliverst8/nix-config:ref:refs/heads/main`
   - Scope: `auth_keys` (write), tag `tag:ci`
   - Note the **Client ID** and **Audience**.

### 2. Files on the Pi

Replace `/mnt/sda1` with the external disk's mount point.

```sh
ss -tln | grep -E ':47219\b'   # no output = port free

# lets Docker bind the Tailscale address before Tailscale is up at boot
echo 'net.ipv4.ip_nonlocal_bind = 1' | sudo tee /etc/sysctl.d/99-attic-nonlocal-bind.conf
sudo sysctl --system >/dev/null

sudo install -d -m 700 -o "$USER" /mnt/sda1/attic
sudo install -d -m 700 -o 10001 -g 10001 /mnt/sda1/attic/storage
sudo install -d -m 700 /mnt/sda1/attic/postgres
cd /mnt/sda1/attic

PGPASS=$(openssl rand -hex 24)
sudo tee .env >/dev/null <<EOF
POSTGRES_PASSWORD=$PGPASS
ATTIC_SERVER_DATABASE_URL=postgres://attic:$PGPASS@db/attic
ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=$(openssl genrsa -traditional 4096 | base64 -w0)
EOF
sudo chmod 600 .env; unset PGPASS

sudo tee server.toml >/dev/null <<'EOF'
listen = "[::]:8080"
allowed-hosts = ["starpi.tailc0008.ts.net", "starpi.tailc0008.ts.net:47219"]
api-endpoint = "http://starpi.tailc0008.ts.net:47219/"

[database]

[storage]
type = "local"
path = "/storage"

[chunking]
nar-size-threshold = 65536
# large chunks: the USB disk syncs slowly, so fewer writes per upload
min-size = 262144
avg-size = 1048576
max-size = 4194304

[compression]
type = "zstd"

[garbage-collection]
interval = "12 hours"
default-retention-period = "30 days"
EOF

sudo tee compose.yaml >/dev/null <<'EOF'
services:
  db:
    image: postgres:17
    # don't wait for the slow disk on every commit; safe for a cache
    command: ["postgres", "-c", "synchronous_commit=off"]
    restart: unless-stopped
    environment:
      POSTGRES_USER: attic
      POSTGRES_DB: attic
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ./postgres:/var/lib/postgresql/data
    security_opt: ["no-new-privileges:true"]
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U attic"]
      interval: 10s
      retries: 10

  attic:
    # upstream 12cbeca (2025-09-24), before the index regression
    image: ghcr.io/zhaofengli/attic@sha256:18574aba70fc89d2b695273fbe2e7b2f8ad7e8e786b4cc535124fbe14bada1d0
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
    command: ["-f", "/attic/server.toml"]
    env_file: .env
    user: "10001:10001"
    read_only: true
    cap_drop: ["ALL"]
    security_opt: ["no-new-privileges:true"]
    tmpfs: ["/tmp"]
    ports:
      - "100.100.168.5:47219:8080"
    volumes:
      - ./server.toml:/attic/server.toml:ro
      - ./storage:/storage
EOF
sudo chmod 644 server.toml
```

### 3. Start

```sh
sudo docker compose up -d
sudo docker compose logs attic | tail          # should be listening, no errors
sudo ss -tlnp | grep 47219                     # must show 100.100.168.5:47219 only
```

Never bind the port to `0.0.0.0` and never use `tailscale funnel`.

### 4. Tokens

```sh
mk() { sudo docker compose exec attic /bin/atticadm -f /attic/server.toml make-token "$@"; }

mk --sub admin   --validity '1 day'  --pull main --push main --create-cache main --configure-cache main --configure-cache-retention main
mk --sub ci      --validity '1 year' --pull main --push main
mk --sub desktop --validity '1 year' --pull main --push main
mk --sub laptop  --validity '1 year' --pull main --push main
```

Each prints a token. They are as sensitive as root on the hosts (whatever is
pushed gets signed by the cache), so keep them out of the repo and shell history.
A single token cannot be revoked; to revoke, replace
`ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64` in `.env`, restart, and reissue all.

### 5. Create the cache (from a host on the tailnet)

```sh
nix shell github:NixOS/nixpkgs/nixos-25.11#attic-client
attic login pi http://starpi.tailc0008.ts.net:47219 <admin token> --set-default
attic cache create main
attic cache configure main \
  --upstream-cache-key-name cache.nixos.org-1 \
  --upstream-cache-key-name hyprland.cachix.org-1
attic cache info main
```

Put the printed **Public Key** (`main:...`) into
`modules/nixos/programs/attic/default.nix`, replacing `main:REPLACE_WITH_PUBLIC_KEY`.

### 6. GitHub repository secrets

| Secret | Value |
|---|---|
| `TS_OAUTH_CLIENT_ID` | Client ID from step 1.4 |
| `TS_AUDIENCE` | Audience from step 1.4 |
| `ATTIC_TOKEN` | the `ci` token |

Delete the old `CACHIX_AUTH_TOKEN`.

## Part B: each host

```sh
sudo install -m 600 /dev/null /etc/nix/netrc
sudoedit /etc/nix/netrc
#   machine starpi.tailc0008.ts.net
#   password <this host's token>

attic login pi http://starpi.tailc0008.ts.net:47219 <this host's token> --set-default
```

Then `update`. Afterwards `cache-push` uploads the running system to the cache.

## Checks

```sh
# 401 without a token, 200 + "Priority: 41" with one
curl -i http://starpi.tailc0008.ts.net:47219/main/nix-cache-info
curl -i -H "Authorization: Bearer <host token>" http://starpi.tailc0008.ts.net:47219/main/nix-cache-info

# from the LAN (not the Pi itself): must be refused
curl -m 5 http://<pi-lan-ip>:47219
```

From a phone on mobile data with Tailscale off, the URL must not load.

## Disk usage

Paths not uploaded or pulled for 30 days are collected every 12 hours. Attic has
no size cap, so check now and then:

```sh
sudo du -sh /mnt/sda1/attic/storage; df -h /mnt/sda1
```

To shrink it: `attic cache configure main --retention-period '14 days'`.
