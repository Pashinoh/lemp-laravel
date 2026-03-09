# LEMP Laravel (Simple)

Lightweight Laravel stack with Nginx, PHP-FPM, MariaDB, and optional phpMyAdmin.

## Requirements

- Docker Desktop
- PowerShell (Windows) or Bash (Linux/macOS)

## Install (Recommended)

Windows:

```powershell
.\setup.ps1 -Mode install
```

Linux/macOS:

```bash
chmod +x ./setup.sh
./setup.sh install
```

What it does:

1. Creates Laravel project if missing.
2. Starts containers.
3. Applies runtime config for Windows bind mounts.
4. Runs demo checks automatically.
5. Asks if phpMyAdmin should be included now.

## Daily Use

Windows menu:

```powershell
.\setup.ps1
```

Linux/macOS menu:

```bash
./setup.sh
```

Main URLs:

- App: `http://localhost`
- phpMyAdmin: `http://localhost:8080` (if enabled)

## Stop

```powershell
.\setup.ps1 -Mode down
```

```bash
./setup.sh down
```

## Debug

See wiki: `wiki/Debug-Guide.md`

## License

MIT, see `LICENSE`.
