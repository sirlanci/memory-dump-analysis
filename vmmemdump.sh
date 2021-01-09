#!/bin/bash

#Usage vmmemdump.sh <vmname>

i=11
while [ $i -le 30 ]
do
	vboxmanage debugvm $1 dumpvmcore --filename=test$i.elf

	size=0x$(objdump -h test$i.elf | egrep -w "(load1)" | tr -s " " | cut -d " " -f 4)
	off=0x$(echo "obase=16;ibase=16;`objdump -h test$i.elf | egrep -w "(load1)" | tr -s " " | cut -d " " -f 7 | tr /a-z/ /A-Z/`" | bc)
	head -c $(($size+$off)) test$i.elf | tail -c +$(($off+1)) > test$i.raw
	((i++))
	sleep 1s
done
