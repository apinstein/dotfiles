if [ $WINDOW ]; then
    PROMPT="[$WINDOW:%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
else
    PROMPT="[%{[1;46m%}%h%{[1;0m%}.%?%{[1;0m%}]:> "
fi
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

# line editing
bindkey -v

# propel dev stuff
export PHP_COMMAND=/opt/local/bin/php
alias php4='/usr/local/bin/php'
alias php5=$PHP_COMMAND
alias phocoa='/Users/alanpinstein/dev/sandbox/phocoa/phing/phocoa'
alias createPage='php5 /Users/alanpinstein/dev/sandbox/phocoa/phocoa/framework/createPage.php'
alias createModule='php5 /Users/alanpinstein/dev/sandbox/phocoa/phocoa/framework/createModule.php'
alias createSkeletonFromPropel='php5 /Users/alanpinstein/dev/sandbox/phocoa/phocoa/framework/createSkeletonFromPropel.php'
alias pshell='php5 /Users/alanpinstein/dev/sandbox/phocoa/phocoa/framework/shell.php'

# fink settings
#source /sw/bin/init.sh

# aliases
alias l='ls -alhG'
alias godb='psql -U postgres showcase'
alias gomb='cd ~/Documents/Business/Consulting/MediaBin/Mac\ Client'
alias gocvs='cd ~/dev/sandbox'
alias updatevglog='scp -C aspinste@pen.syskey.com:/opt/marketplace/log/access_log /tmp/access_log; webalizer;'
alias lsd='ls -ld *(-/DN)'
alias top='top -u'
alias makecocoadoc='headerdoc2html -d -o Docs *.h; gatherheaderdoc Docs'
alias contacts="contacts -f '%n %hp %wp %mp %e'"
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias dailysales='tar -x opt/showcase/log/dailysales.txt.log -O -zf `ls -1t /Volumes/Scratchy/backup/production/showcase/alans-showcase-backup.200*tgz | head -1` > ~/Documents/Business/ShowCase/Admin/daily-sales.tab'

# tunnels
alias httptunnel='ssh -R 2222:localhost:22 -t root@pen.syskey.com "ssh -g -L 8080:localhost:80 -p 2222 alanpinstein@127.0.0.1"'
alias tunnel-dev-cvs='ssh -C -A -R 2222:localhost:22 apinstein@showcasere.com'
alias tunnel-dev-svn='ssh -C -A -R 3333:localhost:3690 apinstein@showcasere.com'
alias tunnel-dev-apache2='ssh -C -A -v -R 2222:localhost:22 -t apinstein@showcasere.com "ssh -C -g -L 8888:10.0.1.201:8080 -L 8887:10.0.1.201:80 -p 2222 alanpinstein@127.0.0.1"'

# cvs settings
export CVSROOT=/Users/Shared/Development/cvsroot
alias cvs=ocvs
alias cvsstat='cvs -n up -R |& grep -v "^[o]\?cvs update\|server: Updating"'
alias cvsstatl='cvs -n up -l |& grep -v "^[o]\?cvs update\|server: Updating"'
alias cvstunnel='ssh -R 2401:localhost:2401 root@pen.syskey.com'

# java settings

#login shortcuts
alias sc-prod='ssh -A apinstein@showcasere.com'
alias imac='ssh -A alanpinstein@10.0.1.201'
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle :compinstall filename '/Users/alanpinstein/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
