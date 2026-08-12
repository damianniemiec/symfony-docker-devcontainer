#!/bin/sh
set -eu

mkdir -p /app/var /app/vendor
chown -R nonroot:nonroot /app/var /app/vendor 2>/dev/null || true
chmod -R ug+rwX /app/var /app/vendor 2>/dev/null || true

exec "$@"

