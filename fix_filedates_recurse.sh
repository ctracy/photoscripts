#!/bin/zsh

for i in *
do
 echo $i
 /opt/local/bin/exiftool "-DateTimeOriginal>FileModifyDate" $i/*
done

