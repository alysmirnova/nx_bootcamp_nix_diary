#! /bin/bash

if [[ $1 == delete ]]
then
    #cd /
    cd $DIARY_PATH
    printf "Введите название файла: "
    read file
    if [[ "${file: -3}" != ".md" ]]; then file="$file.md"
    fi 
    cd ${file:4:4}
    cd ${MONTHS[${file:9:2}-1]}
    cp $file $DIARY_PATH/корзина
    rm $file
fi
