#!/bin/bash

#!/bin/bash

fibonacci() {
	if [ "$1" -eq 0 ]; then
		echo 0
	elif [ "$1" -eq 1 ]; then
        	echo 1
	else
		prev1=$(fibonacci $(( $1 - 1 )))  
		prev2=$(fibonacci $(( $1 - 2 ))) 
	echo $(( prev1 + prev2 ))  
fi
}
fibonacci "$1"
