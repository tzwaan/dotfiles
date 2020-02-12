#!/bin/bash
lecho() {
    echo -e "\n\n==========  $@  =========="
}
secho() {
    echo -e "==========  ....  $@ =========="
}

BACKUP_DIR=$PWD/backup/
ORIGINAL_BASHRC=$HOME/.bashrc
ORIGINAL_VIMRC=$HOME/.vimrc
ORIGINAL_FISHCONF_FOLDER=$HOME/.config/fish
ORIGINAL_GITCONF=$HOME/.gitconfig

mkdir -p $HOME/.config

# Backup current dotfiles
declare -a Files=("$ORIGINAL_BASHRC" "$ORIGINAL_VIMRC" \
    "$ORIGINAL_FISHCONF_FOLDER" "$ORIGINAL_GITCONF")

lecho "Making backups of existing files"
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

lecho "Creating vim folders"
mkdir -p $HOME/.vim/{autoload,colors}
ln -snf $HOME/.vim $HOME/.config/nvim

lecho "Installing vim-plug plugin managers"
secho "Installing nvim vim-plug"
wget -O ~/.config/nvim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

secho "Installing vim Vundle"
if [[ ! -d $HOME/.vim/bundle/Vundle.vim ]]
then
    echo -e "  Cloning to ~/.vim/bundle/Vundle.vim"
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
else
    echo -e "  Vundle.vim directory already exists. Skipping install"
fi

secho "Installing vim Vundle plugins"
vim +PluginInstall +qall


lecho "Creating symlinks to dotfiles"
echo $ORIGINAL_BASHRC
ln -snf $PWD/bash/bashrc $ORIGINAL_BASHRC

echo $ORIGINAL_VIMRC
ln -snf $PWD/vim/vimrc $ORIGINAL_VIMRC

echo "$HOME/.vim/init.vim"
ln -snf $PWD/vim/vimrc $HOME/.vim/init.vim

echo $ORIGINAL_FISHCONF_FOLDER
ln -snf $PWD/fish $ORIGINAL_FISHCONF_FOLDER

echo $ORIGINAL_GITCONF
ln -snf $PWD/git/gitconfig $ORIGINAL_GITCONF

lecho "Set default shell to fish?  (needs password)"
read -p "Set fish (y/n):  " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    chsh -s /usr/bin/fish
fi
