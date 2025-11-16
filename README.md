# Laravel Full-Stack Environment (LEMP via Docker Compose)

This repository provides a portable, stable, and complete development environment for any **Laravel** application using Docker Compose. It serves as a modern alternative to traditional local servers (like XAMPP).

## Stack Components

| Service | Version | Role |
| :--- | :--- | :--- |
| **Web Server** | Nginx:stable-alpine | Handles traffic and acts as the Reverse Proxy. |
| **Application** | PHP:8.4-FPM | Executes Laravel code (includes Composer and necessary extensions). |
| **Database** | MariaDB:11.4 | Provides persistent, robust data storage. |
| **Management** | phpMyAdmin:latest | Graphical interface for database management. |

---

## Getting Started

### Prerequisites

Ensure the following tools are installed and running on your host machine:

* **Docker Engine** & **Docker Compose**
* **Git** (for cloning this repository)

### Installation Steps

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Pashinoh/php-mysql-docker.git
    ```

2.  **Add Laravel Code:** Place your Laravel application files inside the **`src/`** directory.

3.  **Deploy the Stack:** Run the following command to build the custom PHP image and start all services:
    ```bash
    docker compose up -d --build
    ```

4.  **Finalize Setup (Composer):** Execute commands inside the running PHP container:
    ```bash
    docker exec -it app-php /bin/sh
    composer install
    php artisan key:generate
    exit
    ```
    *(Remember to update the database credentials in `src/.env` to match the `docker-compose.yml` file!)*

---

## Access & Usage

| Service | Access URL | Default Port |
| :--- | :--- | :--- |
| **Laravel App** | `http://localhost` | `80` |
| **phpMyAdmin** | `http://localhost:8080` | `8080` |

---