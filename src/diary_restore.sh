#! /bin/bash

if [[ $1 == restore ]]
then
      if [ `ls $DIARY_PATH/корзина/ | wc -l` -eq 0 ] 
	then
    		echo "Корзина пуста"
	else
    		echo "Файлы в корзине:"
      		i=1
      		for entry in "$DIARY_PATH/корзина"/*
      		do
        		echo "$i) ${entry: -23}"
        		i=$((i+1))
        		array+=("${entry: -23}")
      		done
      		echo "Введите номер файла:"
      		read num
      		if [ $num -le ${#array[@]} ] && [ $num -ge 1 ] 
      		then 
      			file=${array[num-1]}
      			cd $DIARY_PATH/корзина/
      			cp $file $DIARY_PATH/${file:4:4}/${MONTHS[${file:9:2}-1]}/
      			rm $file
      		else echo "Неверный номер"
      		fi	
	fi
fi
