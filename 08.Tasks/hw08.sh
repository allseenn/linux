#!/bin/bash

dir=$1
ext="bak tmp backup"

if [ -z $dir ] || [ $dir == --help ] || [ $dir == -h ]
    then printf "usage: $0 dirname\n"
    exit 1
fi

count=$(ls -1 $dir | wc -l)
for i in $ext
    do rm -f *.$i
done

printf "$count files was deleted\n"
