#!/bin/bash
if [ $# -eq 0 ]
then
	echo "Andymation is available on this system! For help with commands and usage, see : https://hack4m.com/andymation"
	exit
fi

gu
osName=""
devMod=true
andyLocation="$HOME/.andy"
toolsDir="$andyLocation/tools"

#checks if directory exists
direxists(){

	if [ -d "$1" ] 	
	then
		return 0
	fi

	return 1
}

#Checks if a command/tool exists localy
toolexists(){
	if  direxists "$toolsDir/$1" 
	then
		return 0
	fi

	return 1
}


#Updates commands/tools from git [master]
updatetools(){

	if direxists "$andyLocation" 
	then
		echo "Overriding $HOME/.andy..."
		sudo rm -fr "$andyLocation"
	fi


	if $devMod
	then
		echo "Cloning from development branch..."
		git clone -b development https://github.com/hack4mer/andymation.git ~/.andy/
	else
		echo "Cloning from production branch..."
		git clone https://github.com/hack4mer/andymation.git ~/.andy/
	fi	
}


#Get linux distro name
getOS(){
	if [ -f /etc/os-release ]; then
	    # freedesktop.org and systemd
	    . /etc/os-release
	    OS=$NAME
	    VER=$VERSION_ID
	elif type lsb_release >/dev/null 2>&1; then
	    # linuxbase.org
	    OS=$(lsb_release -si)
	    VER=$(lsb_release -sr)
	elif [ -f /etc/lsb-release ]; then
	    # For some versions of Debian/Ubuntu without lsb_release command
	    . /etc/lsb-release
	    OS=$DISTRIB_ID
	    VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
	    # Older Debian/Ubuntu/etc.
	    OS=Debian
	    VER=$(cat /etc/debian_version)
	elif [ -f /etc/SuSe-release ]; then
	    # Older SuSE/etc.
	    ...
	elif [ -f /etc/redhat-release ]; then
	    # Older Red Hat, CentOS, etc.
	    ...
	else
	    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
	    OS=$(uname -s)
	    VER=$(uname -r)
	fi
}

#Get Operation system
findOS(){

	osName=$(uname)

	case $osName in
		Darwin) osName="osx";;
		Linux)  osName="linux";;
		*)		osName="other";;
	esac
}


#Execute andymation
andy_exec(){

	toolMetaFile="$toolsDir/$1/tool.json"
	#python "$andyLocation/readJson.py" "$toolsDir/$1/tool.json" supported_os ubuntu
	findOS
	checkOSsupport
	getOS
	echo $OS
	echo $VER
	echo $osName

}


if toolexists $1  
then
	andy_exec $1
else 
	echo "Tool $1 not available, fetching it..."
	echo "Updating tools directory..."
	updatetools
fi