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
# the trick is to always have a valid SSH_AUTH_SOCK linked at a "known" location (/tmp/ssh-agent-$USER-screen). 
# So, if there's an SSH_AUTH_SOCK (meaning ssh agent forwarding is on), then make sure that /tmp/ssh-agent-$USER-screen exists and points to a file that exists
# Since SSH cleans up after itself by deleting the SSH_AUTH_SOCK file, any new login should look to re-establish a valid link.
# ssh-agent forwarding on
if [ ! -z $SSH_AUTH_SOCK ]
then
    if [ ! -L "/tmp/ssh-agent-$USER-screen" ] # create link if one doesn't exit
    then
        ln -s "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
    else
        if [ ! -e `readlink /tmp/ssh-agent-$USER-screen` ] # if link exists and doesn't point to a valid file, re-create link to current SSH_AUTH_SOCK
        then
            ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
        else
            echo "ssh-agent to screen patching already configured and working"
        fi
    fi
fi

# fixes bug where Terminal.app doesn't let you scroll back through the history.
export TERM=screen

# run local .zprofile
source ~/.zprofile.local

# auto-run screen, but only once
# MUST be done after local .zprofile which usually include PATH munging.
if ps x | grep "SCREEN -S MainScreen" | grep -v grep &> /dev/null
then
    echo "Screen is already running."
else
    echo "Starting screen..."
    screen -S MainScreen
fi
