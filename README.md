# Laravel LEMP Docker

A minimal Docker setup for running Laravel using Nginx, PHP-FPM, and MariaDB.

## Usage
Clone the repo:
```bash
git clone https://github.com/Pashinoh/lemp-laravel.git
```
Put your Laravel project inside `src/`.

Start the stack:
```bash
docker compose up -d --build
```
Install Laravel dependencies:
```bash
docker exec -it app-php sh
composer install
php artisan key:generate
exit
```

## Database
Set your `.env` to match:
```yaml
MARIADB_ROOT_PASSWORD: password
MARIADB_DATABASE: app
MARIADB_USER: user
MARIADB_PASSWORD: password
```

## Access
Laravel: http://localhost  
MariaDB: port 3306  
phpMyAdmin (if enabled): http://localhost:8080  

## License
MIT License — see LICENSE.
