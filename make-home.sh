#!/bin/zsh

mkdir ~/.dots-backup

for x in `/bin/ls -1A`
{
    if [ -f "$x" ] ; then
	if [ -e "$HOME/$x" ] ; then
	    echo "Moving $x..."
	    mv $HOME/$x $HOME/.dots-backup
	fi
	echo "Linking $x..."
	ln $x $HOME/$x
    fi
    if [ -d "$x" -a "$x" != ".git" ] ; then
	if [ ! -e "$HOME/$x" ] ; then
	    echo "Making directory $x..."
	    mkdir $HOME/$x
	fi
	echo "Making directory .dots-backups/$x..."
	mkdir $HOME/.dots-backup/$x
	cd $x
	for y in `/bin/ls -1A`
	{
	    if [ -e "$HOME/$x/$y" ] ; then
		echo "Moving $x/$y..."
		mv $HOME/$x/$y $HOME/.dots-backup/$x
	    fi
	    echo "Linking $y/$x..."
	    ln $y $HOME/$x/$y
	}
	cd ..
    fi
}
