#!/bin/sh
set -eu

if [ "${APP_FIX_PERMISSIONS:-1}" != "1" ] || [ "$(id -u)" -ne 0 ]; then
	exit 0
fi

runtime_uid="${APP_RUNTIME_UID:-1000}"
runtime_gid="${APP_RUNTIME_GID:-1000}"
paths="${APP_WRITABLE_PATHS:-var vendor /data /config}"

for path in $paths; do
	[ -n "$path" ] || continue
	mkdir -p "$path"
	chown -R "$runtime_uid:$runtime_gid" "$path" 2>/dev/null || true
	chmod -R ug+rwX "$path" 2>/dev/null || true
done

