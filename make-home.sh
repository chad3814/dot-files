#!/bin/zsh

mkdir ~/.dots-backup

function process_dir() {
    local dir
    dir=$1
    shift

    pushd $dir >/dev/null

    for x in `/bin/ls -1A`
    {
	if [ -f "$x" ] ; then
	    if [ -e "$HOME/$dir/$x" ] ; then
		echo "Moving $dir/$x..."
		mv $HOME/$dir/$x $HOME/.dots-backup/$dir/
	    fi
	    echo "Linking $dir/$x..."
	    ln $x $HOME/$dir/$x
	fi
	if [ -d "$x" -a "$x" != ".git" ] ; then
	    if [ ! -e "$HOME/$x" ] ; then
		echo "Making directory $dir/$x..."
		mkdir $HOME/$dir/$x
	    fi
	    echo "Making directory .dots-backups/$dir/$x..."
	    mkdir $HOME/.dots-backup/$dir/$x

	    popd >/dev/null
	    process_dir "$dir/$x"
	    pushd $dir >/dev/null
	fi
    }
    popd >/dev/null
}

cd `dirname $0`
process_dir .
