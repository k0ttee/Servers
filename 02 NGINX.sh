#############
# установка #
#############

apt install nginx

mv /var/www/html /var/www/web
chmod 777 /var/www
chmod 777 /var/www/web

echo 'User-agent: *' >> /var/www/web/robots.txt
echo 'Disallow: /' >> /var/www/web/robots.txt






###################
# общая настройка #
###################

######################################################################## общий конфиг

/etc/nginx/nginx.conf

user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events{
        worker_connections 1024;
}
http{
        server_tokens off;
        server_name_in_redirect off;
        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 14;
        types_hash_max_size 2048;
        add_header Cache-Control "must-revalidate";
        include /etc/nginx/mime.types;
        default_type application/octet-stream;
        #SSL
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;
        #Log
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
        #Gzip
        gzip off;
        #all HTTP & HTTP_WWW → HTTPS
        server{
                listen 80;
                server_name _;
                access_log off;
                error_log off;
                return 301 https://$host$request_uri;
        }
        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}

######################################################################## частный конфиг

/etc/nginx/sites-enabled/site.ru

