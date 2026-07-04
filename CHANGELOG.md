# Changelog

## [1.1.0] - 2026-07-05

### Added
- `docker/opcache.ini` — OPcache + JIT config for PHP 8.4
- `restart: unless-stopped` to all services in docker-compose.yml

### Changed
- PHP upgraded from `8.3` to `8.4-fpm-alpine` (Laravel 13 support)
- MariaDB upgraded from `10.11` to `11.4` (latest LTS)
- Dockerfile now uses virtual build group (`.build-deps`) to keep final image smaller
- Merged `chown` into main `RUN` layer to reduce image layers
- `docker-compose.yml` removed redundant `working_dir`
- `nginx.conf` updated to follow Laravel official config
  - `$realpath_root` instead of `$document_root`
  - `error_page 404 /index.php`
  - Added gzip, security headers, static asset caching, fastcgi tuning
  - `server_tokens off`, `charset utf-8`
  - Block dotfiles access

### Improved
- `.dockerignore` expanded to exclude `.env`, IDE files, test dirs, docker files
