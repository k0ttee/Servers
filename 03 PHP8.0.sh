##########################
# добавление и установка #
##########################

apt install software-properties-common
add-apt-repository ppa:ondrej/php
apt update

#################### поставятся php-common php8.0-cli php8.0-common php8.0-fpm php8.0-opcache php8.0-readline

apt install php8.0-fpm

#################### модули (многобайтовые строки, постгрес, работа с графикой)

apt install php8.0-mbstring
apt install php8.0-gd






#################
# настройка fpm #
#################

/etc/php/8.0/fpm/pool.d/www.conf

################################################### количество процессов по ядрам и памяти

listen                 = /run/php/php8.0-fpm.sock
listen.owner           = www-data
listen.group           = www-data
listen.allowed_clients = 127.0.0.1
#
pm                   = dynamic
pm.max_children      = 30
pm.start_servers     = 4
pm.min_spare_servers = 4
pm.max_spare_servers = 10
#
pm.max_requests = 500
#
php_admin_flag[display_errors] = off
php_admin_flag[log_errors]     = off
php_admin_value[memory_limit]  = 32M

########################################################################## применить

systemctl restart php8.0-fpm






#################
# настройка ini #
#################

########################################################################## направление сессий в оперативку

echo 'session.cookie_lifetime = 0' >> /etc/php/8.0/fpm/php.ini
echo 'session.use_cookies = On' >> /etc/php/8.0/fpm/php.ini
echo 'session.use_only_cookies = On' >> /etc/php/8.0/fpm/php.ini
echo 'session.use_strict_mode = On' >> /etc/php/8.0/fpm/php.ini
echo 'session.cookie_httponly = On' >> /etc/php/8.0/fpm/php.ini
echo 'session.cookie_secure = On' >> /etc/php/8.0/fpm/php.ini
echo 'session.cookie_samesite = "SameSite"' >> /etc/php/8.0/fpm/php.ini
echo 'session.use_trans_sid = Off' >> /etc/php/8.0/fpm/php.ini
echo 'session.sid_length = 128' >> /etc/php/8.0/fpm/php.ini
echo 'session.sid_bits_per_character = 6' >> /etc/php/8.0/fpm/php.ini
echo 'session.hash_function = "sha256"' >> /etc/php/8.0/fpm/php.ini
echo 'session.save_path = "/sessions"' >> /etc/php/8.0/fpm/php.ini

########################################################################## применить

systemctl restart php8.0-fpm

########################################################################## удалить старые сессии

rm /var/lib/php/sessions/*
