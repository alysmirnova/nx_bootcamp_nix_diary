#! /bin/bash

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
