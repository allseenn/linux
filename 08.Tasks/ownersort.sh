#!/bin/bash

dir=$1

if [ -z $dir ] || [ $dir == --help ] || [ $dir == -h ]
    then printf "usage: $0 dirname\n"
    exit 1
fi

if ! [ -d $dir ]
    then printf "$dir is not exists\n"
    exit 2
fi

f=0 d=0
for i in $(ls -1p $dir | grep -v '/' | tr ' ' '#')
    do file=$(echo $i | tr '#' ' ')
    owner=$(ls -lG  $dir/"$file" | awk '{ print $3 }')
    if ! [ -d  $owner ]
        then mkdir $owner
        ((d++))
    fi
    cp -p $dir/"$file" $owner/"$file"
    ((f++))
done

echo "$d folders was made in $PWD
$f files copied from $dir"
