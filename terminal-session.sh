#!/bin/bash
##
## This is bash script for saving and loading gnome-terminal session. Special for Ubuntu.
##
## Usage: ./terminal-session -s <name_profile> - for save session
##        ./terminal-session -l <name_profile> - for load existing session
##        ./terminal-session --profiles - for show existing session files
##
## Instructions:
##  - Run gnome-terminal;
## 	- $ touch terminal-session;
##  - $ chmod +x terminal-session;
##  - Copy whole this code in the file;
##
## For convenience you can move this file in /usr/bin/

# Source: https://gist.github.com/3803925

session_path=$HOME/.terminal-session

if [ ! -d "$session_path" ]; then
  mkdir $session_path
fi

if [[ $1 == "-s" ]]; then
  if [[ $2 ]]; then gnome-terminal --save-config=$session_path/$2; fi
elif [[ $1 == "-l" ]]; then
  if [[ $2 ]]; then gnome-terminal --load-config=$session_path/$2 2> /dev/null; fi
elif [[ $1 == "--profiles" ]]; then
  ls $session_path
fi
