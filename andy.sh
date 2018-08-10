if [ $# -eq 0 ]
then
	echo "Andymation is available on this system! For help with commands and usage, see : https://hack4m.com/andymation"
	exit
fi


updatetools(){
	git clone https://github.com/hack4mer/andymation.git ~/.andy/ 2>/dev/null
}

toolexists(){
	if [ -d "$HOME/.andy/tools/$1" ] 	
	then
		return 1
	fi

	return 0
}

if [ $(toolexists $1) -eq 0 ]; 
then 
	echo "Tool $1 not available, fetching it..."
	echo "Updating tools directory..."
	updatetools
else
	echo "tool found"
fi

