#!/bin/bash
# usage: age+.sh [old|new] [/path_to_folder/]
#
# defaults to oldest file in current folder
usage()
{
cat << EOF
usage: age+.sh [o|n] [/path_to_folder/]
Displays news or oldest age of file in a given folde
OPTIONS:
-o displays oldest file
-n newest file in folder
-x exit
EXAMPLES:
age+.sh o /path_to_folder/ displays oldest file in folder
age+.sh n /path_to_folder/ displays newest file in folder
EOF
}
getage()
{
# let's make sure that the folder exists
if [ -z "$1" ]; then
echo "Error: you must specify a directory name"
usage
exit 1
fi
time_now=`date +%s`
filetime=`stat -c %Y $1`
time_diff=$(( ($time_now - $filetime) ))
UNIT="secs"
if [ $time_diff -gt 60 ]
then
time_diff=$(($time_diff/60))
UNIT="min."
if [ $time_diff -gt 60 ]
then
time_diff=$(($time_diff/60))
UNIT="hrs"
fi
fi
#echo "$2 $time_oldest $UNIT"
echo "$1 file [$2] is $time_diff $UNIT ago."
exit 1;
}
while getopts ":o :n" opt; do
case "$opt" in
o)
dirname="$2"
echo "Finding in location $dirname"
if [ -z "$dirname" ]
then
echo "[Current folder]"
OLDEST=$(find . -maxdepth 1 -type f \( ! -iname ".*" \) | cut -c3- |xargs ls -tr | head -1)
else
OLDEST=$(find $dirname -maxdepth 1 -type f \( ! -iname ".*" \) | cut -c1- | xargs ls -tr | head -1)
fi
getage $OLDEST "oldest"
;;
n)
dirname="$2"
echo "Finding in location [$dirname]"
if [ -z "$dirname" ]
then
echo "[Current folder]"
NEWEST=$(find . -maxdepth 1 -type f \( ! -iname ".*" \) | cut -c3- |xargs ls -t | head -1)
else
NEWEST=$(find $dirname -maxdepth 1 -type f \( ! -iname ".*" \) | cut -c1- | xargs ls -t | head -1)
fi
getage $NEWEST "newest"
;;
x) exit
echo "Exiting..."
;;
\?) echo "$OPTARG is an unknown option"
usage
exit 1
;;
*)
usage
;;
esac
done
