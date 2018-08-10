#!/bin/bash

#check for dependencies
# TODO : Automate the installation of depedencies
hash curl 2>/dev/null || { echo >&2 'Installtion Failed : Please install "curl" and verify it by running the command "curl --help" and retry'; exit 1; }
hash git 2>/dev/null || { echo >&2 'Installtion Failed : Please install "git" and verify it by running the command "git" and retry'; exit 1; }

script_url="https://raw.githubusercontent.com/hack4mer/andymation/master/andy.sh"

echo "Installing andymation(andy)..."
echo "Downloading source..."



if $(curl "$script_url" -o andy)
then
	sudo chmod +x andy
	sudo mv andy /usr/bin
	echo 'Installation complete, run the command "andy" for details'
else
	echo "Download failed, check connectivity to the url : $script_url"
fi
