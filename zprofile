# another way, if you don't have pidof or need to know it's _your_ agent
idfile=~/.agentid
if ps xu -U `whoami` | grep "ssh-agent$" &> /dev/null
then
        test ! "$SSH_CLIENT" && test -r $idfile && eval `cat $idfile`
else
        if eval `ssh-agent`
        then
                export SSH_AGENT_PID
                export SSH_AUTH_SOCK
                echo "export SSH_AGENT_PID=$SSH_AGENT_PID" > $idfile
                echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> $idfile
                ssh-add ~/.ssh/alankey
        else
                rm -f $idfile
        fi
fi
unset idfile
# trick to get ssh-agent reconnected after re-attaching screen
test $SSH_AUTH_SOCK && ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"

# line editing
export EDITOR=vi

# ftp
export FTP_PASSIVE=1

# java
export CLASSPATH=$CLASSPATH:/Applications/dieselpoint-search/lib/diesel-3.5.1.jar:/Applications/dieselpoint-search/lib/javax.servlet.jar

# fixes bug where Terminal.app doesn't let you scroll back through the history.
export TERM=screen

# run local .zprofile
source ~/.zprofile.local

# auto-run screen, but only once
# MUST be done after local .zprofile which usually include PATH munging.
if ps x | grep "SCREEN$" &> /dev/null
then
    echo "Screen is already running."
else
    echo "Starting screen..."
    screen
fi
