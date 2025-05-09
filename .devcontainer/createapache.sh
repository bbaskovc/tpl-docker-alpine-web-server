#!/bin/sh

set -e

# Print start message for phpMyAdmin initialization
echo -e "\n\033[1;32m=== Initializing phpMyAdmin ===\033[0m\n"

PHPMYADMIN_TMP_DIR="/usr/share/webapps/phpmyadmin/tmp"

# Create the tmp directory if it doesn't exist
echo "Ensuring phpMyAdmin temp directory exists..."
mkdir -p "$PHPMYADMIN_TMP_DIR"

# Set ownership to Apache (or your web server's user, e.g., 'www-data' or 'apache')
echo "Setting ownership to web server user..."
chown -R apache:apache "$PHPMYADMIN_TMP_DIR"  # Use 'www-data:www-data' if on Debian/Ubuntu

# Set correct permissions
echo "Setting directory permissions to 700..."
chmod 700 "$PHPMYADMIN_TMP_DIR"

# Define phpMyAdmin config file path
PHPMYADMIN_CONFIG="/usr/share/webapps/phpmyadmin/config.inc.php"  # Adjust if needed

# Generate a secure 32-char blowfish secret
echo "Generating Blowfish secret..."
BLOWFISH_SECRET=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | cut -c1-32)

# Inject or replace the blowfish_secret line
if grep -q "\$cfg\['blowfish_secret'\]" "$PHPMYADMIN_CONFIG"; then
    echo "Updating existing Blowfish secret..."
    sed -i "s|\(\$cfg\['blowfish_secret'\] = \).*;|\1'${BLOWFISH_SECRET}';|" "$PHPMYADMIN_CONFIG"
else
    echo "Setting new Blowfish secret..."
    echo "\$cfg['blowfish_secret'] = '${BLOWFISH_SECRET}';" >> "$PHPMYADMIN_CONFIG"
fi

# Confirm completion
echo -e "\n\033[1;32m=== phpMyAdmin Initialization Complete ===\033[0m\n"

# Print start message for Apache initialization
echo -e "\n\033[1;32m=== Initializing Apache Server ===\033[0m\n"

# Ensure Apache runtime directory exists (required for PID files, etc.)
echo "Creating Apache runtime directory (/run/apache2) if it doesn't exist..."
mkdir -p /run/apache2

# Set Apache ServerName globally to suppress FQDN warning
echo "Setting Apache ServerName to 'localhost' to suppress FQDN warnings..."
sed -i 's|^#ServerName www.example.com:80|ServerName localhost|' /etc/apache2/httpd.conf

# Enable SSL module
echo "Enabling Apache SSL module..."
sed -i '/^#LoadModule ssl_module/s/^#//' /etc/apache2/httpd.conf
echo "LoadModule ssl_module modules/mod_ssl.so" >> /etc/apache2/httpd.conf

# Ensure Apache listens on port 443 for HTTPS
echo "Ensuring Apache listens on port ${APACHE_HTTPS_PORT}..."
grep -q "^Listen ${APACHE_HTTPS_PORT}" /etc/apache2/httpd.conf || echo "Listen ${APACHE_HTTPS_PORT}" >> /etc/apache2/httpd.conf

# Create phpMyAdmin temporary directory
echo "Creating phpMyAdmin temporary directory..."
PHPMYADMIN_TMP_DIR="/usr/share/phpmyadmin/tmp"
mkdir -p "$PHPMYADMIN_TMP_DIR"

# Generate self-signed SSL certificate if it doesn't already exist
SSL_DIR="/etc/apache2/ssl"
echo "Creating SSL directory at $SSL_DIR if not present..."
mkdir -p $SSL_DIR

if [ ! -f "$SSL_DIR/server.key" ]; then
    echo "Generating self-signed SSL certificate for Apache..."
    openssl req -x509 -nodes -days 365 \
        -subj "/C=US/ST=Dev/L=Dev/O=Dev/CN=localhost" \
        -newkey rsa:2048 \
        -keyout $SSL_DIR/server.key \
        -out $SSL_DIR/server.crt
fi

# Set ownership and permissions for phpMyAdmin tmp directory
echo "Setting ownership and permissions for phpMyAdmin temporary directory..."
chown -R apache:apache "$PHPMYADMIN_TMP_DIR"
chmod 700 "$PHPMYADMIN_TMP_DIR"

# Configure Apache to use HTTPS with the generated certificate
echo "Configuring Apache HTTPS virtual host..."
cat <<EOF > /etc/apache2/conf.d/ssl.conf
<VirtualHost *:443>
    ServerName localhost

    SSLEngine on
    SSLCertificateFile "/etc/apache2/ssl/server.crt"
    SSLCertificateKeyFile "/etc/apache2/ssl/server.key"

    DocumentRoot "/var/www/localhost/htdocs"

    <Directory "/var/www/localhost/htdocs">
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/ssl_error.log
    CustomLog /var/log/apache2/ssl_access.log combined
</VirtualHost>
EOF

# Enable Xdebug by adding it to php.ini
echo "Enabling Xdebug in php.ini..."
XDEBUG_CONF="/etc/php82/conf.d/20-xdebug.ini"

# Add xdebug configuration to php.ini if not already done
echo "zend_extension=$(find /usr/lib/php82/modules/ -name 'xdebug.so')" > "$XDEBUG_CONF"
echo "xdebug.mode=debug" >> "$XDEBUG_CONF"
echo "xdebug.start_with_request=yes" >> "$XDEBUG_CONF"
echo "xdebug.client_host=localhost" >> "$XDEBUG_CONF"
echo "xdebug.client_port=9003" >> "$XDEBUG_CONF"

# Check Apache configuration syntax
echo "Checking Apache Configuration Syntax..."
httpd -t

# Show enabled PHP modules
echo -e "\nList of enabled PHP modules:"
php82 -m

# Show loaded Apache modules (optional, helpful for debugging)
echo "List of loaded modules:"
httpd -M

# Confirm completion
echo -e "\n\033[1;32m=== Apache Initialization Complete ===\033[0m\n"
