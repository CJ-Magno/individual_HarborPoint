#!/usr/bin/env bash
set -euo pipefail

: "${MARIADB_ROOT_PASSWORD:=change-me}"
: "${ADMIN_PASSWORD:=admin}"
: "${SITE_NAME:=insights.localhost}"

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    cd /home/frappe/frappe-bench
    exec bench start
fi

echo "Creating new bench..."
bench init --skip-redis-config-generation frappe-bench --version version-15
cd frappe-bench

bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app insights /workspace
bench new-site "${SITE_NAME}" \
  --force \
  --mariadb-root-password "${MARIADB_ROOT_PASSWORD}" \
  --admin-password "${ADMIN_PASSWORD}" \
  --no-mariadb-socket

bench set-config -g server_script_enabled 1
bench --site "${SITE_NAME}" install-app insights
bench --site "${SITE_NAME}" set-config developer_mode 1
bench --site "${SITE_NAME}" set-config mute_emails 1
bench --site "${SITE_NAME}" clear-cache
bench use "${SITE_NAME}"

exec bench start
