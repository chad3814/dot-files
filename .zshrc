#
# a new zshrc - 2010-02-01
#

fignore=(.o ~)

if [[ -e ~/.aliases ]]
then
    source ~/.aliases
fi

export PS1='%(!.%{%}.%{%})%n@%m%{%}%(!.#.$) '
export RPS1=' %{%}%!%{%}:%(!.%{%}.%{%})%1~%{%}'


export LESS=-cEX4M
export EDITOR="emacsclient -t"
export VISUAL="emacsclient -t"
export PAGER=less
export FLEX_HOME=/opt/flex_sdk_3.5

export PATH=$FLEX_HOME/bin:$PATH
