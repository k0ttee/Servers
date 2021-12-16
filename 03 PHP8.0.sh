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
