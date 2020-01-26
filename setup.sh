#!/bin/bash

BACKUP_DIR=$PWD/backup
ORIGINAL_BASHRC=$HOME/.bashrc
ORIGINAL_VIMRC=$HOME/.vimrc
ORIGINAL_FISHCONF_FOLDER=$HOME/.config/fish/
ORIGINAL_GITCONF=@HOME/.gitconfig

# Backup current dotfiles
mkdir -p $BACKUP_DIR
mv $ORIGINAL_BACHRC $ORIGINAL_VIMRC $ORIGINAL_FISHCONF_FOLDER \
       	$ORIGINAL_GITCONF $BACKUP_DIR

# Create vim folders
mkdir -p ~/.vim/{autoload,colors}
mkdir -p ~/.config
ln -s ~/.vim ~/.config/nvim


# Install vim-plug plugin manager
wget -O ~/.config/nvim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


ln -sf $PWD/bash/bashrc $ORIGINAL_BASHRC
ln -sf $PWD/vim/vimrc $ORIGINAL_VIMRC
ln -sf $PWD/vim/vimrc $HOME/.vim/init.vim
ln -sf $PWD/fish/* $ORIGINAL_FISHCONF_FOLDER
ln -sf $PWD/git/gitconfig $ORIGINAL_GITCONF
