#! /bin/bash
#source $HOME/.diaryrc
source .diarysc
mkdir -p $DIARY_PATH
cd $DIARY_PATH
mkdir -p "корзина"
MONTHS=(января февраля марта апреля мая июня июля августа сентября октября ноября декабря)

if (( $# == 0))
then
   echo "Команда для установки программы - diary.sh install
Вывод списка команд - diary.sh help"
fi
  
createTemplate() {
 printf "Введите имя: "
 read name
 path=$DIARY_PATH/templates
 mkdir -p $path
 cd $patch
 touch "$path/$name.md" 
 exec $EDITOR "$name.md"
}

printTemplates(){
 ls $DIARY_PATH/templates -1
}

createNoteFromTemplate() {
 name="generateFile"
 printf "Введите название шаблона: "
 read file
 if [[ "${file: -2}" != ".md" ]]; then file="$file.md"
 fi
 templatePath=$DIARY_PATH/templates/$file
	if [ ! -e $templatePath ]
	then
		echo $templatePath not found
	else
                cd $DIARY_PATH/templates/
                #cp $file $d/корзина/
       
                cp $file $DIARY_PATH/$(date +%Y)/$(date +%B)/
                cd /
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

#
# Команда help | -h | --help
#

if [[ $1 == help || $1 == -h || $1 == --help ]]
then
    echo "Добро пожаловать в личный дневник!
Команды: 
add - добавить файл
backup - сделать бэкап
config -d - сменить директорию
config -e - выбрать редактор по умолчанию 
delete - удалить запись
stats - статистика"
fi

if [[ $1 == restore ]]
then
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
      file=${array[num-1]}
      cd $DIARY_PATH/корзина/
      cp $file $DIARY_PATH/${file:4:4}/${MONTHS[${file:9:2}-1]}/
      rm $file
fi

# Команда add [-t <имя_шаблона>]

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

# Команда config
#   config [-d <имя_папки_с_записями>]
#   config [-e <редактор_по_умолчанию>]

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

#
# Команда stats
#

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

if [[ $1 == backup ]]
then
    echo "backup"
fi