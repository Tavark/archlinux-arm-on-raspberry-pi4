export VISUAL=NVIM
export EDITOR="$VISUAL"

# HTTP Proxy
# export proxy_protocol="http"
# export proxy_host=127.0.0.1
# export proxy_port=3128

# export http_proxy=$proxy_protocol://$proxy_host:$proxy_port
# export https_proxy=$http_proxy
# export HTTP_PROXY=$http_proxy
# export HTTPS_PROXY=$https_proxy
# export no_proxy=127.0.0.1,localhost

# turn off bell
set bell-style none

# docker host configuration
export DOCKER_HOST=tcp://127.0.0.1:2375

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
# zstyle :compinstall filename '/home/kor1imb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

[[ ! -f ~/.alias ]] || source ~/.alias
[[ ! -f ~/.functions ]] || source ~/.functions
[[ ! -f ~/.zplugrc ]] || source ~/.zplugrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh