# we always use console from an xterm-color compatible terminal, tell the world.
export TERM=xterm-color

# git - since these munge the ~/.gitconfig, put them here so they don't compete against each other when screen spwans lots of shells
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global core.excludesfile "$HOME/.gitignore"
git config --global core.pager tee
git config --global push.default current
git config --global alias.lg "log --graph --decorate --date=relative --abbrev-commit --pretty=format:'%Cred%h%Creset [%an]%C(yellow)%d%Creset %s %Cgreen(%ar)%Creset'"
git config --global alias.recent "reflog -20 --date=relative"
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.staging-tags 'tag -l "staging*"'
git config --global core.whitespace 'trailing-space,space-before-tab,tab-in-indent'
git config --global branch.autosetuprebase always
# tell gitflow to use 'lg' as our log command
export git_log_command=lg

# run local .zprofile
source ~/.zprofile.local

# auto-run screen, but only once
# Be sure to munge path or set $SCREEN in .zshenv
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

