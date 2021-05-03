#! /bin/bash

if [[ $1 == stats ]]
then 
    echo "Статистика:"
    printf "1) сколько всего записей - "
    n=$(ls $DIARY_PATH -laR | grep ^- | wc -l)
    echo $((n-1))
    printf "2) когда была сделана последняя запись - "
    file=$(find $DIARY_PATH -type f -print0 |xargs -0 stat -c"%Y %n"|sort -k1,1nr|head -1|sed 's_^[^ ]\+ __')
    file=${file: -23}
    echo "${file:12:2}.${file:9:2}.${file:4:4} ${file:15:2}:${file:18:2}"
    echo "3) сколько записей сделано за каждый год и месяц"
    for entry in "$DIARY_PATH"/*
    do
        if [[ $entry != "$DIARY_PATH/корзина" ]]; then
            n=$(ls $entry -laR | grep ^- | wc -l)
            echo "${entry: -11} - $n"
        fi
        for entry2 in "$entry"/*
        do
            if [[ $entry != "$DIARY_PATH/корзина" ]]; then
                m=$(ls $entry2 -laR | grep ^- | wc -l) 
                echo "  ${entry2:19} - $m"
            fi
        done
     done
     echo "4) самая длинная запись в дневнике"
     file=$(find $DIARY_PATH -name "*.md" -type f -printf "%s %p\n" | sort -rn | head -n 1)
     echo "${file: -23}:"
     file=${file:2}
     cat $file 
fi
