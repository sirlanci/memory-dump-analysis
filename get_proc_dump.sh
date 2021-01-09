#!/bin/bash

dir="/home/nicholai/Desktop/CWS/malw_dump/dumps"
dest_dir="/home/nicholai/Desktop/CWS/malw_dump/no_proc_dumps"
cd $dir
cwd=$(pwd)
echo $cwd

for folder in "."/* 
do
	pwd
	cd "$folder"
	echo "$folder"
	mkdir process_dump_output
	cd process_dump_output
	pdo=$(pwd)
	cd ..
	cd dump_output
	flag=0

	for entry in "."/*
	do
		filename="${entry##*/}"
		echo "$filename"
		#volatility -f $filename --profile=WinXPSP3x86 pslist | grep -i "virusshare"
		pID=$(volatility -f $filename --profile=WinXPSP3x86 pslist | grep -i "pe" | awk 'NR==1{print $3}')
		if [[ $pID ]]
		then
			echo $pID
			flag=1
			break
		else
			echo "empty"
		fi
		#strings -n 6 $filename | grep -i "calc.exe"
	done
	if [ $flag == 1 ]
	then
		i=11
		for entry in "."/*
		do
			filename="${entry##*/}"
			echo "$filename"
			volatility -f $filename --profile=WinXPSP3x86 memdump -p $pID --dump-dir $pdo
			mv "$pdo"/"$pID".dmp "$pdo"/"$pID"_"$i".dmp
			((i++))
		done
	else
		echo "No process dumps for this file ($folder)"
		mv "$dir"/"$folder" "$dest_dir"
	fi
	cd "$dir"
	echo "------------------------------------------------------"
	echo "------------------------------------------------------"
done

