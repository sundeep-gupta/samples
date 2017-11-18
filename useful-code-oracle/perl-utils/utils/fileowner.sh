#!/usr/bin/ksh
#label=`ade catcs | grep VIEW_LABEL | awk '{print $3}' | awk -F'_' -v us=',' '{print $1 us $2 us $3}'`
label=EMGC,MAIN,LINUX.X64

if [ ! -z "$1" ]; then
 label=EMCORE,MAIN,LINUX.X64
fi

/usr/local/bin/mergereq --remove --lrg 0 --check <<EOF | tee  tmp1.mrq.log 2>&1
--check
EOF

grep "mergereq: ERROR: EMOWNCHK-TEST:" tmp1.mrq.log | sed -e 's/mergereq: ERROR: EMOWNCHK-TEST://g' > file_without_owner.txt

if [ -z "$FODB_DEV_MGR" ]; then
   dev_mgr=rkhandel
else
   dev_mgr=$FODB_DEV_MGR
fi

if [ -z "$FODB_AREA" ]; then
   area="Test#Tools"
else
   area=$FODB_AREA
fi

if [ -z "$FODB_OWNER" ]; then
   own=$USER
else
   own=$FODB_OWNER
fi

#params="$own,rkhandel,${label},$dev_mgr,test,,rkhandel,$area,,,,0"
params="$own,rkhandel,${label},$dev_mgr,test,,rkhandel,Test#Tools,,,,0"
cat file_without_owner.txt | grep -v FILES | awk -v pr=$params '{n=split($1,x,"/");m=gsub(x[n],"",$1);print x[n] ","  $1 "," pr}' | sed -e 's/#/ /g' > file_without_owner.csv

exit 0

echo $PWD
#/usr/local/packages/intg/sttools/bin/fileowner.pl bulkins -u ssherrif -p Ssfirst1 <<EOF
/usr/local/packages/intg/sttools/bin/fileowner.pl bulkins -u $USER <<EOF
$PWD/file_without_owner.csv
$PWD/file_without_owner.log
EOF
