[[ -z "$PS1" ]] && return
[[ -f /etc/bashrc ]] && source /etc/bashrc

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

bind "set mark-symlinked-directories on"
bind "set visible-stats on"

if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
  source /etc/bash_completion
fi

alias l1='ls --color --classify --human-readable -1'
alias lg='ls --color --classify --human-readable -g --no-group'
alias ll='ls --color --classify --human-readable -l --all'
alias lS='ls --color --classify --human-readable -1S --almost-all --group-directories-first --size'
alias lt='ls --color --classify --human-readable -lt --reverse --almost-all'
alias lu='ls --color --classify --human-readable -ltu --reverse --almost-all'

alias glances='glances --theme-white'
alias iowatch='watch -n 1 iostat -xy --human 1 1'
alias ipa='ip -c a'
alias lsblk='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias lsports='lsof -i -P -n'
alias proc='ps -e --forest -o pid,ppid,user,time,cmd'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias sync='rsync -a --info=progress2'
alias scp='rsync -va'
alias timestamp='date +%F_%T | tr -d ":-" | tr "_" "-"'

cheat() { curl -s "cheat.sh/$1?style=vs"; }
tardir() { tar -czf "${1%/}".tar.gz "$1"; }

PS1="[\[\e[38;5;166m\]\u\[\e[0;0m\]@\[\e[38;5;33m\]\h\[\e[0;0m\]:\[\e[38;5;160m\]\W\[\e[0;0m\]]# "
