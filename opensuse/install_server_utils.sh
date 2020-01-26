#!/bin/bash

sudo zypper install -y --type pattern devel_basis

sudo zypper install -y vim git python-pip python3-pip\
	htop python-devel python3-devel tig curl fish\
	tmux whois wget neovim cmake pyenv\
	zlib-devel bzip2 libbz2-devel libffi-devel libopenssl-devel\
	readline-devel sqlite3 sqlite3-devel xz xz-devel

git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv


