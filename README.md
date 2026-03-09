# LEMP Laravel

Simple Docker template for Laravel with:

- Nginx
- PHP-FPM
- MariaDB
- Optional phpMyAdmin

## Requirements

- Docker Desktop is installed and running
- Git
- PowerShell (Windows) or Bash (Linux/macOS)

## Quick Start

### 1. Clone project

```bash
git clone https://github.com/Pashinoh/lemp-laravel.git
cd lemp-laravel
```

### 2. Install and run

Windows (safe for execution policy):

```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Mode install
```

Linux/macOS:

```bash
chmod +x ./setup.sh
./setup.sh install
```

The installer will:

1. Create `src/` Laravel project (if missing)
2. Build and start containers
3. Apply runtime config
4. Run demo checks
5. Ask whether to enable phpMyAdmin

### 3. Open app

- App: `http://localhost`
- phpMyAdmin: `http://localhost:8080` (if enabled)

## Daily Commands

Windows menu:

```powershell
.\setup.ps1
```

Linux/macOS menu:

```bash
./setup.sh
```

Stop all services:

```powershell
.\setup.ps1 -Mode down
```

```bash
./setup.sh down
```

## If You Get Errors

`docker: command not found` or Docker not detected:

- Install/start Docker Desktop, then retry

`running scripts is disabled` (Windows):

- Use:
```powershell
powershell -ExecutionPolicy Bypass -File .\setup.ps1 -Mode install
```

Port already in use (`80`, `8080`, or `3306`):

- Stop conflicting service or container, then run install again

## Debug

See [GitHub Wiki](https://github.com/Pashinoh/lemp-laravel/wiki).

## GitHub Package

After each push to `main`, GitHub Actions publishes the Docker image to GHCR:

- `ghcr.io/pashinoh/lemp-laravel-app:latest`

## License

MIT, see [LICENSE](LICENSE).
