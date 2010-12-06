if [[ ! -e /tmp/emacs${UID}/server ]]
then
    # start an emacs daemon
    echo
    emacs --daemon
fi

alias emacs='emacsclient -t $*'
