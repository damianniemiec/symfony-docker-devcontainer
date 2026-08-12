#!/usr/bin/env bash
set -Eeuo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
symfony_version="${SYMFONY_VERSION:-8.1.*}"
package_name="${1:-${PROJECT_PACKAGE:-app/$(basename "$project_root")}}"

if [[ ! -f "$project_root/.boilerplate" ]]; then
	echo "Project is already initialized or the boilerplate marker is missing."
	exit 1
fi

if [[ -e "$project_root/bin/console" ]]; then
	echo "Symfony is already installed."
	exit 1
fi

temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT

echo "Creating Symfony ${symfony_version} WebApp..."
composer create-project "symfony/skeleton:${symfony_version}" "$temporary_dir/app" \
	--prefer-dist \
	--no-interaction \
	--no-progress

# Infrastructure belongs to this boilerplate, so Flex must not generate Compose fragments.
composer --working-dir="$temporary_dir/app" config --json extra.symfony.docker false
composer --working-dir="$temporary_dir/app" require "php:^8.5" webapp \
	--no-interaction \
	--no-progress
composer --working-dir="$temporary_dir/app" config name "$package_name"

cp -a "$temporary_dir/app/." "$project_root/"

sed -i \
	-e '/^DATABASE_URL=/d' \
	-e '/^MAILER_DSN=/d' \
	-e '/^REDIS_URL=/d' \
	"$project_root/.env"

cat >> "$project_root/.env" <<'EOF'

###> docker services ###
DATABASE_URL="postgresql://app:!ChangeMe!@database:5432/app?serverVersion=18&charset=utf8"
MAILER_DSN=smtp://mailpit:1025
REDIS_URL=redis://redis:6379
###< docker services ###
EOF

rm "$project_root/.boilerplate"
mkdir -p "$project_root/var/cache" "$project_root/var/log"

echo
echo "Symfony WebApp is ready."
echo "Package: $package_name"
echo "Next: just start"

