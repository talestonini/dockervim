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
# - wget
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
  && apt install maven -y \
  && apt-get install wget -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# define home and tools
ENV HOME=/root
RUN mkdir -p $HOME/tools
ENV TOOLS_HOME=/root/tools

# create the init.vim and coc-settings files
ADD ./init.vim $HOME/.config/nvim/init.vim
ADD ./coc-settings.json $HOME/.config/nvim/coc-settings.json

# manually install vim-plug
ENV XDG_DATA_HOME=$HOME/.config
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# manually install coursier
RUN curl -fLo cs https://git.io/coursier-cli-"$(uname | tr LD ld)" \
  && chmod +x cs \
  && ./cs install cs \
  && rm cs

# manually install bloop
ENV PATH=$PATH:$HOME/.config/coursier/bin
RUN cs update cs \
  && cs install bloop --only-prebuilt=true

# manually install sbt
RUN wget https://github.com/sbt/sbt/releases/download/v1.4.7/sbt-1.4.7.tgz \
  && tar xzvf sbt-1.4.7.tgz -C $TOOLS_HOME
ENV SBT_HOME=$TOOLS_HOME/sbt
ENV PATH=$PATH:$SBT_HOME/bin

# env vars
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
