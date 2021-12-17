###################################
# вход только по ключу без пароля #
###################################

##################################################### алиас, генерация, добавление, вход

echo 'alias myserver="ssh -i ~/.ssh/0.0.0.0 -p 22 root@0.0.0.0"' >> ~/.zshrc
ssh-keygen -N "" -f ~/.ssh/0.0.0.0
ssh-copy-id -i ~/.ssh/0.0.0.0 -p 22 root@0.0.0.0
ssh -i ~/.ssh/0.0.0.0 -p 22 root@0.0.0.0

############################################################################ конфиг ssh

/etc/ssh/sshd_config

PasswordAuthentication no
PermitRootLogin yes
ClientAliveInterval 60
ClientAliveCountMax 360
Port 22
LoginGraceTime 1m
StrictModes yes
ChallengeResponseAuthentication no
UsePAM yes
TCPKeepAlive yes
PermitUserEnvironment no
Compression no
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
SyslogFacility AUTH
LogLevel SILENT
PrintLastLog no

############################################################################ применение

systemctl restart ssh













###############
# логирование #
###############

################################################################ вообще не писать никакие логи

echo '#DISABLE ALL LOGS'                 >> /etc/rsyslog.conf
echo 'auth,authpriv.*         /dev/null' >> /etc/rsyslog.conf
echo '*.*;auth,authpriv.none  /dev/null' >> /etc/rsyslog.conf
echo 'cron.*                  /dev/null' >> /etc/rsyslog.conf
echo 'daemon.*                /dev/null' >> /etc/rsyslog.conf
echo 'kern.*                  /dev/null' >> /etc/rsyslog.conf
echo 'lpr.*                   /dev/null' >> /etc/rsyslog.conf
echo 'mail.*                  /dev/null' >> /etc/rsyslog.conf
echo 'user.*                  /dev/null' >> /etc/rsyslog.conf
echo 'mail.info               /dev/null' >> /etc/rsyslog.conf
echo 'mail.warn               /dev/null' >> /etc/rsyslog.conf
echo 'mail.err                /dev/null' >> /etc/rsyslog.conf

################################################################ применение и чистка

service rsyslog restart
rm -rf /var/log/*
