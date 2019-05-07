# vim: fdm=marker
# Set up the prompt

# autoload -Uz promptinit
# promptinit
# prompt adam1

setopt histignorealldups sharehistory
setopt autocd

export EDITOR=vim
export VISUAL=vim

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# {{{ completion
# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}
# {{{ plugins
[[ ! -d ~/.zplug ]] && git clone https://github.com/b4b4r07/zplug ~/.zplug
source ~/.zplug/init.zsh

zplug "zsh-users/zsh-history-substring-search"
zplug "themes/agnoster", from:oh-my-zsh, as:theme
zplug "dracula/zsh", as:theme
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/vi-mode", from:oh-my-zsh

zplug "plugins/z", from:oh-my-zsh

zplug "plugins/colorize", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "rjcoelho/zsh-dircolors"

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
# }}}

# FZF
export FZF_DEFAULT_COMMAND="rg --files'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# theme
ZSH_THEME="agnoster"
DEFAULT_USER="petran"

# {{{ aliases
alias cmake="$(which cmake) -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
eval $(thefuck --alias)
# }}}
# {{{ keobuilder
function keobuilder() {
    if [[ ! -e ./keo_builder.py ]]; then
        wget http://artifactory.local.keo-connectivity.de/artifactory/native-snapshot-local/artifacts/keo_build_system-2.0-build.tar.gz
        tar xzvf keo_build_system-2.0-build.tar.gz
        rm -f keo_build_system-2.0-build.tar.gz
    fi
    ./keo_builder.py $@
}
# }}}
