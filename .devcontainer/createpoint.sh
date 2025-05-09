#!/bin/sh

set -e

# Print environment variables for debugging and verification
echo -e "\n\033[1;32m=== Container Environment Variables ===\033[0m"
env

# Print versions of key installed packages
echo -e "\n\033[1;32m=== Installed Package Versions ===\033[0m"
echo -e "\033[1;36mApache:\033[0m $(httpd -v | head -n 1)"
echo -e "\033[1;36mPHP:\033[0m $(php82 -v | head -n 1)"
echo -e "\033[1;36mCurl:\033[0m $(curl --version | head -n 1)"
echo -e "\033[1;36mMariaDB:\033[0m $(mariadb --version | head -n 1)"


# Set executable permission and run database initialization script
chmod +x .devcontainer/createdb.sh
./.devcontainer/createdb.sh

# Set executable permission and configure Apache server
chmod +x .devcontainer/createapache.sh
./.devcontainer/createapache.sh