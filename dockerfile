# for ubuntu arm64 arch
FROM ubuntu:latest@sha256:61bd0b97000996232eb07b8d0e9375d14197f78aa850c2506417ef995a7199a7
LABEL maintainer toninit
ENV HOME=/root

# install most needed dev software
# NOTE: ripgrep and fd-find are dependencies of the telescope plugin (:checkhealth telescope)
RUN set -x \
  && apt update && apt full-upgrade -y \
  && apt-get update && apt-get full-upgrade -y \
  && apt-get install software-properties-common -y \
  && add-apt-repository ppa:neovim-ppa/unstable -y \
  && apt update && apt full-upgrade -y \
  && apt-get update && apt-get full-upgrade -y \
  && apt-get install locales -y \
  && apt install iputils-ping -y \
  && apt install curl -y \
  && apt-get install wget -y \
  && apt-get install lsof -y \
  && apt-get install dos2unix -y \
  && apt-get install unzip -y \
  && apt-get install cntlm -y \
  && apt install zsh -y \
  && apt install nano -y \
  && apt-get install luajit -y \
  && apt install neovim -y \
  && apt-get install fonts-powerline -y \
  && apt-get install silversearcher-ag -y \
  && apt-get install ripgrep -y \
  && apt install fd-find -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install most needed dev software (cont...)
RUN set -x \
  && apt update && apt full-upgrade -y \
  && apt-get update && apt-get full-upgrade -y \
  && apt install openjdk-17-source -y \
  && curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt install git -y \
  && apt install maven -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-arm64
ENV PATH=$PATH:$JAVA_HOME/bin:$HOME/.local/share/coursier/bin

# config timezone, locale, git and .bashrc
# https://blog.programster.org/docker-ubuntu-20-04-automate-setting-timezone
ENV TZ=Australia/Melbourne
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
  && locale-gen en_US.UTF-8 \
  && git config --global http.sslverify false \
  && echo "" >> $HOME/.bashrc \
  && echo "# Switch to ZSH shell" >> $HOME/.bashrc \
  && echo "if test -t 1; then" >> $HOME/.bashrc \
  && echo "  exec zsh" >> $HOME/.bashrc \
  && echo "fi" >> $HOME/.bashrc

# create OS and dev env config files (needs to be after env HOME is defined)
ADD ./.bash_profile $HOME/.bash_profile
ADD ./init.vim $HOME/.config/nvim/init.vim
ADD ./coc-settings.json $HOME/.config/nvim/coc-settings.json
ADD ./post_vim.sh $HOME/.config/post_vim.sh
ADD ./eclipse-java-google-style.xml $HOME/.config/eclipse-java-google-style.xml

# manually install vim-plug
ENV XDG_DATA_HOME=$HOME/.config
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# manually install ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
COPY ./.zshrc $HOME/.zshrc

WORKDIR $HOME/dev
