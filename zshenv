# configure ssh-agent
alias ssh-keys-add-mine='echo "WARNING! No keys added to your ssh-agent. Set up \"alias ssh-keys-add-mine=ssh-add <your keys>\" in .zshenv.local.\nIt will be used to auto-add your keys in new shells and also can be used to re-add keys once expired (every 12 hours)."'

# override with local settings
source ~/.zshenv.local

idfile=~/.agentid
if [ -z $SSH_CLIENT ]
then
    is_local_client=YES
else
    is_local_client=NO
fi
if [ -z $SSH_AUTH_SOCK ]
then
    if ps x -o 'command' -U `whoami` | grep "^ssh-agent" &> /dev/null
    then
        # Attach current shell to existing *local* ssh-agent session
        test -r $idfile && eval `cat $idfile` || echo "ERROR: expected $idfile to exist but it does not..."
    elif [ $is_local_client = "YES" ]
    then
        # Create a new *local* ssh-agent session
        if eval `ssh-agent -t 43200`
        then
            export SSH_AGENT_PID
            export SSH_AUTH_SOCK
            # output ok; only happens on local (interactive) terminal
            echo "export SSH_AGENT_PID=$SSH_AGENT_PID" > $idfile
            echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> $idfile
            echo "Use ssh-add to add desired keys. I recommend an alias called 'ssh-keys-add-mine' to add all keys you want since we have a default timeout of 12 hours."
        else
            rm -f $idfile
        fi
    else
        tty -s && echo "Skipping ssh-agent setup since this is a remote session."
    fi
fi
unset idfile is_local_client
# trick to get ssh-agent reconnected after re-attaching screen
# the trick is to always have a valid SSH_AUTH_SOCK linked at a "known" location (/tmp/ssh-agent-$USER-screen). 
# So, if there's an SSH_AUTH_SOCK (meaning ssh agent forwarding is on), then make sure that /tmp/ssh-agent-$USER-screen exists and points to a file that exists
# note that since this is in .zshenv it runs both before and after screen starts, so you have to watch for the nested setup when a screen shell is started and no-op.
# Since SSH cleans up after itself by deleting the SSH_AUTH_SOCK file, any new login should look to re-establish a valid link.
# ssh-agent forwarding on
screen_ssh_agent_canonical_sock="/tmp/ssh-agent-$USER-screen"
if [ ! -z $SSH_AUTH_SOCK ] && [ $SSH_AUTH_SOCK != $screen_ssh_agent_canonical_sock ]
then
    # if link doesn't exist
    # OR if link doesn't point to a valid file
    # OR it links to a valid file but not the current SSH_AUTH_SOCK (due to agent fwd most likely)
    # THEN re-create link to current SSH_AUTH_SOCK
    if [ ! -e $screen_ssh_agent_canonical_sock ] || [ ! -e `readlink $screen_ssh_agent_canonical_sock` ] || [ `readlink $screen_ssh_agent_canonical_sock` != $SSH_AUTH_SOCK ]
    then
        ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
    fi
fi

# add ssh-keys; ssh-add will exit(1) if there is an agent but no identities.
# this line is below the .zprofile.local since that's where ssh-keys-add-mine is defined
(ssh-add -l 2>&1) > /dev/null
if [ $? = "1" ]; then
    tty -s && \
        echo "Running ssh-keys-add-mine to add your keys since there are no identities in your ssh-agent." && \
        ssh-keys-add-mine
fi
# end ssh-agent setup.

# set up RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
