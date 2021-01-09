#!/bin/bash

#Usage extract_keyword.sh <min string length> <raw files location> <keyword(optional)>
#For multiple keyword <word1\|word2\|word3>

cd $2

if [ -z $3 ]
then
	for file in *.raw
	do
  		echo $file
  		strings -n $1 $file  >> file_mdo.txt
	done

else
	for file in *.raw
	do
  		echo $file
  		strings -n $1 $file | grep $3  >> file_mdo.txt
	done
fi
