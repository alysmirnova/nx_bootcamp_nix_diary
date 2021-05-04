#! /bin/bash

if [[ $1 == config ]]
then
    if [[ $2 == -d ]]
    then
    	printf "Введите полный путь: "
    	read way
    	if [ -e $way ]
    	then 
    		cat ~/.diaryrc | grep $DIARY_PATH > ~/.diaryrc
    		echo "DIARY_PATH=$way
EDITOR=$EDITOR" >> ~/.diaryrc
    		mkdir -p $way
    		cd $way
    	else echo "Каталог не найден"
    	fi
    fi
    
    if [[ $2 == -e ]]
    then 
       printf "Введите путь до программы: "
       read way
       if [ -e $way ]
       then 
       	cat ~/.diaryrc | grep $EDITOR > ~/.diaryrc
       	echo "EDITOR=$way
DIARY_PATH=$DIARY_PATH" >> ~/.diaryrc
       else echo "$way не найден"
       fi	          
    fi
fi
