#!/bin/bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
printf "\n$current_time *!*!*!*!*!*!*!*!* STARTING PORT SCANNING SCRIPT WITH NMAP\n" 2>&1 | tee -a nmap_auto_output/general_log.txt -a nmap_auto_output/terminal_output_nmap.txt

i=0

#regular scan
while true
do
    i=$((i+1))

    x1="sudo nmap -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-regular.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x2="sudo nmap -T4 -F -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-quick.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x3="sudo nmap -sn -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-ping.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x4="sudo nmap -T4 -A -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-intense.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x5="sudo nmap -sS -sU -T4 -A  -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-intense_plus_UDP.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x6="sudo nmap -sn --traceroute -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-quick_traceroute.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x7="sudo nmap -T4 -A -v -Pn -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-intense_no_ping.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x8="sudo nmap -sV -T4 -O -F --version-light -v -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-quick_scan_plus.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    x9="sudo nmap -p 1-65535 -T4 -A -v  -oX ~/Desktop/ATTACKS/nmap_auto_output/scan$i-intense_all_TCP_ports.xml 192.168.200.1-254 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt"
    
    x_current=""

    x1_name="regular"
    x2_name="quick"
    x3_name="ping"
    x4_name="intense"
    x5_name="intense plus UDP"
    x6_name="quick traceroute"
    x7_name="intense no ping"
    x8_name="quick scan plus"
    x9_name="intense all TCP ports"

    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "*************** $start_current_time STARTING SCAN $i" 2>&1 | tee -a -a nmap_auto_output/terminal_output_nmap.txt

    rand=$(shuf -i1-9 -n1)
    printf "RANDOM SCAN $rand \n"

    if [ "$rand" = "1" ]; then
        printf "$x1_name scan \n"
        echo $(eval $x1)
        x_current="$x1_name"
    elif [ "$rand" = "2" ]; then
        printf "$x2_name scan \n"
        echo $(eval $x2)
        x_current="$x2_name"
    elif [ "$rand" = "3" ]; then
        printf "$x3_name scan \n"
        echo $(eval $x3)
        x_current="$x3_name"
    elif [ "$rand" = "4" ]; then
        printf "$x4_name scan \n"
        echo $(eval $x4)
        x_current="$x4_name"
    elif [ "$rand" = "5" ]; then
        printf "$x5_name scan \n"
        echo $(eval $x5)
        x_current="$x5_name"
    elif [ "$rand" = "6" ]; then
        printf "$x6_name scan \n"
        echo $(eval $x6)
        x_current="$x6_name"
    elif [ "$rand" = "7" ]; then
        printf "$x7_name scan \n"
        echo $(eval $x7)
        x_current="$x7_name"
    elif [ "$rand" = "8" ]; then
        printf "$x8_name scan \n"
        echo $(eval $x8)
        x_current="$x8_name"
    elif [ "$rand" = "9" ]; then
        printf "$x9_name scan \n"
        echo $(eval $x9)
        x_current="$x9_name"
    else
        echo "error"
    fi
    
    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    echo "\n"
    echo "*************** $start_current_time FINISHED SCAN $i $x_current" 2>&1 | tee -a nmap_auto_output/terminal_output_nmap.txt
    echo "\n"
    echo "Scan $i $x_current start: $start_current_time, finish: $stop_current_time\n" 2>&1 | tee -a nmap_auto_output/general_log.txt
done 





