if [ $# -eq 0 ]
then
	echo "Andymation is available on this system! For help with commands and usage, see : https://hack4m.com/andymation"
	exit
fi

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

#checks if a command/tool exists localy
toolexists(){
	if  direxists "$toolsDir/$1" 
	then
		return 0
	fi

	return 1
}


#updates commands/tools from git [master]
updatetools(){

	if direxists "$andyLocation" 
	then
		echo "Overriding $HOME/.andy..."
		sudo rm -fr "$andyLocation"
	fi

	git clone https://github.com/hack4mer/andymation.git ~/.andy/
}


andy_exec(){

	toolMetaFile="$toolsDir/$1/tool.json"
	python "$andyLocation/readJson.py" name

}


if toolexists $1  
then
	andy_exec $1
else 
	echo "Tool $1 not available, fetching it..."
	echo "Updating tools directory..."
	updatetools
fi