#! /bin/bash
  
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
                cd $DIARY_PATH/templates
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