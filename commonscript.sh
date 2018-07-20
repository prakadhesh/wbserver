#!/bin/bash
#Ubuntu Upate
sudo su
apt-get update 
ufw disable

#Tools

apt-get install -y apache2
rm -rf /var/www/html
ln -s /vagrant/ /var/www/html
