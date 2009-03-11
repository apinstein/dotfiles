if [ $WINDOW ]; then
    PROMPT="[$WINDOW:%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
else
    PROMPT="[%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
fi
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

# line editing
bindkey -v

export EDITOR=vim

# propel dev stuff
alias pshell='phocoa shell'

# aliases
alias l='ls -alhG'
alias godb='psql -U postgres showcase'
alias gomb='cd ~/Documents/Business/Consulting/MediaBin/Mac\ Client'
alias gocvs='cd ~/dev/sandbox'
alias lsd='ls -ld *(-/DN)'
alias top='top -u'
alias makecocoadoc='headerdoc2html -d -o Docs *.h; gatherheaderdoc Docs'
alias contacts="contacts -f '%n %hp %wp %mp %e'"
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias dailysales='tar -x opt/showcase/log/dailysales.txt.log -O -zf `ls -1t /Volumes/Scratchy/backup/production/showcase/alans-showcase-backup.200*tgz | head -1` > ~/Documents/Business/ShowCase/Admin/daily-sales.tab'
alias vi=vim
alias sgrep="grep --exclude '*.svn*' $*"
alias selenium='java -jar /usr/local/bin/selenium-server.jar'

# tunnels
alias httptunnel='ssh -R 2222:localhost:22 -t root@pen.syskey.com "ssh -g -L 8080:localhost:80 -p 2222 alanpinstein@127.0.0.1"'
alias tunnel-dev-cvs='ssh -C -A -R 2222:localhost:22 apinstein@showcasere.com'
alias tunnel-dev-svn='ssh -C -A -R 3333:localhost:3690 apinstein@showcasere.com'
alias tunnel-dev-svn-staging='ssh -C -A -R 3333:localhost:3690 apinstein@staging.neybor.com'
alias tunnel-dev-apache2='ssh -C -A -v -R 2222:localhost:22 -t apinstein@showcasere.com "ssh -C -g -L 8888:10.0.1.201:8080 -L 8887:10.0.1.201:80 -p 2222 alanpinstein@127.0.0.1"'

# cvs settings
export CVSROOT=/Users/Shared/Development/cvsroot
alias cvsstat='cvs -n up -R |& grep -v "^[o]\?cvs update\|server: Updating"'
alias cvsstatl='cvs -n up -l |& grep -v "^[o]\?cvs update\|server: Updating"'
alias cvstunnel='ssh -R 2401:localhost:2401 root@pen.syskey.com'

# php helpers
alias xdebug-on='export XDEBUG_CONFIG="idekey="'
alias xdebug-off='unset XDEBUG_CONFIG'

#login shortcuts
alias sc-prod='ssh -A apinstein@showcasere.com'
alias sc-vm0='ssh -A apinstein@216.114.79.44'
alias sc-www0='ssh -A apinstein@216.114.79.46'
alias startatlanta='ssh -A apinstein@216.114.79.47'
alias imac='ssh -A alanpinstein@showcase.dnsalias.com'

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
zstyle :compinstall filename '/Users/alanpinstein/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# override with local settings
source ~/.zshrc.local
