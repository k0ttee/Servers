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
