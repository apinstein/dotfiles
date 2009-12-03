# configure ssh-agent
alias ssh-keys-add-mine='echo "WARNING! No keys added to your ssh-agent. Set up \"alias ssh-keys-add-mine=ssh-add <your keys>\" in .zprofile.local.\nIt will be used to auto-add your keys in new shells and also can be used to re-add keys once expired (every 12 hours)."'
# another way, if you don't have pidof or need to know it's _your_ agent
idfile=~/.agentid
# already exists ssh-agent? flags so we don't false-positive on the grep
if ps x -o 'command' -U `whoami` | grep "^ssh-agent" &> /dev/null
then
        test ! "$SSH_CLIENT" && test -r $idfile && eval `cat $idfile`
else
        if eval `ssh-agent -t 43200`
        then
                export SSH_AGENT_PID
                export SSH_AUTH_SOCK
                echo "export SSH_AGENT_PID=$SSH_AGENT_PID" > $idfile
                echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> $idfile
                echo "Use ssh-add to add desired keys. I recommend an alias called 'ssh-keys-add-mine' to add all keys you want since we have a default timeout of 12 hours."
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
# end ssh-agent setup.

# fixes bug where Terminal.app doesn't let you scroll back through the history.
export TERM=screen

# run local .zprofile
source ~/.zprofile.local

# git
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global core.excludesfile "$HOME/.gitignore"
git config --global core.pager tee
git config --global push.default current
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.staging-tags 'tag -l "staging*"'

# add ssh-keys
ssh-add -l 2>&1 > /dev/null
if [ "$?" != 0 ]; then
    echo "Running ssh-keys-add-mine to add your keys since there are no identities in your ssh-agent."
    ssh-keys-add-mine
fi

# auto-run screen, but only once
# MUST be done after local .zprofile which usually include PATH munging.
# MUST be done last or the rest of the .zprofile script doesn't run until after screen terminates.
if ps x | grep "SCREEN -S MainScreen" | grep -v grep &> /dev/null
then
    echo "Screen is already running."
else
    echo "Starting screen..."
    if [ -z $SCREEN ]; then
        SCREEN=screen
    fi
    $SCREEN -S MainScreen
fi
