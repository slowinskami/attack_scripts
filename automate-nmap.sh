#!/bin/bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
printf "\n$current_time *!*!*!*!*!*!*!*!* STARTING PORT SCANNING SCRIPT WITH NMAP" 2>&1 | tee -a nmap_auto_output/general_log.txt -a nmap_auto_output/terminal_output_nmap.txt


#regular scan
for i in 1 2 
do
    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "*************** $start_current_time STARTING REGULAR SCAN $i/2" 2>&1 | tee -a -a nmap_auto_output/terminal_output_nmap.txt

    sudo nmap 192.168.200.1 -v -oX ~/Desktop/ATTACKS/nmap_auto_output/regular_scan$i.xml 192.168.200.1 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt
    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "\n"
    echo "*************** $start_current_time FINISHED REGULAR SCAN $i/2" 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt
    echo "\n"
    echo "Regular scan $i , start: $start_current_time, finish: $stop_current_time\n" 2>&1 | tee -a nmap_auto_output/general_log.txt
done 





