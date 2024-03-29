# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return

# Source global definitions
[[ -f /etc/bashrc ]] && source /etc/bashrc

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then eval "$(dircolors -b ~/.dircolors)"; else eval "$(dircolors -b)"; fi
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# other aliases
alias iowatch='watch -n 1 iostat -xy --human 1 1'
alias ipa='ip -c a'
alias lsblk='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias lsports='lsof -i -P -n'
alias proc='ps -e --forest -o pid,ppid,user,time,cmd'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias timestamp='date +%F_%T | tr -d ":-" | tr "_" "-"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
  source /etc/bash_completion
fi

bind "set mark-symlinked-directories on"
bind "set visible-stats on"

export EDITOR=vim
export VISUAL=vim

PS1="[\[\e[38;5;166m\]\u\[\e[0;0m\]@\[\e[38;5;33m\]\h\[\e[0;0m\]:\[\e[38;5;160m\]\W\[\e[0;0m\]]# "
