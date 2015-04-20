#!/bin/bash

DISTROS=$(whiptail --title "Test Checklist Dialog" --radiolist \
   "What is the Linux distro of your choice?" 15 60 4 \
   "START" "Start Dropbox Directory" OFF \
   "INSTALL" "Install New Dropbox Account" OFF 3>&1 1>&2 2>&3)
 
exitstatus=$?
   if [ $exitstatus = 0 ]; then
      echo "The chosen distro is:" $DISTROS
         if [ $DISTROS = "START" ]; then
            ./run.sh
         elif [ $DISTROS = "INSTALL" ]; then
            ./install.sh
         fi
   else
       echo "You chose Cancel."
   fi