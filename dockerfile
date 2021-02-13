FROM ubuntu
LABEL maintainer toninit

# install:
# - curl
# - neovim
# - the silver searcher
# - openjdk8
# - scala
# - nodejs and npm
# - git
RUN set -x \
  && apt-get update \
  && apt install curl -y \
  && apt install neovim -y \
  && apt-get install silversearcher-ag -y \
  && apt install openjdk-8-jre-headless -y \
  && apt-get install scala -y \
  && apt install nodejs -y \
  && apt install npm -y \
  && apt install git -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# create the init.vim and coc-settings files
ENV HOME=/root
ADD ./init.vim $HOME/.config/nvim/init.vim
ADD ./coc-settings.json $HOME/.config/nvim/coc-settings.json

# install vim-plug
ENV XDG_DATA_HOME=$HOME/.config
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# env vars
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
