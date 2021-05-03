#! /bin/bash

if [[ $1 == config ]]
then
    if [[ $2 == -d ]]
    then
    	printf "Введите полный путь: "
    	read way
    	cat ~/.diarysc | grep $DIARY_PATH > ~/.diarysc
    	echo "DIARY_PATH=$way
EDITOR=$EDITOR" >> ~/.diarysc
    	mkdir -p $way
    	cd $way
    fi
    if [[ $2 == -e ]]
    then 
       printf "Введите путь до программы: "
       read way
       cat ~/.diarysc | grep $EDITOR > ~/.diarysc
       echo "EDITOR=$way
DIARY_PATH=$DIARY_PATH" >> ~/.diarysc
    fi
fi
