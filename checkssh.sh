#!/usr/local/bin/bash
# Tests whether ssh connection works

if [ ! -z $1 ];
then
    FILE=$1
else
    FILE=serverlist
fi
while read i; 
do
	echo -n ".";
	CHK=`ssh -q -o "BatchMode yes" -o "ConnectTimeout 5" -l root $i "echo success"`;
	if [ ! "success" = $CHK ] >/dev/null 2>&1 
	then
		echo $i >>checkssh_failure
	fi
done <$FILE
echo ""
echo "Done!"
echo "Check the list 'checkssh_failure' for errors."
exit 0
