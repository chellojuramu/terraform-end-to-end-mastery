#!/bin/bash
set -e

apt-get update -y
apt-get install -y apache2 php php-curl libapache2-mod-php php-mysql jq

ufw allow 'Apache Full'

systemctl enable apache2
systemctl start apache2

# REMOVE default Apache page
rm -f /var/www/html/index.html

cd /var/www/html

# Save metadata
curl -s -H Metadata:true --noproxy "*" \
"http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq > metadata.json

# Download UI app
curl https://raw.githubusercontent.com/Azure/vm-scale-sets/master/terraform/terraform-tutorial/app/index.php -O

# Make PHP default
echo "DirectoryIndex index.php index.html" >> /etc/apache2/mods-enabled/dir.conf

systemctl restart apache2