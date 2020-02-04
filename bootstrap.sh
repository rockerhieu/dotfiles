#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

current_dir=$(pwd)

for file in \.*
do
	if [[ ("$file" = ".DS_Store") || ("$file" = ".") || ("$file" = "..") || ("$file" = ".git") ]]; then
		echo "Skip $file"
	else
		if [[ ! -f "~/$file" ]]; then
			ln -s -f "$current_dir/$file" ~
			echo "$current_dir/$file -> ~/$file"
		else
			read -p "~/$file exists, do you want to override it? (y/n) " -n 1;
			echo "";
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				ln -s -f "$current_dir/$file" ~
				echo "$current_dir/$file -> ~/$file"
			fi;
		fi
	fi
done

unset current_dir