alias vim="nvim"

# Nvm - node package manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
eval "$(rbenv init - zsh)"

# Bob - neovim package manager
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# To make user scripts available in path
export PATH=$PATH:~/SCRIPTS

REPOS_ROOT="~/REPOS"
CONFIG_ROOT="~/.config"
LEARNING_ROOT="~/LEARNING"
SCRIPTS_ROOT="~/SCRIPTS"

alias repos="cd $REPOS_ROOT"
alias config="cd $CONFIG_ROOT"
alias learn="cd $LEARNING_ROOT"
alias scripts="cd $SCRIPTS_ROOT"
# Display time in large ASCII - depends on figlet installed
alias scrny="ascii_time"
alias nwrite="count_write"
# C compiler
alias v="vim"
alias c="gcc"
alias o="./a.out"
# Server for simple webpages
alias serve="browser-sync start --server"





# Display name as welcome message in large ASCII - depends on toilet and lolcat
toilet -f pagga "JUST DO IT, RAKSHITH" | lolcat
