##########
# конфиг #
##########

touch .hushlogin
nano .bashrc

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
