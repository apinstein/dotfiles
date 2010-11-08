# configure ssh-agent
alias ssh-keys-add-mine='echo "WARNING! No keys added to your ssh-agent. Set up \"alias ssh-keys-add-mine=ssh-add <your keys>\" in .zprofile.local.\nIt will be used to auto-add your keys in new shells and also can be used to re-add keys once expired (every 12 hours)."'
idfile=~/.agentid
if [ -z $SSH_CLIENT ];
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
            echo "export SSH_AGENT_PID=$SSH_AGENT_PID" > $idfile
            echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" >> $idfile
            echo "Use ssh-add to add desired keys. I recommend an alias called 'ssh-keys-add-mine' to add all keys you want since we have a default timeout of 12 hours."
        else
            rm -f $idfile
        fi
    else
        echo "Skipping ssh-agent setup since this is a remote session."
    fi
fi
unset ssh_agent_manager_info
# trick to get ssh-agent reconnected after re-attaching screen
# the trick is to always have a valid SSH_AUTH_SOCK linked at a "known" location (/tmp/ssh-agent-$USER-screen). 
# So, if there's an SSH_AUTH_SOCK (meaning ssh agent forwarding is on), then make sure that /tmp/ssh-agent-$USER-screen exists and points to a file that exists
# Since SSH cleans up after itself by deleting the SSH_AUTH_SOCK file, any new login should look to re-establish a valid link.
# ssh-agent forwarding on
if [ ! -z $SSH_AUTH_SOCK ]
then
    screen_ssh_agent_canonical_sock="/tmp/ssh-agent-$USER-screen"
    # if link doesn't exist
    # OR if link doesn't point to a valid file
    # OR it links to a valid file but not the current SSH_AUTH_SOCK (due to agent fwd most likely)
    # THEN re-create link to current SSH_AUTH_SOCK
    if [ ! -e $screen_ssh_agent_canonical_sock ] || [ ! -e `readlink $screen_ssh_agent_canonical_sock` ] || [ `readlink $screen_ssh_agent_canonical_sock` != $SSH_AUTH_SOCK ]
    then
        ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
    fi
fi
# end ssh-agent setup.

# fixes bug where Terminal.app doesn't let you scroll back through the history.
export TERM=screen

# run local .zprofile
source ~/.zprofile.local

# add ssh-keys; ssh-add will exit(1) if there is an agent but no identities.
# this line is below the .zprofile.local since that's where ssh-keys-add-mine is defined
(ssh-add -l 2>&1) > /dev/null
if [ $? = "1" ]; then
    echo "Running ssh-keys-add-mine to add your keys since there are no identities in your ssh-agent."
    ssh-keys-add-mine
fi

# git
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global core.excludesfile "$HOME/.gitignore"
git config --global core.pager tee
git config --global push.default current
git config --global alias.lg "log --graph --decorate --date=relative --abbrev-commit --pretty=format:'%Cred%h%Creset [%an]%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset'"
git config --global alias.recent "reflog -20 --date=relative"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.staging-tags 'tag -l "staging*"'
git config --global core.whitespace 'trailing-space,space-before-tab,tab-in-indent'
git config --global branch.autosetuprebase always
# tell gitflow to use 'lg' as our log command
export git_log_command=lg

# auto-run screen, but only once
# MUST be done after local .zprofile which usually include PATH munging.
# MUST be done last or the rest of the .zprofile script doesn't run until after screen terminates.
if ps x | grep -i "SCREEN -S MainScreen" | grep -v grep &> /dev/null
then
    echo "Screen is already running."
else
    echo "Starting screen..."
    if [ -z $SCREEN ]; then
        SCREEN=screen
    fi
    $SCREEN -S MainScreen
fi
