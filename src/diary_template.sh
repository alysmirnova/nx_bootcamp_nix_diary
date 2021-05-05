#! /bin/bash
  
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
