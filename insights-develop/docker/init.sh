#!/usr/bin/env bash
set -euo pipefail

: "${MARIADB_ROOT_PASSWORD:=change-me}"
: "${ADMIN_PASSWORD:=admin}"
: "${SITE_NAME:=insights.localhost}"

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    cd /home/frappe/frappe-bench

    # Fix Redis URL and strip all processes except web from Procfile
    bench set-redis-socketio-host redis://redis:6379 2>/dev/null || true
    sed -i '/socketio/d' Procfile
    sed -i '/redis/d' Procfile
    sed -i '/watch/d' Procfile
    sed -i '/worker/d' Procfile
    sed -i '/schedule/d' Procfile

    # Deploy the HarborPoint page and controller
    cp /workspace/insights-develop/docker/harborpoint.html apps/frappe/frappe/www/harborpoint.html
    cp /workspace/insights-develop/docker/harborpoint.py apps/frappe/frappe/www/harborpoint.py

    exec bench start
fi

# Disable SSL for mysql client globally
echo -e "[client]\nssl=false" > /home/frappe/.my.cnf
chmod 600 /home/frappe/.my.cnf

echo "Creating new bench..."
bench init --skip-redis-config-generation frappe-bench --version version-15
cd frappe-bench

bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

sed -i '/socketio/d' ./Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile
sed -i '/worker/d' ./Procfile
sed -i '/schedule/d' ./Procfile

bench get-app --skip-assets insights https://github.com/frappe/insights --branch main

bench new-site "${SITE_NAME}" \
  --force \
  --mariadb-root-password "${MARIADB_ROOT_PASSWORD}" \
  --admin-password "${ADMIN_PASSWORD}" \
  --mariadb-user-host-login-scope='%'

bench set-config -g server_script_enabled 1
bench --site "${SITE_NAME}" install-app insights
bench --site "${SITE_NAME}" set-config developer_mode 1
bench --site "${SITE_NAME}" set-config mute_emails 1
bench --site "${SITE_NAME}" clear-cache
bench use "${SITE_NAME}"
bench --site "${SITE_NAME}" set-config home_page insights

# Deploy the HarborPoint page and controller
cp /workspace/insights-develop/docker/harborpoint.html apps/frappe/frappe/www/harborpoint.html
cp /workspace/insights-develop/docker/harborpoint.py apps/frappe/frappe/www/harborpoint.py

exec bench start
