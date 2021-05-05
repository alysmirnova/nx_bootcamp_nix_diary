#! /bin/bash

brc=$(grep "~/diary.sh" ~/.bashrc)
if [ -z "$brc" ]
  then echo "source ~/diary.sh" >> .bashrc
fi

source .diaryrc
mkdir -p $DIARY_PATH
cd $DIARY_PATH
mkdir -p "корзина"
MONTHS=(января февраля марта апреля мая июня июля августа сентября октября ноября декабря)

if (( $# == 0))
then
    echo "Команда для установки программы - compile.sh
Вывод списка команд - diary.sh help"
fi
  
createTemplate() {
    printf "Введите имя: "
    read name
    path=$DIARY_PATH/шаблоны
    mkdir -p $path
    cd $patch
    touch "$path/$name.md" 
    exec $EDITOR "$name.md"
}

printTemplates(){
    ls $DIARY_PATH/шаблоны -1
}

createNoteFromTemplate() {
	i=1
    for template in "$DIARY_PATH/шаблоны"/*
    do
        echo "$template"
    done
    
    printf "Введите название файла: "
    read file
    
    if [[ ${file: -2} != "md" ]];
    then file="$file.md"
    fi
    cd $DIARY_PATH/шаблоны
    echo $file
    if [ ! -e $file ]
    then
        echo $file не найден
    else
		cp $file $DIARY_PATH/$(date +%Y)/$(date +%B)/
		cd $DIARY_PATH/$(date +%Y)/$(date +%B)/
    	mv $file ID__$(date +"%F_%H-%M").md
		exec $EDITOR ID__$(date +"%F_%H-%M").md
	fi	
}

if [[ $1 == template ]]
then
    createTemplate
    printTemplates
fi

if [[ $1 == help || $1 == -h || $1 == --help ]]
then
    echo "Добро пожаловать в личный дневник!
Команды: 
add - добавить файл
add -t - добавить файл с выбором шаблона
config -d - сменить директорию
config -e - выбрать редактор по умолчанию 
delete - удалить запись
restore - восстановить запись
template - создать шаблон
stats - статистика"
fi

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
      	while ! [[ $num =~ $re  &&  $num -le ${#array[@]}  &&  $num -ge 1 ]]
    	do
    		echo "Ошибка"
    		printf "Введите номер: "
			read num
    	done   	
      	file=${array[num-1]}
      	cd $DIARY_PATH/корзина/
      	cp $file $DIARY_PATH/${file:4:4}/${MONTHS[${file:9:2}-1]}/
      	rm $file
    fi
fi

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

re='^[0-9]+$'

if [[ $1 == open ]]
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
    then exec $EDITOR $month	
    fi
    
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
    exec $EDITOR $file	
fi      

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

if [[ $1 == stats ]]
then 
    echo "Статистика:"
    printf "1) сколько всего записей - "
    n=$(ls $DIARY_PATH -laR | grep ^- | wc -l)
    echo $((n-1))
    printf "2) когда была сделана последняя запись - "
    file=$(find $DIARY_PATH -path $DIARY_PATH/templates -prune -false -o -type f -print0 |xargs -0 stat -c"%Y %n"|sort -k1,1nr|head -1|sed 's_^[^ ]\+ __')
    file=${file: -23}
    echo "${file:12:2}.${file:9:2}.${file:4:4} ${file:15:2}:${file:18:2}"
    echo "3) сколько записей сделано за каждый год и месяц"
    for entry in "$DIARY_PATH"/*
    do
        if [[ $entry != "$DIARY_PATH/корзина" &&  $entry != "$DIARY_PATH/templates" ]]; 
        then
            n=$(ls $entry -laR | grep ^- | wc -l)
            echo "${entry: -11} - $n"
        fi
        for entry2 in "$entry"/*
        do
            if [[ $entry != "$DIARY_PATH/корзина" && $entry != "$DIARY_PATH/templates" ]]; 
            then
                m=$(ls $entry2 -laR | grep ^- | wc -l) 
                echo "  ${entry2:19} - $m"
            fi
        done
     done
     echo "4) самая длинная запись в дневнике"
     file=$(find $DIARY_PATH -path $DIARY_PATH/templates -prune -false -o -name "*.md" -type f -printf "%s %p\n" | sort -rn | head -n 1)
     echo "${file: -23}:"
     file=${file:2}
     cat $file 
fi

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
