#!/bin/bash

: ${SERVICE:=" "}  #modify
: ${CPU:=100}
: ${MEMORY:=100M}
: ${DISK:=5G}
: ${file:="/storage/"}

set -e -u

if ! test "$(whoami)" = 'root'; then
  echo 'this script must run as root.' >&2
  exit 1
fi

DockerInstall() {
  DOCKER_FLAGS+=(
      --volume="/storage/${SERVICE}:/home/cloud-admin"
      --memory="${MEMORY}" --cpu-shares="${CPU}"
  )
   SUBSTRING=$(docker run "${DOCKER_FLAGS[@]}" "sa:latest" "$@")
   sub=${SUBSTRING:0:12}
   echo $SUBSTRING $SERVICE>>/tmp/dockerContainerID.txt
   docker attach $sub
}

DockerStart() {
  DOCKER_FLAGS+=(
      --volume="/storage/${SERVICE}:/home/cloud-admin"
      --memory="${MEMORY}" --cpu-shares="${CPU}"
  )
   SUBSTRING=$(docker run "${DOCKER_FLAGS[@]}" "sa:latest" "$@")
}

Start() {
  for SERVICE in `ls $file`
  do
    echo SERVICE=$SERVICE
    DOCKER_FLAGS=(--detach)
    DockerStart /bin/bash /config/setup.sh
  done 
}
 
Install() {

  # read -p "put your folder name..." SERVICE
  SERVICE=$(whiptail --title "put your dropbox directory name..." --inputbox "What is your dropbox directory name?" 10 60  3>&1 1>&2 2>&3)
  exitstatus=$?
    if [ $exitstatus != 0 ]; then
        echo "You chose Cancel."
        exit 1
    fi
  for ser in `ls $file`
  do 
      if [ $SERVICE == $ser ] 
        then 
          whiptail --title "Message Box" --msgbox "Dropbox directory name is already. Choose Ok to continue." 10 60
          Install
          exit 1
      fi
    done
    mkdir -p "/storage/${SERVICE}"
    echo SERVICE=$SERVICE
  DOCKER_FLAGS=(--detach)
  DockerInstall /bin/bash /config/setup.sh
}

command="$1"
shift
case "${command}" in
  'start') Start "$@";;
  'install') Install;;
  *) echo "no such command: ${command}" >&2;;
esac
