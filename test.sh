#!/bin/bash

: ${SERVICE:=" "}  #modify
: ${file:="/storage/"}

set -e -u

Create(){
	read -p "put your folder name..." SERVICE
	  for ser in `ls $file`
	  do 
	    if [ $SERVICE == $ser ] 
	    	then 
	        echo "loop"
	        Create
	        exit 1
	   	fi
	  done
	  echo "te"
	  mkdir -p "/storage/${SERVICE}"
}

command="$1"
shift
case "${command}" in
  'start' ) Start "$@";;
  'create') Create ;;
  *) echo "no such command: ${command}" >&2;;
esac