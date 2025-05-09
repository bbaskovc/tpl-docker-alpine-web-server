#!/bin/sh

set -e

# Print entry point message for debugging and verification
echo -e "\n\033[1;32m=== Starting Services ===\033[0m\n"

# Start MariaDB daemon and wait until it's ready to accept connections
echo -e "Starting MariaDB Daemon..."
mariadbd --user=mysql --datadir=/var/lib/mysql &

# Wait for MariaDB to be ready
while ! mariadb-admin -uroot ping --silent; do
  sleep 1
done
echo "MariaDB started."

# Start Apache in the background
echo -e "Starting Apache Server..."
httpd -k start  
echo "Apache started."

# Display accessible URLs for Apache and phpMyAdmin
echo -e "\nList of Web Access Points:"
echo -e "\n\033[1;34mApache:\033[0m       \033[1;36mhttp://localhost:${APACHE_HTTP_PORT}\033[0m or \033[1;36mhttps://localhost:${APACHE_HTTPS_PORT}\033[0m"
echo -e "\033[1;34mphpMyAdmin:\033[0m   \033[1;36mhttp://localhost:${APACHE_HTTP_PORT}/phpmyadmin/\033[0m or \033[1;36mhttps://localhost:${APACHE_HTTPS_PORT}/phpmyadmin/\033[0m"

# Confirm completion
echo -e "\n\033[1;32m=== Services started ===\033[0m\n"
