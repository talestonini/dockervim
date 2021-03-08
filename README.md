# Dockerised Neovim

Ubuntu base image containing my dev text editor settings, with basic tooling for Scala and Java.

Essentially, this is the automation of settings found in these websites:
- [Metals in Vim](https://scalameta.org/metals/docs/editors/vim.html)
- [coc-metals](https://github.com/scalameta/coc-metals)

Steps to build configure:

## 1) Build the image

    docker build -t dockervim .

## 2) Run the container

    docker run -ti -v [directory in host]:/root/[directory in container] --name vimide dockervim

where `directory in host` and `directory in container` allows for mapping projects in host machine into the container, e.g.:

    docker run -ti -v ~/dev:/root/dev -v ~/.m2:/root/.m2 -v ~/.ivy2:/root/.ivy2 --name vimide dockervim

## 3) Within container config

Open Neovim and:

- `:PlugInstall`
- `:CocInstall coc-metals`
- `:CocInstall coc-java`
- `:CocInstall coc-json`
- `:CocInstall coc-xml`
- `:CocInstall coc-...`

Restart Neovim and the theme should be working.

Now run the following script:

    $HOME/.config/post_vim.sh

**Congratulations!** The container should be ready to use.

Following are some useful info on dev lifecycle tasks and further config to your env.

## Loading Scala projects

SBT-Scala projects need a few steps to prepare:

    rm -rf .bloop .bsp .metals project/project project/target
    sbt bloopInstall
    nvim build.sbt

This will recreate directories `.bloop` and `.bsp` (`sbt bloopInstall`) and then `.metals` (opening the `build.sbt`). Now metals should detect the project and then request to import it. After a while, jump-to navigation should work (it could take a considerable while for the first time, as the language server needs to connect and the whole project needs to be compiled).

**Note #1**: If you notice the project not being detected, certainly `.metals` directory should also not be there. In that case, restart Neovim with the `build.sbt` file until metals detects the project and suggets to import it, with the `.metals` directory there.

**Note #2**: I suspect that plugin `sbt-bloop`'s version (`project/metals.sbt`) should match the version of SBT for the project (`build.properties`). Since `project/metals.sbt` is a file managed by Metals and apparently it bumps up the plugin version to the latest automatically, keep an eye for that version going ahead of your project's SBT version. I noticed that in such case, jump-to navigation was working as project import failed (red message at the bottom).

**Note #3**: Maybe suspition above is not right (to be confirmed). New evidences point to my test project using Scala *2.13* and not having the following essential section in `build.sbt`:

    // Enable macro annotations by setting scalac flags for Scala 2.13
    scalacOptions ++= {
      import Ordering.Implicits._
      if (VersionNumber(scalaVersion.value).numbers >= Seq(2L, 13L)) {
        Seq("-Ymacro-annotations")
      } else {
        Nil
      }
    }

**Thoubleshooting:**

- `:CocCommand` and fuzzy search for *doctor*
- Check the logs in `.metals/`
- Upgrade the scala version used by the project

It happened to me needing to delete `.bloop`/`.bsp`/`.metals` more than once until connection to the language server worked and all the jump-to definitions could work. A good test is jumping to your own project classes and to Scala classes such as `String` and `Future`.

## Loading Java projects

Maven-Java projects need a few steps to prepare:

    rm -rf .bloop .bsp .metals
    mvn clean install
    nvim pom.xml

Similar to Scala projects, at this time detection of the project and suggestion to import it should happen. The following can help with that too (although should not be necessary):

- `:CocCommand java.workspace.clean`
- `:CocCommand java.workspace.compile`

After that, projects should be indexed, jumping to definition and to Java/Spring source code.

## Configuring Coc plugins

You can add further Coc settings with `:CocConfig`, which edits `coc-settings.json`.

Check [coc-metals](https://github.com/scalameta/coc-metals) and [coc-java](https://github.com/neoclide/coc-java) for lists of entries.

## Restarting the container

    docker start -i vimide

## Starting new instance of container

In a new terminal tab or window:

    docker exec -it vimide bash

## Note on fonts

With Neovim runnint within a terminal (terminal in a Mac or Linux, PowerShell or Command in a Windows), the font utilised by the editor will be the font configured for the terminal.  Therefore, if unicode symbols don't display properly (like the ones utilised by plugin nerdtree-git-plugin), it's a problem with the font not being able to do so.  Look for an appropriate font and consult nerdtree-git-plugin documentation for samples of unicode characters you may be interested in.
A good font for Windows, that has good unicode coverage, is `Dejavu Sans Mono` and you can install it with chocolatey:

    choco install font-nerd-dejavusansmono

## Configuring Cntlm

    cntlm -H -d [DOMAIN] -u [USER]

Put the output into:

    vim /etc/cntlm.conf

And then:

    export http_proxy=http://localhost:3128
    export https_proxy=http://localhost:3128
    service cntlm restart
