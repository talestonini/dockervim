#!/bin/sh

# manually fix coc-java
cd ~/dev
mkdir temp
cd temp
wget https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz
mv $HOME/.config/coc/extensions/coc-java-data/server $HOME/.config/coc/extensions/coc-java-data/server-broken-original
mkdir -p $HOME/.config/coc/extensions/coc-java-data/server
tar -xvf jdt-language-server-0.57.0-202006172108.tar.gz -C $HOME/.config/coc/extensions/coc-java-data/server

# fix CR/LF issue for Windows (needs to be done after installing vim-plug plugins)
git config --global core.autocrlf input
