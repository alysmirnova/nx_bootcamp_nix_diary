#! /bin/bash

if [[ $1 == last ]]
then 
	$(find $DIARY_PATH -type f -print0 |xargs -0 stat -c"%Y %n"|sort -k1,1nr|head -5|sed 's_^[^ ]\+ __')
fi
