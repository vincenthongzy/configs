export HISTSIZE=99999
export HISTFILESIZE=999999
export SAVEHIST=$HISTSIZE

alias ls="ls --color=auto"

function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1) /p'
}

NEW_LINE=$'\n'
COLOR_DEF=$'%f'
COLOR_USR=$'%F{grey}'
COLOR_DIR=$'%F{blue}'
COLOR_GIT=$'%F{green}'
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%2~ ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}$ '

# pg14 utilities without db
export PG15_DIR="/Users/zhengyh/Desktop/postgres/v15/bin"
export PATH="$PG15_DIR:$PATH"
 
# add nvim
export PATH="/Users/zhengyh/Desktop/nvim_0.10/bin:$PATH"

# bash completion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

export GPG_TTY=$(tty)

# to edit commands inline
export EDITOR="$HOME/nvim-kitty-wrapper.sh"
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

eval "$(~/.local/bin/mise activate zsh)"

source <(fzf --zsh)

# don't use shell alias to replace cd with z
eval "$(zoxide init --cmd cd zsh)"

# yazi switch to selected directory or Q to exit without cwd
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
