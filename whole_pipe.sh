#!/bin/bash

#Usage extract_keyword.sh <vmname> <min string length> <keyword(optional)>
echo "Start"
search_dir="/home/nicholai/Desktop/CWS/malw_dump/exe"
dump_dir="/home/nicholai/Desktop/CWS/malw_dump/dumps"
for entry in "$search_dir"/*
do
	date
	filename="${entry##*/}"
	echo "Session for $filename"
	vboxmanage snapshot "Xp" restore "Ready"
	vboxmanage startvm Xp --type gui #headless
	value=0
	while [ $value != 1 ]
	do
		var=$(vboxmanage guestproperty get "Xp" "/VirtualBox/GuestInfo/OS/LoggedInUsers")
		value=${var: -1}
		sleep 4s
	done
	echo "User logged in"
	sleep 20s
	mkdir "$dump_dir"/"$filename"
	cd "$dump_dir"/"$filename"
	mkdir dump_output
	cd dump_output
	py_input=$(pwd)
	echo "File executed"
	vboxmanage guestcontrol "Xp" --username "Xp" run --exe "E:/$filename" &
	#Dump Part
	#Take memory dump
	sleep 3s
	echo "Starting to take memory dumps"
	i=11
	date
	while [ $i -le 25 ]
	do
		#echo dump number: $i
		vboxmanage debugvm $1 dumpvmcore --filename=dump$i.elf
		((i++))
		#sleep 1s
	done
	date
	i=11
	while [ $i -le 25 ]
	do
		size=0x$(objdump -h dump$i.elf | egrep -w "(load1)" | tr -s " " | cut -d " " -f 4)
		off=0x$(echo "obase=16;ibase=16;`objdump -h dump$i.elf | egrep -w "(load1)" | tr -s " " | cut -d " " -f 7 | tr /a-z/ /A-Z/`" | bc)
		head -c $(($size+$off)) dump$i.elf | tail -c +$(($off+1)) > dump$i.raw
		rm dump$i.elf
		((i++))
	done
	date
	sleep 5s
	jobs
	kill "$!"
	#Run python diff code
	sleep 10s
	cd ..
	mkdir diff
	cd diff
	py_output=$(pwd)
	vboxmanage controlvm Xp poweroff soft
	sleep 10s
	echo "Vm powered off"
	: ' echo "Diff operation started"
	python3 /home/nicholai/Desktop/Storage/python_codes/diff_two_file.py $py_input $py_output
	
	#Extract strings from diff raw files
	echo "String extraction started"
	if [ -z $3 ]
	then
		for file in *.raw
		do
		  	echo $file
		  	strings -n $2 $file  >> mdo_strings.txt
		done

	else
		for file in *.raw
		do
		  	echo $file
		  	strings -n $2 $file | grep $3  >> mdo_strings.txt
		done
	fi
	cwd=$(pwd)
	flag=1
	for entry in "$cwd"/*".raw"
	do
		filename="${entry##*/}"
		if [ $flag ==  1 ]
		then
			cat $filename > mdo.raw
			flag=0
		else
			cat $filename >> mdo.raw
		fi	
	done'

	((j++))
	#Dump End

	echo "End of session for $filename"
done
date
echo "mission completed"