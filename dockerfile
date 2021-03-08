FROM ubuntu
LABEL maintainer toninit
ENV HOME=/root

# install most needed dev software
RUN set -x \
  && apt update && apt full-upgrade -y \
  && apt-get update && apt-get full-upgrade -y \
  # start...
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
  && apt install neovim -y \
  && apt-get install fonts-powerline -y \
  && apt-get install silversearcher-ag -y

# manually install coursier, a JVM, scala dev tools, metals and metals-vim;
# see https://www.youtube.com/watch?v=o9H2EQO3fVs
RUN curl -fLo cs https://git.io/coursier-cli-"$(uname | tr LD ld)" \
  && chmod +x cs \
  && ./cs setup --yes --apps ammonite,bloop,cs,giter8,metals,sbt,scala,scalafmt \
  # metals-vim is not really needed, but seems to speed connection to language server
  && ./cs bootstrap \
       --java-opt -Xss4m \
       --java-opt -Xms100m \
       --java-opt -Dmetals.client=vim-lsc \
       org.scalameta:metals_2.12:0.10.0 \
       -r bintray:scalacenter/releases \
       -r sonatype:snapshots \
       -o /usr/local/bin/metals-vim -f \
  && rm cs

# install most needed dev software (cont...)
RUN set -x \
  && apt install openjdk-14-jdk -y \
  && apt install nodejs -y \
  && apt install npm -y \
  && apt install git -y \
  && apt install maven -y \
  # end
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME=/usr/lib/jvm/java-14-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin:$HOME/.local/share/coursier/bin

# config git and define the locale
RUN git config --global http.sslverify false \
  && locale-gen en_US.UTF-8 \
  && echo "" >> $HOME/.bashrc \
  && echo "# Switch to ZSH shell and go home/dev" >> $HOME/.bashrc \
  && echo "if test -t 1; then" >> $HOME/.bashrc \
  && echo "  exec zsh" >> $HOME/.bashrc \
  && echo "fi" >> $HOME/.bashrc

# create the init.vim and coc-settings files (needs to be after env HOME is defined)
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
