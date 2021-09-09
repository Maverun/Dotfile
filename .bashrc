# ~/.bashrc
#
export EDITOR=nvim
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#Variable
export NAS=/ext_drive/SynologyDrive/
export NASN=/ext_drive/SynologyDrive/Discord*Bot/Github/Nurevam

#BAT as manpager
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#NVIM as manpager
# export MANPAGER="nvim -c 'set ft=man' -"
export MANPAGER="nvim +Man!"

#ALIAS

#LS with EXA version
alias ls='exa -l --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'

# navigation
alias ..='cd ..' 
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'


#ALIAS of Taskwarrior
alias tsync='task sync'
alias ts='task +School'
alias ta='task add'
alias tas='task add +School project:irl.School'

#Calculator
alias bc='bc -l'

#System
alias suspend='systemctl suspend'
alias vim='nvim'
alias v='nvim'
alias e='nvim'

#Path
alias school='cd /ext_drive/SynologyDrive/Student\ Work\ Folder/University/Forth\ Year'
alias nurevam='cd /ext_drive/SynologyDrive/Discord\ Bot/Github/Nurevam/'
alias drive='cd /ext_drive/SynologyDrive/'
alias configs='cd ~/.config/'
alias dev='cd ~/dev/'

#Window
alias get_class='xprop | grep WM_CLASS'
alias get_key='xev'

#git related
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lazyconfig='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"


#Prompt
RESET="\[\017\]"
NORMAL="\[\033[00m\]"
CYAN="\[\033[36m\]"
DARK_CYAN="\[\033[2;36m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[34m\]"
RED="\[\033[31;1m\]"

#PS1="${CYAN}\@ ${DARK_CYAN}\u${GREEN} \W${NORMAL}\$"
PS1="${CYAN}\@${NORMAL}${DARK_CYAN}|${NORMAL}${GREEN}\W${NORMAL}\$"

$Function
function cheat(){ curl cheat.sh/"$@"; }

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)	tar xjf $1		;;
            *.tar.gz)	tar xzf $1		;;
            *.bz2)		bunzip2 $1		;;
            *.rar)		rar x $1		;;
            *.gz)		gunzip $1		;;
            *.tar)		tar xf $1		;;
            *.tbz2)		tar xjf $1		;;
            *.tgz)		tar xzf $1		;;
            *.zip)		unzip $1		;;
            *.Z)		uncompress $1	;;
            *)			echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

psgrep() {
    if [ ! -z $1 ] ; then
        #echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}


#screenfetch
neofetch
#task sync &
task +School or +Work
task calendar

# Faster key repeat and delay
xset r rate 210 40
#eval "$(starship init bash)"


alias luamake=/home/maverun/langservers/lua-language-server/3rd/luamake/luamake
