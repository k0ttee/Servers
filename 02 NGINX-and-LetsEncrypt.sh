#########
# NGINX #
#########

apt install nginx

mv /var/www/html /var/www/web
chmod 777 /var/www
chmod 777 /var/www/web

echo 'User-agent: *' >> /var/www/web/robots.txt
echo 'Disallow: /' >> /var/www/web/robots.txt






################
# общий конфиг #
################

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






##################
# частный конфиг #
##################

/etc/nginx/sites-enabled/site.ru

############################################################# заменить все site.ru своим доменом

#HTTPS_WWW → HTTPS
server {
        listen 443 ssl http2;
        server_name www.site.ru;
        access_log off;
        error_log off;
        ssl_certificate     /etc/letsencrypt/live/www.site.ru/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/www.site.ru/privkey.pem;
        return 301 https://site.ru$request_uri;
}
#HTTPS
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2 ipv6only=on;
        server_name site.ru;
        root /var/www/web;
        index index.php;
        location / {
                rewrite ^/(.*)$ /index.php;
        }
        location ~* \.(jpg|gif|png|ico|css|js|svg|txt|html|json)$ {
                try_files $uri =404;
        }
        location = /index.php {
                include snippets/fastcgi-php.conf;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:/run/php/php8.0-fpm.sock;
        }
        #ssl
        ssl on;
        ssl_certificate     /etc/letsencrypt/live/site.ru/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/site.ru/privkey.pem;
        #принуждение браузеров заходить по https
        add_header Strict-Transport-Security "max-age=1; includeSubDomains; preload";
        #браузерный кэш
        add_header Cache-Control "must-revalidate";
        #запрет кросс-ориджин кроме
        add_header 'Access-Control-Allow-Origin' 'google.com';
        #таймаут кэширования сертификата (не обязательно настраивать)
        ssl_session_cache shared:SSLCACHE:64m;
        ssl_session_timeout 24h;
        keepalive_timeout 120 120;
        keepalive_requests 128;
        #версии протоколов
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:RC4+RSA:+HIGH:+MEDIUM;
}






###############
# LetsEncrypt #
###############

apt install certbot
apt install python-certbot-nginx

######################################################################### заменить my@mail.ru и все site.ru

certbot certonly --nginx -m my@mail.ru -n -d site.ru
certbot certonly --nginx -m my@mail.ru -n -d www.site.ru

######################################################################### продление по воскресеньям в 4:30 утра

crontab -e

30 4 * * 7 certbot renew --nginx --force-renewal

########################
# удаление сертификата #
########################

certbot delete --cert-name site.ru
certbot delete --cert-name www.site.ru

#################
# чистка ключей #
#################

