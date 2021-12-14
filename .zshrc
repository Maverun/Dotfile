# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/maverun/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="jonathan"
ZSH_THEME="xiong-chiamiov-plus"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-prompt zsh-autosuggestions zsh-syntax-highlighting taskwarrior zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

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

#Search with Package manager
alias pacmansearch='pacman -Ss'

#Disable/enable screensaver, better not to disable often but just in case you need to...
alias disableScreenSaver='xset s off & xset s noblank & xset -dpms'
alias enableScreenSaver='xset s on & xset s blank & xset dpms'

# function precmd {
#     PROMPT="%F{cyan}%t%f|%F{green}%1~$(git_super_status)%F{green}➜ %f%{$reset_color%}"
# }

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


# # Change cursor shape for different vi modes.
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

set -o vi
bindkey -v
# bindkey 'H' beginning-of-line
# bindkey 'L' end-of-line
# bindkey '^[[H' beginning-of-line
# bindkey '^[[F' end-of-line
zvm_bindkey vicmd 'H' 'beginning-of-line'
zvm_bindkey vicmd 'L' 'end-of-line'
# ZVM_VI_HIGHLIGHT_FOREGROUND=#008800           # Hex value
ZVM_VI_HIGHLIGHT_BACKGROUND=#33467C           # Hex value
#screenfetch
neofetch
#task sync &
task +School or +Work
task calendar

# Faster key repeat and delay
xset r rate 210 40
#eval "$(starship init bash)"
