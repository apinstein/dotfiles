if [ $WINDOW ]; then
    PROMPT="[$WINDOW:%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
else
    PROMPT="[%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
fi
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

# line editing and default editor
bindkey -v
export EDITOR=vim

# ftp
export FTP_PASSIVE=1

# aliases
alias l='ls -alhG'
alias lsd='ls -ld *(-/DN)'
alias pshell='phocoa shell'
alias top='top -u'
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias vi=vim
alias vipager='vim -R -'
alias sgrep="grep --exclude '*.svn*' $*"
alias svnupdry='svn merge --dry-run -r BASE:HEAD .'
alias svnupdiff='svn diff -r BASE:HEAD .'

# php helpers
alias xdebug-on='export XDEBUG_CONFIG="idekey="'
alias xdebug-off='unset XDEBUG_CONFIG'

# ZSH setup
if [ $WINDOW ]; then
    PROMPT="[$WINDOW:%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
else
    PROMPT="[%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
fi
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle :compinstall filename '~/.zshrc'
source ~/.stuff/zsh/rake-completion.zsh

autoload -Uz compinit
compinit
# End of lines added by compinstall

# override with local settings
source ~/.zshrc.local
