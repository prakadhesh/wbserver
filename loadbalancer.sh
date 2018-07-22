#!/bin/bash

#Admin Rights

sudo su

#HAPROXY 1.8 Installtion Steps

apt-get install software-properties-common -y
add-apt-repository ppa:vbernat/haproxy-1.8 -y

#Ubuntu Update

apt-get update -y

apt-cache policy haproxy
apt-get install  haproxy -y

#Startup Enabled

cat > /etc/default/haproxy << EOF
ENABLED=1
EOF

cat > /etc/haproxy/haproxy.cfg << EOF
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # Default ciphers to use on SSL-enabled listening sockets.
        # For more information, see ciphers(1SSL). This list is from:
        #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
        # An alternative list with additional directives can be obtained from
        #  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
        ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
        ssl-default-bind-options no-sslv3

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
#       errorfile 400 /etc/haproxy/errors/400.http
#       errorfile 403 /etc/haproxy/errors/403.http
#       errorfile 408 /etc/haproxy/errors/408.http
#       errorfile 500 /etc/haproxy/errors/500.http
#       errorfile 502 /etc/haproxy/errors/502.http
#       errorfile 503 /etc/haproxy/errors/503.http
#       errorfile 504 /etc/haproxy/errors/504.http

frontend http_front
   bind *:8082
   option forwardfor
   stats uri /haproxy?stats
   default_backend http_back

backend http_back
   balance roundrobin
   cookie SERVERID insert indirect nocache
   server webserver1 192.168.10.2:80 check cookie webserver1
   server webserver2 192.168.10.3:80 check cookie webserver2
  # server webserver1 192.168.10.2:80 check
  # server webserver2 192.168.10.3:80 check
   option httpchk

EOF
