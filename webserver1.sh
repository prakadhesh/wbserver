#!/bin/bash
#Ubuntu Upate
sudo su
apt-get update 
ufw disable

#Tools

apt-get install -y apache2
service apache2 start

#Simple HTML program 


cat > /var/www/html/index.html << EOF
<html>
<h1>Hello World</h1>
<p>Hostname is $(hostname)</p>
</html>
EOF

#restart Apache Servive

service apache2 restart

