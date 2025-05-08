#!/bin/sh

set -e

# @todo Echo what are we doing here 
echo -e "\n\033[1;32m=== Initializing MariaDB Database ===\033[0m\n"

# Ensure MariaDB runtime directory exists (required for MariaDB socket)
echo "Creating MariaDB runtime directory (/run/mysqld) if it doesn't exist..."
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chmod 755 /run/mysqld

echo "Initializing MariaDB data directory..."
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Start MariaDB daemon and wait until it's ready to accept connections
echo "Starting MariaDB daemon..."
mariadbd --user=mysql --datadir=/var/lib/mysql &

# Wait until MariaDB is ready to accept connections
echo "Waiting for MariaDB to be ready..."
while ! mariadb-admin -uroot ping --silent; do
  sleep 1
done

# Set the root password only if not already set (you may want to enhance this check)
echo "Setting MariaDB root password..."
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DATABASE_ROOT_PASSWORD}';"

echo -e "\n\033[1;32m=== MariaDB Initialization Complete ===\033[0m"