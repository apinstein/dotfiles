# line editing and default editor
bindkey -v
export EDITOR=vim

# ftp
export FTP_PASSIVE=1

# git
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global core.excludesfile "$HOME/.gitignore"
git config --global core.pager tee

# aliases
alias l='ls -alhG'
alias lsd='ls -ld *(-/DN)'
alias pshell='phocoa shell'
alias top='top -u'
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias vi=vim
alias vipager='vim -R -'
alias sgrep="grep --exclude '*.svn*' $*"
alias svnupdry='svn merge --dry-run -r BASE:HEAD .'
alias svnupdiff='svn diff -r BASE:HEAD .'

# php helpers
alias xdebug-on='export XDEBUG_CONFIG="idekey="'
alias xdebug-off='unset XDEBUG_CONFIG'

# Prompts: see http://aperiodic.net/phil/prompt/
setopt prompt_subst
autoload -U colors
colors

git_current_branch() {
    ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
    echo " git:${ref#refs/heads/} "
}

function precmd { # runs before the prompt is rendered each time
    local exitstatus=$? 

    # show screen window # if available
    if [ $WINDOW ]; then
        PR_SCREEN="$WINDOW."
    fi

    [ $exitstatus -eq 0 ] && PR_LAST_EXIT_COLOR="%{$fg_bold[green]%}" || PR_LAST_EXIT_COLOR="%{$fg_bold[red]%}"
}
PROMPT='[\
$PR_SCREEN\
%{${PR_LAST_EXIT_COLOR}%}%?%{$reset_color%}\
$(git_current_branch)\
]:> '
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle :compinstall filename '~/.zshrc'
source ~/.stuff/zsh/rake-completion.zsh

autoload -Uz compinit
compinit
# End of lines added by compinstall

# override with local settings
source ~/.zshrc.local
