# Dockerised Neovim

Ubuntu base image containing my dev text editor settings, with basic tooling for Java and Scala.

Essentially, this is the automation of settings found in these websites:
- [Metals in Vim](https://scalameta.org/metals/docs/editors/vim.html)
- [coc-metals](https://github.com/scalameta/coc-metals)

Steps to build configure:

### 1) Build the image

    docker build -t dockervim .

### 2) Run the container

    docker run -ti -v [directory in host]:/root/[directory in container] --name vimide dockervim

where `directory in host` and `directory in container` allows for mapping projects in host machine into the container, e.g.:

    docker run -ti -v ~/dev:/root/dev -v ~/.m2:/root/.m2 -v ~/.ivy2:/root/.ivy2 --name vimide dockervim

### 3) Within container config

Open `nvim` and:

- `:PlugInstall`
- `:CocInstall coc-metals`

Restart Neovim and the theme should be working.

Now run the following script:

    $HOME/.config/post_vim.sh

Congratulations! The container should be ready to use.

Following are some useful info on dev lifecycle tasks and further config to your env.

### Loading Java projects

Maven-Java projects need a few steps to prepare:

    mvn clean install
    nvim pom.xml

- `:CocCommand java.workspace.clean`
- `:CocCommand java.workspace.compile`

After that, projects should be indexed, jumping to definition and to Java/Spring source code.

### Loading Scala projects

SBT-Scala projects need a few steps to prepare:

    rm -rf .bloop .bsp .metals
    sbt bloopInstall
    nvim build.sbt

This will recreate directories `.bloop` and `.bsp` (`sbt bloopInstall`) and then `.metals` (opening the `build.sbt`). Now metals should detect the project and then request to import it. After a while, jump-to navigation should work (it could take a considerable while for the first time).

Thoubleshooting:

- `:CocCommand` and fuzzy search for *doctor*, or
- Check the logs in `.metals/`, or
- Upgrade the scala version used by the project.

It happened to me needing to delete `.bloop`/`.bsp`/`.metals` more than once until connection to the language server worked and all the jump-to definitions could work. A good test is jumping to your own project classes and to Scala classes such as `String` and `Future`.

### Configuring Coc

You can add further Coc settings with `:CocConfig`, which edits `coc-settings.json`.

Check [coc-java](https://github.com/neoclide/coc-java) and [coc-metals](https://github.com/scalameta/coc-metals) for lists of entries.

### Restarting the container

    docker start -i vimide

### Starting new instance of container

In a new terminal tab or window:

    docker exec -it vimide bash

### Notes on fonts

With Neovim runnint within a terminal (terminal in a Mac or Linux, PowerShell or Command in a Windows), the font utilised by the editor will be the font configured for the terminal.  Therefore, if unicode symbols don't display properly (like the ones utilised by plugin nerdtree-git-plugin), it's a problem with the font not being able to do so.  Look for an appropriate font and consult nerdtree-git-plugin documentation for samples of unicode characters you may be interested in.
A good font for Windows, that has good unicode coverage, is `Dejavu Sans Mono` and you can install it with chocolatey:

    choco install font-nerd-dejavusansmono

### Configuring cntlm

    cntlm -H -d [DOMAIN] -u [USER]

Put the output into:

    vim /etc/cntlm.conf

And then:

    export http_proxy=http://localhost:3128
    export https_proxy=http://localhost:3128
    service cntlm restart
