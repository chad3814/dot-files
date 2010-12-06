#
# a new zshrc - 2010-02-01
#

fignore=(.o ~)

if [[ -e ~/.aliases ]]
then
    source ~/.aliases
fi

export LESS=-cEX4M
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -t"
export PAGER=less

