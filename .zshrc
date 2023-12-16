export ZSH="/home/maverun/.oh-my-zsh"

ZSH_THEME="xiong-chiamiov-plus"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    git-prompt
    zsh-autosuggestions
    zsh-syntax-highlighting
    taskwarrior
    zsh-vi-mode
    # zsh-abbr
)

source $ZSH/oh-my-zsh.sh

export EDITOR=nvim

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#latex package installer
export PATH="$PATH:/usr/local/texlive/2022/bin/x86_64-linux"

#Variable
export NAS=/ext_drive/SynologyDrive/
export NASN=/ext_drive/SynologyDrive/Discord*Bot/Github/Nurevam

#BAT as manpager
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

#NVIM as manpager
# export MANPAGER="nvim -c 'set ft=man' -"
export MANPAGER="nvim +Man!"

export JDTLS_HOME=$HOME/.local/share/nvim/lsp_servers/jdtls
export JAVA_HOME=/usr/ # In case you don't have java in path or want to use a version in particular

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                                   Alias                                    │
# └────────────────────────────────────────────────────────────────────────────┘
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

#ALIAS of Taskwarrior
alias tsync='task sync'
alias ts='task +School'
alias ta='task add'
alias tas='task add +School project:irl.School'

#Calculator
alias bc='bc -l'

#System
alias suspend='systemctl suspend'
alias e='nvim'

#Path
alias nurevam='cd /ext_drive/SynologyDrive/Discord\ Bot/Github/Nurevam/'
alias drive='cd /ext_drive/SynologyDrive/'
alias note='cd /ext_drive/SynologyDrive/NotesTaking/'
alias configs='cd ~/.config/'
alias dev='cd ~/dev/'

#Window
alias get_class='xprop | grep WM_CLASS'
alias get_key='xev'

#git related
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lgc='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lg='lazygit'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#Search with Package manager
alias pacmansearch='pacman -Ss'
# paru/pacman stuff
alias yeet='paru -Rcs'
alias pas="paru -Slq | fzf --multi --preview 'paru -Si {1}' | xargs -ro paru -S"
alias upgrade='yes | paru -Syu --skipreview --sudoloop'

#Disable/enable screensaver, better not to disable often but just in case you need to...
alias disableScreenSaver='xset s off & xset s noblank & xset -dpms'
alias enableScreenSaver='xset s on & xset s blank & xset dpms'

#SSH with kitty uses, since ssh remote does not have terminfo so we are just using alias for it
alias ssh='kitty +kitten ssh'
alias icat="kitty +kitten icat --align=left" #photo preview on kitty terminal. Yeah mate.


# ┌────────────────────────────────────────────────────────────────────────────┐
# │                                  Function                                  │
# └────────────────────────────────────────────────────────────────────────────┘

function cheat(){ 
	old="$IFS"
	IFS="+"
	curl cheat.sh/"$*"; 
	IFS=$old
    }

function extract () {
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

function psgrep() {
    if [ ! -z $1 ] ; then
        #echo "Grepping for processes matching $1..."
        ps aux | grep $1 | grep -v grep
    else
        echo "!! Need name to grep for"
    fi
}


set -o vi
bindkey -v
zvm_bindkey vicmd 'H' 'beginning-of-line'
zvm_bindkey vicmd 'L' 'end-of-line'
# bindkey -M vicmd H vi-beginning-of-line
# bindkey -M vicmd L vi-end-of-line

ZVM_VI_HIGHLIGHT_BACKGROUND=#33467C           # Hex value

#cuz of vi mode, we must init it afterward
# source $ZSH/custom/plugins/zsh-abbr/zsh-abbr.zsh
neofetch
#task sync &
task project:
task calendar

# Faster key repeat and delay
xset r rate 210 40
#eval "$(starship init bash)"
