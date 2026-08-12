# Symfony Docker Dev Container

Boilerplate for Symfony 8.1 WebApp projects using PHP 8.5, FrankenPHP,
PostgreSQL 18, Redis, Mailpit and an independent VS Code Dev Container.

The `workspace` container is deliberately separate from the `php` runtime.
It starts even when the application or its dependencies are broken. Application
files are writable only from the workspace; the runtime mounts them read-only
and writes to dedicated `var` and `vendor` volumes.

## Create a project

After publishing this repository as a Composer project package:

```bash
composer create-project damian/symfony-docker-devcontainer my-project
code my-project
```

In VS Code run `Dev Containers: Reopen in Container`. Only the workspace and
its supporting services are started; FrankenPHP is not started yet.

Inside the Dev Container:

```bash
just init
just start
```

`just init` creates `symfony/skeleton:8.1.*`, installs the `webapp` pack,
requires PHP 8.5 and keeps the boilerplate's Docker configuration intact. An
optional Composer package name can be supplied with `just init acme/my-project`.

The app is available at `https://localhost`, Mailpit at
`http://localhost:8025`, and PostgreSQL at `localhost:5432`.

## Daily commands

```bash
just require symfony/orm-pack
just symfony about
just migrate
just test
just logs
just stop
```

Run Composer and Symfony commands directly in the workspace. `just start` uses
the host Docker engine through the Dev Container and starts the runtime in the
same Compose project, so shared volumes and networking remain consistent.

## Versions

Defaults can be overridden before initialization or in `.env.local`:

```dotenv
SYMFONY_VERSION=8.1.*
POSTGRES_VERSION=18
```

The PostgreSQL 18 volume is mounted at `/var/lib/postgresql`, matching the
layout required by the official PostgreSQL 18 image.

