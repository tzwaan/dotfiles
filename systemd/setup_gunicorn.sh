#!/bin/bash
cd "$(dirname "$0")"


ln -snf $PWD/system/gunicorn.socket /etc/systemd/system/gunicorn.socket
ln -snf $PWD/system/gunicorn.service /etc/systemd/system/gunicorn.service

