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

/etc/nginx/nginx.conf

