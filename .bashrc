#
# ~/.bashrc
#
export EDITOR=nvim
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#Variable
export NAS=/ext_drive/SynologyDrive/
export NASN=/ext_drive/SynologyDrive/Discord*Bot/Github/Nurevam

#ALIAS
alias ls='exa --color=auto'
alias grep='grep --color=auto'
alias tsync='task sync'
alias ts='task +School'
alias ta='task add'
alias tas='task add +School project:irl.School'
alias bc='bc -l'
alias suspend='systemctl suspend'
alias vim='nvim'
alias school='cd /ext_drive/SynologyDrive/Student\ Work\ Folder/University/Forth\ Year'
alias nurevam='cd /ext_drive/SynologyDrive/Discord\ Bot/Github/Nurevam/'
alias config='cd ~/.config/'
alias get_class='xprop | grep WM_CLASS'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

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

#eval "$(starship init bash)"
