#! /bin/bash

if [[ $1 == delete ]]
then
    #cd /
    cd $DIARY_PATH
    printf "Введите название файла: "
    read file
    if [[ "${file: -3}" != ".md" ]]; then file="$file.md"
    fi
    flag=0
    for entry in "$DIARY_PATH"/*
    do
        for entry2 in "$entry"/*
        do
		l=$entry2/$file
            	if [ -e $l ];
            	then
            		flag=1
            	fi
        done
    done
    if [ "$flag" == "0" ]
	then 
	    echo "$file не найден"
	else 
		cd ${file:4:4}
    		cd ${MONTHS[${file:9:2}-1]}
    		cp $file $DIARY_PATH/корзина
    		rm $file
    fi 
fi