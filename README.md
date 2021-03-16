# Dotfile

#Set up
References: https://www.atlassian.com/git/tutorials/dotfiles

Short summary

Then do

`echo ".cfg" >> .gitignore`

`git clone --bare <git-repo-url> $HOME/.cfg`

`alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`

then finally
`config pull`
