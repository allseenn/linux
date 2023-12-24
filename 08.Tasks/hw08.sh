#!/bin/bash

dir=$1
ext="bak tmp backup"

if [ -z $dir ] || [ $dir == --help ] || [ $dir == -h ]
    then printf "usage: $0 dirname\n"
    exit 1
fi

if ! [ -d $dir ]
    then printf "$dir is not exists\n"
    exit 2
fi

count=0
for i in $ext
    do ((count+=$(ls -1 $dir/*.$i | wc -l)))
    rm -f $dir/*.$i
done

printf "$count files was deleted\n"
