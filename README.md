# Laravel LEMP Docker

A minimal Docker setup for running Laravel using Nginx, PHP-FPM, and MariaDB.

## Usage
Clone the repo:
```bash
git clone https://github.com/Pashinoh/lemp-laravel.git
```

Place your Laravel project inside `src/`.

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
```env
DB_HOST=db
DB_DATABASE=my_laravel_db
DB_USERNAME=my_laravel_user
DB_PASSWORD=my_strong_db_password
```

## Access
Laravel: http://localhost:8081  
MariaDB: port 3306  
phpMyAdmin: http://localhost:8080  

## License
MIT License — see LICENSE.
