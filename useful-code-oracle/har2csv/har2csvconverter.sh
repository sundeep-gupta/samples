#!/bin/sh
# Script to convert .har file to .csv file
# Provide LRG results folder path (for farm run) or T_WORK path(for local run)
path=$1


dest=$(pwd)

find $path -name '*.har.zip' > ./harfiles.txt

sh copyallharzip.sh harfiles.txt

find . -name '*.har.zip' -exec unzip '{}' ';'

mkdir HARFOLDER

mv *.har ./HARFOLDER


#cd com/har/

#javac -cp .:$dest/com/har/harparser.jar:$dest/com/har/jersey-json-1.9-SNAPSHOT.jar Hartocsvconvertertool.java 

cd $dest


java -cp .:$dest/com/har/harparser.jar:$dest/com/har/jersey-json-1.9-SNAPSHOT.jar com.har/Hartocsvconvertertool $dest


rm -rf HARFOLDER harfiles.txt *.har.zip
