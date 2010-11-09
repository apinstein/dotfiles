# line editing and default editor
bindkey -v
export EDITOR=vim

# ftp
export FTP_PASSIVE=1

# aliases
alias l='ls -alh'
alias lsd='ls -ld *(-/DN)'
alias pshell='phocoa shell'
alias top='top -u'
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias vi=vim
alias vipager='vim -R -'

# php helpers
alias xdebug-on='export XDEBUG_CONFIG="remote_enable=1"'
alias xdebug-off='unset XDEBUG_CONFIG'

# Prompts: see http://aperiodic.net/phil/prompt/
setopt prompt_subst
autoload -U colors
colors

git_current_branch() {
    ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
    echo " git@${ref#refs/heads/} "
}

function precmd { # runs before the prompt is rendered each time
    local exitstatus=$? 

    # show screen window # if available
    if [ $WINDOW ]; then
        PR_SCREEN="$WINDOW"
    fi

    [ $exitstatus -eq 0 ] && PR_LAST_EXIT="" || PR_LAST_EXIT=" %{$fg_bold[red]%}%?%{$reset_color%}"

    # put in here so length recalulation works well and prompts don't wrap
    PROMPT='[\
$PR_SCREEN\
$(git_current_branch)\
]:\
${PR_LAST_EXIT}\
> '
}
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle :compinstall filename '~/.zshrc'
zstyle :compinstall filename '~/.stuff/zsh/rake-completion.zsh'

autoload -Uz compinit
if [ $USER = "root" ]; then
    # sudo'd shells run this zshrc; root was writing out zcompdump and thus breaking perms for the main user. have root skip dumping; the file should be there anyway.
    compinit -D
else
    compinit
fi
# End of lines added by compinstall

# override with local settings
source ~/.zshrc.local
