# line editing and default editor
export EDITOR=vim
bindkey -v

# ftp
export FTP_PASSIVE=1

export TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S'
export REPORTTIME=10

# aliases
alias l='/opt/local/libexec/gnubin/ls -alh --color'
alias lsd='ls -ld *(-/DN)'
alias pshell='phocoa shell'
alias bigdirs='du -Sh ./ | grep -v "^-1" | grep "^[0-9]\\+M"'
alias base64urldecode='tr "\-_" "+/" | base64 -d | more'
alias vi=vim
alias vipager='vim -R -'
alias pb='git planbox'
alias rake='noglob rake'
alias ramdisk='diskutil erasevolume HFS+ "ramdisk" `hdiutil attach -nomount ram://4194304`'

# suffix aliases
alias -s php=vim
alias -s tpl=vim
alias -s rb=vim
alias -s conf=vim
alias -s log=vim
alias -s png="open -a Preview"
alias -s jpg="open -a Preview"
alias -s gif="open -a Preview"
alias -s pdf="open -a Preview"

# php helpers
alias xdebug-on='export XDEBUG_MODE="debug" XDEBUG_SESSION=1'
alias xdebug-off='unset XDEBUG_MODE XDEBUG_SESSION'
alias xdebug-profile='php -dxdebug.mode=profile -dxdebug.output_dir=`pwd` $*'

# Prompts: see http://aperiodic.net/phil/prompt/
setopt prompt_subst
autoload -U colors
colors

# grep the current repo for the given string, skipping files/directories that trip up grep or are undesirable in the search list
function repogrep() {
    local DIR=`pwd`
    local TARGET=.git
    while [ ! -e $DIR/$TARGET -a $DIR != "/" ]; do
        DIR=$(dirname $DIR)
    done
    test $DIR = "/" && echo "Couldn't find a repo from here..." && return 1

    echo Searching from $DIR
    find ${DIR}/ \
        -type f                                     \
        -not -path '*/.git/*'                       \
        -not -path '*/tags'                         \
        -not -path '*/*min.js'                      \
        -not -path "*/externals/*"                  \
        -not -path "*/wwwroot/www/db_images/*"      \
        -not -path "*/wwwroot/www/coverage/*"       \
        -not -path "*/shared/*"                     \
        -print0                                     \
        | xargs -0 grep $*
}

git_current_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo " git@${ref#refs/heads/} "
}

function flushdns() {
    (uname -a | grep Darwin > /dev/null 2>&1) && (dscacheutil -flushcache;sudo killall -HUP mDNSResponder)
}

# prefer autossh for auto-reconnection after network disruptions
ssh_cmd="${commands[autossh]:-/usr/bin/ssh}"
[[ $ssh_cmd = *autossh ]] && ssh_cmd+=" -M 0" || (ssh_cmd=`which ssh` && echo "Consider installing autossh!")
ssh(){
    # it seems that closing a terminal window when ssh is run from a function results in the
    # ssh process not exiting properly (doesn't seem to get the HUP from the terminal), ends up orphaned to ppid 1
    # screen doesn't like it when orpahned ssh sessions (no tty?) are still connected and it doesn't work
    # this little guy makes sure to kill all orphaned ssh's so that our screen's don't all get hung
    # I am hoping to figure this out properly with the zsh folks but for now this allows me to use ssh without crying
    orpahned_ssh=`ps ax -o ppid,pid,command  | grep '^ *1 .*ssh\>' | grep -v ssh-agent | awk '{ print $2; }' | xargs echo`
    [ -n "${orpahned_ssh}" ] && echo ${orpahned_ssh} | xargs kill -9 && echo "killing orphaned ssh processes: ${orpahned_ssh}"

    title "ssh $*"
    ${=ssh_cmd} -o Compression=yes -o ServerAliveInterval=15 -o ServerAliveCountMax=3 $*
    title
}

function precmd { # runs before the prompt is rendered each time
    # PROMPT
    local exitstatus=$? 

    # show screen window # if available
    if [ $WINDOW ]; then
        PR_SCREEN="$WINDOW"
    fi

    # Combined left and right prompt configuration.
    local smiley="%(?,%F{green}☺%f,%F{red}☹%f)"

    [ $exitstatus -eq 0 ] && PR_LAST_EXIT="${smiley} " || PR_LAST_EXIT="${smiley} %{$fg_bold[red]%}%?%{$reset_color%}"

    # put in here so length recalulation works well and prompts don't wrap
    PROMPT='[\
$PR_SCREEN\
$(git_current_branch)\
]:\
${PR_LAST_EXIT}\
> '
    # /PROMPT

    # BUGFIX for older zsh that overwrite the last line of command output if there is no trailing newline.
    # See http://zsh.sourceforge.net/FAQ/zshfaq03.html, 3.23
    # Skip defining precmd if the PROMPT_SP option is available.
    if ! eval '[[ -o promptsp ]] 2>/dev/null'; then
        # Output an inverse char and a bunch spaces.  We include
        # a CR at the end so that any user-input that gets echoed
        # between this output and the prompt doesn't cause a wrap.
        print -nP "%B%S%#%s%b${(l:$((COLUMNS-1)):::):-}\r"
    fi
}
RPROMPT=" $USERNAME@%M:%~"     # prompt for right side of screen

##### HISTORY CONFIGURAION
HISTSIZE=5000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=5000               # Number of history entries to save to disk
#HISTDUP=erase              # Erase duplicates in the history file
# The next 3 configue cross-session history sharing and immediately write all commands to the shared history file
# (rather than at session exit which risks losing useful history)
setopt appendhistory        # Append history to the history file (no overwriting)
setopt sharehistory         # Share history across terminals
setopt incappendhistory     # Immediately append to the history file, not just when a term is killed

# Now that we have shared hisory, we want it for "search" but not up-arrow/down-arrow, which should just be session-local history
# From: https://superuser.com/questions/446594/separate-up-arrow-lookback-for-local-and-global-zsh-history
bindkey "${key[Up]}" alans-up-prompt
bindkey "^[[A" alans-up-prompt

bindkey "${key[Down]}" alans-down-prompt
bindkey "^[[B" alans-down-prompt

alans-up-prompt() {
    zle set-local-history 1
    zle up-line-or-search
    zle set-local-history 0
}
zle -N alans-up-prompt
alans-down-prompt() {
    zle set-local-history 1
    zle down-line-or-search
    zle set-local-history 0
}
zle -N alans-down-prompt
##### END HISTORY CONFIGURATION


HOSTTITLE=${(%):-%n@%m}
TITLE=$HOSTTITLE
function title (){
    if (( ${#argv} == 0 )); then
        TITLE=$HOSTTITLE
    else
        TITLE=$*
    fi
    # send title to gui terminal title bar
    case $TERM in
        xterm* | *rxvt | screen)
            print -Pn "\e]0;$TITLE \a"
    esac
}

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle -e ':completion::complete:s(cp|sh):*' hosts "reply=( \$( gawk '
    /^#/ { next }
    /^Host\>/ { \$1 = \"\"; print }
    ARGIND > 1 && !FS_set { FS = \"[, ]\";  FS_set++; \$0 = \$0; }
    FS_set { print \$1, \$2 }
    ' ~/.ssh/config ~/.ssh/known_hosts )
    )"
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

## Anything below here was probably added automatically and should be moved to ~/.zshrc.local
