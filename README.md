# LEMP Laravel Docker Setup

This repository contains a Docker setup for running a Laravel project with Nginx, PHP-FPM, MySQL (MariaDB), and phpMyAdmin. It provides a simple and cross-platform solution that works on both **Linux** and **Windows** systems.

## Prerequisites

Before getting started, make sure you have the following installed:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

## Installation

1. **Clone the repository:**

    First, clone this repository to your local machine.

    ```bash
    git clone https://github.com/Pashinoh/lemp-laravel.git
    cd lemp-laravel
    ```

2. **Set up Docker Compose:**

    The repository already contains a `docker-compose.yml` file that defines the services for Nginx, PHP-FPM, MariaDB, and phpMyAdmin. No additional configuration is required.

3. **Start the Docker containers:**

    Run the following command to start all services (PHP, Nginx, MariaDB, phpMyAdmin) in the background:

    ```bash
    docker-compose up -d
    ```

4. **Install Laravel dependencies:**

    After the containers are up and running, you need to install Laravel dependencies using Composer. Run the following command:

    ```bash
    docker-compose run --rm app-php composer install
    ```

    This will install the required dependencies for the Laravel application inside the `app-php` container.

5. **Access the Laravel application:**

    Once the installation is complete, you can access your Laravel application:

    - Open your browser and go to `http://localhost` for **Linux** or `http://localhost` or `http://127.0.0.1` for **Windows**.

6. **Access phpMyAdmin:**

    You can access phpMyAdmin by navigating to `http://localhost:8080` in your browser. The default login credentials are:

    - **Username:** root
    - **Password:** root

## Stopping the Containers

To stop the containers, simply run:

```bash
docker-compose down
```

## License
MIT License — see `LICENSE`.
