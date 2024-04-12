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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pg14 utilities without db
export PG15_DIR="/Users/zhengyou.hong/Desktop/postgres/v15/bin"
export PATH="$PG15_DIR:$PATH"
 
# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# add nvim and lvim to path
export PATH="/Users/zhengyou.hong/Desktop/nvim-macos/bin:$PATH"
export PATH="/Users/zhengyou.hong/.local/bin:$PATH"
alias nvim="/Users/zhengyou.hong/kitty-remove-padding-lvim.sh"

# bash completion
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

export GPG_TTY=$(tty)

# autocomplete for pnpm etc
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true


