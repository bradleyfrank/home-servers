export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
export EDITOR=vim
export VISUAL=vim
export HELPDIR=/usr/share/zsh/help
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=14"
export DIRSTACKSIZE=10                  # Max directories in auto_pushd stack
export PRE_COMMIT_COLOR=never           # Colors are incompatible with solarized-light

export LESS_TERMCAP_mb=$'\E[01;32m'     # Add colors to manpages
export LESS_TERMCAP_md=$'\E[01;32m'     # "
export LESS_TERMCAP_me=$'\E[0m'         # "
export LESS_TERMCAP_se=$'\E[0m'         # "
export LESS_TERMCAP_so=$'\E[01;47;34m'  # "
export LESS_TERMCAP_ue=$'\E[0m'         # "
export LESS_TERMCAP_us=$'\E[01;36m'     # "
export LESS=-r                          # "


alias l1='ls --color --classify --human-readable -1'
alias lg='ls --color --classify --human-readable -g --no-group'
alias ll='ls --color --classify --human-readable -l --all'
alias lS='ls --color --classify --human-readable -1S --almost-all --group-directories-first --size'
alias lt='ls --color --classify --human-readable -lt --reverse --almost-all'
alias lu='ls --color --classify --human-readable -ltu --reverse --almost-all'

alias glances='glances --theme-white'
alias help='run-help'
alias iowatch='watch -n 1 iostat -xy --human 1 1'
alias ipa='ip -c a'
alias lsblk='lsblk -o "NAME,FSTYPE,SIZE,UUID,MOUNTPOINT"'
alias lsports='lsof -i -P -n'
alias proc='ps -e --forest -o pid,ppid,user,time,cmd'
alias pubip='dig myip.opendns.com @resolver1.opendns.com'
alias rsyncp='rsync -a --info=progress2'
alias scp='rsync -va'
alias timestamp='date +%F_%T | tr -d ":-" | tr "_" "-"'


cheat() { curl -s "cheat.sh/$1?style=vs"; }
dtags() { http https://registry.hub.docker.com/v1/repositories/"$1"/tags | jq -r '.[]|.name'; }
tardir() { tar -czf "${1%/}".tar.gz "$1"; }


precmd() {
  local rc=$? _prompt="%#" _py="" _hostname="" _git=""
  local bold="%B" nobold="%b" nocolor="%f"
  local blue="%F{33}" magenta="%F{125}" green="%F{64}" red="%F{160}" cyan="%F{37}"

  if [[ -z $TMUX ]]; then \
    _hostname="${magenta}%m${nocolor}:"
  fi

  if [[ -n "$VIRTUAL_ENV" ]]; then
    _py=":${cyan}$(python --version | grep -Po '3(\.\d+)+')${nocolor}"
  fi

  if git rev-parse --git-common-dir >/dev/null 2>&1; then
    vcs_info; _git=":${green}${vcs_info_msg_0_}${nocolor}"
  fi

  case "$rc" in
    0) _prompt="${green}%#${nocolor}"   ;;
    1) _prompt="${red}%#${nocolor}"     ;;
    *) _prompt="${magenta}%#${nocolor}" ;;
  esac

  PS1="[${bold}${_hostname}${blue}%1~${nocolor}${_git}]${_prompt}${nobold} "
}

zstyle ':vcs_info:git*' actionformats "%u%c%m|%a"
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' formats "%u%c%m"
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:git*' unstagedstr '*'


zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'         # Case insensitive tab completion
zstyle ':completion:*' completer _expand_alias _complete _ignored # Expand aliases with tab
zstyle ':completion:*' menu select                 # Use menu selection for completion
zstyle ':completion:*' list-suffixes               # Show ambiguous components for partial pathnames
zstyle ':completion:*' rehash true                 # Auto find new executables in path
zstyle ':completion:*' accept-exact '*(N)'         # Speed up completions
zstyle ':completion:*' use-cache on                # "
zstyle ':completion:*' cache-path ~/.zsh/cache     # "

WORDCHARS=${WORDCHARS//\/[&;]}                     # Don't consider these part of the word
CORRECT_IGNORE_FILE='[_|.]*'                       # Skip correcting commands matching pattern
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=5000


setopt appendhistory           # Immediately append history instead of overwriting
setopt auto_pushd              # Push directories onto stack
setopt autocd                  # Change directory without `cd`
setopt correct                 # Auto correct mistakes
setopt extended_history        # Save each commands beginning timestamp and the duration
setopt extendedglob            # Extended globbing. Allows using regular expressions with *
setopt hist_verify             # Confirm commands from history expansion
setopt histignorealldups       # If a new command is a duplicate, remove the older one
setopt inc_append_history_time # Time taken by the command is recorded correctly in the history file
setopt nobeep                  # No beep
setopt nocaseglob              # Case insensitive globbing
setopt numericglobsort         # Sort filenames numerically when it makes sense
setopt pushd_ignore_dups       # Ignore duplices in the directory stack
setopt rcexpandparam           # Array expension with parameters


autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit zmv zcalc vcs_info edit-command-line run-help && compinit
zle -N edit-command-line


bindkey -e                                         # Emacs style shortcuts
bindkey '^[[7~' beginning-of-line                  # Home key
bindkey '^[[H' beginning-of-line                   # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line   # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                        # End key
bindkey '^[[F' end-of-line                         # End key
if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line          # [End] - Go to end of line
fi
bindkey '^[[3~' delete-char                        # Delete key
bindkey '^[[C'  forward-char                       # Right key
bindkey '^[[D'  backward-char                      # Left key
bindkey '^[[5~' history-beginning-search-backward  # Page up key
bindkey '^[[6~' history-beginning-search-forward   # Page down key
bindkey '^X^E' edit-command-line


source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh


eval "$(dircolors $HOME/.dir_colors)"
