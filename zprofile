# fixes bug where Terminal.app doesn't let you scroll back through the history.
export TERM=screen

# git - since these munge the ~/.gitconfig, put them here so they don't compete against each other when screen spwans lots of shells
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


# run local .zprofile
source ~/.zprofile.local
