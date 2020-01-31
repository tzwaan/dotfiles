#!/bin/bash

BACKUP_DIR=$PWD/backup/
ORIGINAL_BASHRC=$HOME/.bashrc
ORIGINAL_VIMRC=$HOME/.vimrc
ORIGINAL_FISHCONF_FOLDER=$HOME/.config/fish
ORIGINAL_GITCONF=$HOME/.gitconfig

mkdir -p $HOME/.config

# Backup current dotfiles
declare -a Files=("$ORIGINAL_BASHRC" "$ORIGINAL_VIMRC" \
    "$ORIGINAL_FISHCONF_FOLDER" "$ORIGINAL_GITCONF")

echo -e "\n\n==========  Making backups of existing files  =========="
mkdir -p $BACKUP_DIR
for file in ${Files[@]}; do
    if [[ ( -f $file || -d $file ) && ! -L $file ]]
    then
        echo -e "  Moving $file to $BACKUP_DIR"
        mv "$file" "$BACKUP_DIR";
    else
        echo -e "  $file is already a symbolic link. No backup required"
    fi
done

echo -e "\n\n==========  Creating vim folders  =========="
mkdir -p $HOME/.vim/{autoload,colors}
ln -s $HOME/.vim $HOME/.config/nvim

echo -e "\n\n==========  Installing vim-plug plugin manager  =========="
wget -O ~/.config/nvim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


echo -e "\n\n==========  Creating symlinks to dotfiles  =========="
echo $ORIGINAL_BASHRC
ln -sf $PWD/bash/bashrc $ORIGINAL_BASHRC

echo $ORIGINAL_VIMRC
ln -sf $PWD/vim/vimrc $ORIGINAL_VIMRC

echo "$HOME/.vim/init.vim"
ln -sf $PWD/vim/vimrc $HOME/.vim/init.vim

echo $ORIGINAL_FISHCONF_FOLDER
ln -sf $PWD/fish $ORIGINAL_FISHCONF_FOLDER

echo $ORIGINAL_GITCONF
ln -sf $PWD/git/gitconfig $ORIGINAL_GITCONF

echo -e "\n\n==========  Setting default shell to fish (needs password) =========="
chsh -s /usr/bin/fish
