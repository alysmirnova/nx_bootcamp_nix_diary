#! /bin/bash

if [[ $1 == add ]]
then
    if [[ $2 == -t ]]  
    then
        createNoteFromTemplate
    else
        mkdir -p $DIARY_PATH/$(date +%Y)/$(date +%B)/
        cd $DIARY_PATH/$(date +%Y)/$(date +%B)/  
        touch ID__$(date +"%F_%H-%M").md
        exec $EDITOR ID__$(date +"%F_%H-%M").md <&-
    fi      
fi
