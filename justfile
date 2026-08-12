set dotenv-load
set export

default:
  @just --list

init package_name="":
  bash .devcontainer/init-project.sh "{{ package_name }}"

start:
  bin/dev-compose up -d --build --wait php database redis mailpit

stop:
  bin/dev-compose stop php database redis mailpit

restart:
  just stop
  just start

ps:
  bin/dev-compose ps

logs service="php":
  bin/dev-compose logs -f {{ service }}

build:
  bin/dev-compose build php

composer +args="install":
  composer {{ args }}

require +packages:
  composer require {{ packages }}

install:
  composer install

update:
  composer update

symfony +args="":
  php bin/console {{ args }}

migrate:
  php bin/console doctrine:migrations:migrate --no-interaction

cache-clear:
  php bin/console cache:clear

test +args="":
  php -d xdebug.mode=coverage bin/phpunit {{ args }}

db-shell:
  bin/dev-compose exec database psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

redis-cli +args="":
  bin/dev-compose exec redis redis-cli {{ args }}

doctor:
  php -v
  composer --version
  just --version
  docker compose version
  bin/dev-compose config --quiet
  php bin/console about

