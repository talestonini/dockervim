# Dockerised Neovim

Ubuntu base image containing my dev text editor settings, with basic tooling for Java and Scala.

### 1) Build the image

    docker build -t dockervim .

### 2) Run the container

    docker run -ti -v [directory in host]:/root/[directory in container] --name vimide dockervim

where `directory in host` and `directory in container` allows for mapping projects in host machine into the
container, e.g.:

    docker run -ti \
               -v ~/dev:/root/dev \
               -v ~/.m2:/root/.m2 \
               --name vimide
               dockervim

#### Restarting the container

    docker start -i vimide

#### Starting new instance of container

In a new terminal tab or window:

    docker exec -it vimide bash

### 3) Post- container config

#### 3.1) Neovim

Open Neovim and:

    :PlugInstall
    :CocInstall coc-metals
    :CocInstall coc-java

Restart Neovim and the theme should be working.
Maven-Java projects need `mvn clean install` (outside of Neovim) and then:

    :CocCommand java.workspace.clean
    :CocCommand java.workspace.compile

After that, these projects should be indexed, jumping to definition and to Java, Spring source code.

#### 3.2) Post vim script

    $HOME/.config/post_vim.sh

#### 3.3) Configure cntlm (optional)

    cntlm -H -d [DOMAIN] -u [USER]

Put the output into:

    vim /etc/cntlm.conf

And then:

    export http_proxy=http://localhost:3128
    export https_proxy=https://localhost:3128
    service cntlm restart
