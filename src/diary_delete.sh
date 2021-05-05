#! /bin/bash

if [[ $1 == delete ]]
then
    i=1
    for year in "$DIARY_PATH"/*
    do
        if [[ "${year: -7}" != "корзина" ]]
        then
            echo "$i - $year"
            i=$((i+1))
            arr_year+=("$year")
        fi
    done
    printf "Введите номер: "
    read num
    while ! [[ $num =~ $re  &&  $num -le ${#arr_year[@]}  &&  $num -ge 1 ]]
    do
    	echo "Ошибка"
    	printf "Введите номер: "
	read num
    done
    
    i=1
    for month in "${arr_year[num-1]}"/*
    do
    	echo "$i - $month"
    	i=$((i+1))
    	arr_month+=("$month")
    done
    
    printf "Введите номер: "
    read num2
    while ! [[ $num2 =~ $re  &&  $num2 -le ${#arr_month[@]}  &&  $num2 -ge 1 ]]
    do
    	echo "Ошибка"
    	printf "Введите номер: "
	read num2
    done
    
    if [[ "${arr_year[num-1]: -7}" == "шаблоны" ]];
    then 
    	cp $month $DIARY_PATH/корзина
    	rm $month	
    else
    	i=1
    	for file in "${arr_month[num2-1]}"/*
    	do
    	    echo "$i - $file"
    	    i=$((i+1))
    	    arr_file+=("$file")
    	done
    	printf "Введите номер: "
    	read num
    	while ! [[ $num =~ $re  &&  $num -le ${#arr_file[@]}  &&  $num -ge 1 ]]
    	do
    	    echo "Ошибка"
    	    printf "Введите номер: "
	    read num
    	done
    	cp $file $DIARY_PATH/корзина
    	rm $file	
    fi 
fi
