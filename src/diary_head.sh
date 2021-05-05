#! /bin/bash

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
