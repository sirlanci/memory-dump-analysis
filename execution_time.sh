#!/bin/bash
#C:/WINDOWS/system32/calc.exe

echo "alalalal"
search_dir="/home/nicholai/Desktop/CWS/malw_dump/exe"
chosen_folder="/home/nicholai/Desktop/CWS/malw_dump/chosen_ones/"
total_time=0
number_of_file=0
timeouted_file=0
n_of_file=0
t_time=0
a_time=0
for entry in "$search_dir"/*
do
	filename="${entry##*/}"
	echo $filename
	vboxmanage snapshot "Xp" restore "Ready"
	vboxmanage startvm Xp --type gui #headless
	echo "222"
	value=0
	while [ $value != 1 ]
	do
		var=$(vboxmanage guestproperty get "Xp" "/VirtualBox/GuestInfo/OS/LoggedInUsers")
		value=${var: -1}
		sleep 5s
	done
	echo "Logged In"
	sleep 15s

	echo "File Executed.."
	TIMEFORMAT="%E"
	tm=$(time (timeout 30 vboxmanage guestcontrol "Xp" --username "Xp" run --exe "E:/$filename" > thrash.txt 2>error.txt) 2>&1)
	tm=$(echo $tm | tr "," ".")
	tm_without_comma=$(echo $tm | tr -d .)
	echo $tm >> timee.txt
	echo "Execution time of this file"
	echo $tm

	if [ $tm_without_comma -gt "30000" ]
	then
		timeouted_file=$(($timeouted_file + 1))
	else
		cp "$search_dir"/"$filename" "$chosen_folder"
		n_of_file=$(($n_of_file + 1))
		t_time=$(bc <<< "$t_time + $tm")
	fi

	number_of_file=$(($number_of_file + 1))
	total_time=$(bc <<< "$total_time + $tm")
	#sleep 10s
	#kill "$!"
	sleep 10s
	echo "Vm shutting down"
	vboxmanage controlvm Xp poweroff soft
	sleep 10s
	echo "finnish"
done

echo Number of file terminated with timeout: $timeouted_file
echo Total time: $total_time
echo Number of file: $number_of_file
average_time=$(bc <<< "$total_time / $number_of_file")
echo Avarage Time: $average_time
echo "-------------------------------------------------------"
echo T time: $t_time
echo N of file: $n_of_file
a_time=$(bc <<< "$t_time / $n_of_file")
echo A time: $a_time
echo "mission completed"