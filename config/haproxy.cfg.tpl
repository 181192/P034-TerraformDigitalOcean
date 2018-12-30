global
  log /dev/log	local0
  log /dev/log	local1 notice
  chroot /var/lib/haproxy
  stats socket /run/haproxy/admin.sock mode 660 level admin
  stats timeout 30s
  user haproxy
  group haproxy
  daemon
  maxconn 1024

  # Default SSL material locations
  ca-base /etc/ssl/certs
  crt-base /etc/ssl/private

  # Default ciphers to use on SSL-enabled listening sockets.
  # For more information, see ciphers(1SSL). This list is from:
  #  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS
  ssl-default-bind-options no-sslv3
  tune.ssl.default-dh-param 2048

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
	option forwardfor
	option http-server-close
	stats enable
	stats uri /stats
	stats realm Haproxy\ Statistics
	# Lock down statistics to authorized user only
	stats auth haproxy:haproxy!1234
	timeout connect 5000
	timeout client  10000
	timeout server  10000
	timeout check 	3000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http
	
frontend www-http
  bind *:80

  #SSL only
  redirect scheme https if !{ ssl_fc } 
  default_backend www-backend
   
frontend www-https
  # Provide a list of certs and HAProxy will resolve them all
  bind *:443 ssl crt /etc/haproxy/certs/${domain}.pem
  
  # If letsencrypt acme challenge
  acl letsencrypt-acl path_beg /.well-known/acme-challenge/
  use_backend letsencrypt-backend if letsencrypt-acl

  # Otherwise use our default backend for all nodes
  default_backend www-backend

backend www-backend
  balance roundrobin
  #Upgrade insecure requests
  redirect scheme https if !{ ssl_fc } 
  
  #Add a custom endpoint for our health check
  option httpchk HEAD /its-alive HTTP/1.0\r\nHost:\ ${domain}
  #Mark our node is down if we receive any status in the 500 range
  http-check expect ! rstatus ^5
  #Default check times
  default-server inter 3s fall 4 rise 2

  # We're using an internal network so no need to double up encryption 
  server web1 ${web1_priv_ip}:80 check
  server web2 ${web2_priv_ip}:80 check
  
  # Forward our port and protocol for the node to handle
  http-request set-header X-Forwarded-Port 443
  http-request add-header X-Forwarded-Proto https

backend letsencrypt-backend
  server letsencrypt 127.0.0.1:54321