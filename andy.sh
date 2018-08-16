#!/bin/bash
if [ $# -eq 0 ]
then
	echo "Andymation is available on this system! For help with commands and usage, see : https://hack4m.com/andymation"
	exit
fi

osName=""
osVersion=""
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


#Get os and version
getLinuxDistro(){
	. /etc/os-release
	
	osName=$ID
	osVersion=$VERSION_ID
}

#Get Operation system
findOS(){

	osName=$(uname)

	case $osName in
		Darwin) osName="osx"; osVersion=$(sw_vers -productVersion);;
		Linux)  getLinuxDistro;;
		*)		osName="other";;
	esac
}


#Execute andymation
andy_exec(){

	toolMetaFile="$toolsDir/$1/tool.json"
	#python "$andyLocation/readJson.py" "$toolsDir/$1/tool.json" supported_os ubuntu
	findOS
	echo $osName
	echo $osVersion

}


if toolexists $1  
then
	andy_exec $1
else 
	echo "Tool $1 not available, fetching it..."
	echo "Updating tools directory..."
	updatetools
fi