#################
# вход по ключу #
#################

ssh-keygen -N "" -f ~/.ssh/000.000.000.000
ssh-copy-id -i ~/.ssh/000.000.000.000 -p 22 root@000.000.000.000
ssh -i ~/.ssh/000.000.000.000 -p 22 root@000.000.000.000

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

systemctl restart ssh

##########
# конфиг #
##########

~/.bashrc

export LANG="ru_RU.UTF-8"
export EDITOR=nano
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
alias grep="grep --color=auto"
alias ls="ls -Fa --color"
alias ll="ls -l --color"
alias free="free -m"
alias reboot="systemctl reboot"
alias diskspace="df -H /"
alias diskinode="df -i /"
alias purge="sync & echo 3 > /proc/sys/vm/drop_caches"

source .bashrc

#################
# файл подкачки #
#################

fallocate -l 1024M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo 'vm.swappiness=10' >> /etc/sysctl.conf
echo 1000 > /proc/sys/vm/vfs_cache_pressure
sysctl -p
systemctl daemon-reload

######################
# рамдиск для сессий #
######################

echo 'tmpfs /sessions tmpfs noatime,nodiratime,nodev,nosuid,size=64M 0 0' >> /etc/fstab

