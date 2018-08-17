#!/bin/bash
if [ $# -eq 0 ]
then
	echo "Andymation is available on this system! For help with commands and usage, see : https://hack4m.com/andymation"
	exit
fi

devMod=false

toolName=$1
osCode=""
osVersion=""
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
		git clone -b development --recursive  https://github.com/hack4mer/andymation.git ~/.andy/
	else
		echo "Cloning from production branch..."
		git clone  --recursive https://github.com/hack4mer/andymation.git ~/.andy/
	fi	
}


#Get os and version
getLinuxDistro(){
	. /etc/os-release
	
	osCode=$ID
	osVersion=$VERSION_ID
}

#Get Operation system
findOS(){

	osCode=$(uname)

	case $osCode in
		Darwin) osCode="osx"; osVersion=$(sw_vers -productVersion);;
		Linux)  getLinuxDistro;;
		*)		osCode="other";;
	esac
}


isGreater() {
   awk -v n1="$1" -v n2="$2" 'BEGIN {printf " " (n1<n2?"0":"1") " ", n1, n2}'
}

#Check os support
verifyOS(){


	min_os_version=$(python "$andyLocation/readJson.py" "$toolsDir/$1/tool.json" supported_os $osCode min_version)


	if [[ ${#min_os_version} -eq "0" ]]; then
		#OS meta is not present in tool.json
		return 1
	fi

	if [[ "1" -eq "$(isGreater  $osVersion $min_os_version)" ]]; then
		return 0
	fi

	return 1
}


#Execute andymation
andy_exec(){

	toolMetaFile="$toolsDir/$1/tool.json"

	#Assign values to the osCode and osVersion variables
	findOS

	#Check for minimum version support
	if verifyOS $toolName ; then
		#OS is supported, can proceed with the execution

		echo "Executing $toolName"
		echo "-----------------------"
		sh "$toolsDir/$1/tool.sh"
	else
		echo "$toolName does not support $(uname)! Exiting."
		exit 1
	fi
	
}


if toolexists $1  
then
	andy_exec $1
else 
	echo "Tool $1 not available, fetching it..."
	echo "Updating tools directory..."
	updatetools
	andy_exec $1
fi