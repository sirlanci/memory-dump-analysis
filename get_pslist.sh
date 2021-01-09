#!/bin/bash

dir="/home/nicholai/Desktop/CWS/malw_dump/new_dumps"
#dest_dir="/home/nicholai/Desktop/malw_dump/exe"
#cd $search_dir
cd "$dir"
cwd=$(pwd)
echo $cwd

for folder in "."/*
do
	cd "$folder"
	pwd
	cd dump_output
	for entry in "."/*
	do
		filename="${entry##*/}"
		echo "$filename"
		volatility -f $filename --profile=WinXPSP3x86 pslist | grep -i "virusshare"
		#strings -n 6 $filename | grep -i "calc.exe"
	done
	cd ..
	cd ..
	echo "------------------------------------------------------"
	echo "------------------------------------------------------"
done
