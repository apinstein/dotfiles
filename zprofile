# we always use console from an xterm-color compatible terminal, tell the world.
#export TERM=xterm-256color

# git config is managed statically via ~/dotfiles/gitconfig (symlinked to ~/.gitconfig)
# tell gitflow to use 'lg' as our log command
export git_log_command=lg

# run local .zprofile
source ~/.zprofile.local

# auto-run screen, but only once
# Be sure to munge path or set $SCREEN in .zshenv
# MUST be done last or the rest of the .zprofile script doesn't run until after screen terminates.
if tty -s; then
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
fi

## Anything below here was probably added automatically and should be moved to ~/.zshrc.local
