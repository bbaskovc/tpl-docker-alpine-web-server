# Docker Apache, PHP, and MariaDB Setup (Alpine)

This Docker setup provides a lightweight and efficient environment using Alpine Linux with Apache, PHP, and MariaDB to run web applications. This template is perfect for local development or testing environments.

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose

## Setup

### 1. Clone the Repository

Clone this repository to your local machine:

git clone https://github.com/bbaskovc/tpl-docker-alpine-web-server.git
cd tpl-docker-alpine-web-server

### 2. Build the Docker Image

Build the Docker image using the provided Dockerfile:

docker build -t apache-php-mariadb .

### 3. Run the Docker Containers

Use Docker Compose to run the containers for Apache, PHP, and MariaDB.

docker-compose up

This command will build and start the containers, and you should be able to access the Apache server at:

- http://localhost:80 (HTTP)
- https://localhost:443 (HTTPS)

### 4. Database Setup

By default, MariaDB will be set up with the following credentials:

- User: root
- Password: root-password

You should modify the database configuration to adjust the environment variables as needed.

### 5. Accessing phpMyAdmin

To manage the MariaDB database via phpMyAdmin, visit:

- http://localhost:80/phpmyadmin/ or https://localhost:443/phpmyadmin/

Use the following credentials to log in:

- User: root
- Password: root-password

## Configuration

### Apache

Apache is configured to listen on both HTTP (port 80) and HTTPS (port 443). You can configure virtual hosts and SSL certificates in the conf.d directory.

### PHP

PHP is configured with commonly used extensions. You can customize PHP settings in the php.ini file.

### MariaDB

MariaDB is configured to run with default settings, and the database is stored in /var/lib/mysql.

## Customization

- Modify the Dockerfile to add additional PHP extensions or configure Apache and PHP.
- Update the docker-compose.yml file to add environment variables, mount volumes, or link additional services.

## Clean Up

To stop and remove the containers:

docker-compose down

This will stop and remove all containers, networks, and volumes.

## License

This template is licensed under the MIT License. See the LICENSE file for more details.
