#!/bin/bash

#This script extracts strings in raw files (memory dump) by taking minimum string length as a parameter

#Usage extract_strings.sh <min string length>

cd /home/melih/Desktop/from_office/dump_pma/dump_pma_lab1-1_1sec/diff_output/

for file in *.raw
do
  echo $file
  strings -n $1 $file >> file_mdo.txt
done
