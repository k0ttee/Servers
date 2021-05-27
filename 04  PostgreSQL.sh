#############
# установка #
#############

# echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
# wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# apt update

# (libllvm10 libpq5 postgresql postgresql-12 postgresql-client-12 postgresql-client-common postgresql-common sysstat)
apt install postgresql

# (php8.0-pgsql)
apt install php8.0-pgsql






#############
# настройка #
#############

############################################################################### сложный способ шифрования пароля

echo 'password_encryption = scram-sha-256' >> /etc/postgresql/12/main/postgresql.conf

######################################################################################################## конфиги

ls /etc/postgresql-common/
ls /etc/postgresql/12/main/

########################################################################################## запуск или перезапуск

pg_ctlcluster 12 main start
systemctl restart postgresql

############################################################################### пароль для пользователя postgres

su - postgres
psql
\password postgres
#ввести пароль






#############
# PgBouncer #
#############

# (libc-ares2 libevent-2.1-7 pgbouncer)
apt install pgbouncer

################################################################################### в секцию [databases] втыкаю

echo '* = host=localhost port=5432' >> /etc/pgbouncer/pgbouncer.ini
echo 'pool_mode = transaction'      >> /etc/pgbouncer/pgbouncer.ini
echo 'max_client_conn = 1000'       >> /etc/pgbouncer/pgbouncer.ini
echo 'auth_type = md5'              >> /etc/pgbouncer/pgbouncer.ini

##########################заменить "пароль" паролем (если нужно, то и postgres заменить на своего пользователя)

echo \"postgres\" \""md5"$(echo -n 'Парольpostgres' | md5sum | awk '{print $1}')\" > /etc/pgbouncer/userlist.txt

##################################################################################### перезапуск балансировщика

service pgbouncer restart






################
# сериализация #
################

echo "default_transaction_isolation = 'serializable'" >> /etc/postgresql/12/main/postgresql.conf

########################################################################################## перезапуск постгреса

service postgresql restart






##############
# примечания #
##############

# в скриптах сменить порт с 5432 на 6432
# файлы баз там /var/lib/postgresql/12/main/
