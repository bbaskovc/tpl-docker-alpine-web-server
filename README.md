# Docker Alpine Web Server (Apache, PHP, Xdebug and MariaDB)

This Docker setup provides a lightweight and efficient environment using Alpine Linux with Apache, PHP, Xdebug and MariaDB to run web applications. 
This template is perfect for local development or testing environments.

## Included Features

- **Apache HTTP Server**
  - Supports both HTTP (port 80) and HTTPS (port 443)
  - Configured with customizable virtual hosts and SSL support

- **PHP**
  - Based on PHP 8.2 with commonly used extensions
  - Includes `php.ini` for custom configuration

- **Xdebug**
  - Preconfigured for debugging and profiling
  - `xdebug-info.php` is included to verify setup

- **MariaDB**
  - Lightweight MySQL-compatible database
  - Initializes with default credentials and permissions
  - Data stored persistently in `/var/lib/mysql`

- **phpMyAdmin**
  - Web-based interface to manage the MariaDB instance
  - Accessible via `/phpmyadmin` path on both HTTP and HTTPS

- **Diagnostic Pages**
  - `php-info.php` to inspect PHP configuration
  - `xdebug-info.php` to verify Xdebug functionality

## License

This template is licensed under the MIT License. See the LICENSE file for more details.
