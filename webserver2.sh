#!/bin/bash
#Ubuntu Upate
sudo su
apt-get update 
ufw disable

#Tools

apt-get install -y apache2
service apache2 start

#Simple HTML program 


cat > /var/www/html/index.html <<EOD
<html>
<h1>Hello World</h1>
<h2>WEBSERVER2</h2>
</html>
EOD

#restart Apache Servive

service apache2 restart

