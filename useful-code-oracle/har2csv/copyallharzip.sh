FILENAME=$1

count=0

while read LINE

do
cp $LINE .

let count++

done < $FILENAME
