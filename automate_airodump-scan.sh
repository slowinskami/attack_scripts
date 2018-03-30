#!/bin/bash

me=$$
i=0


printf "\n !*!*! Starting scanning with airodump-ng" 2>&1 | tee -a airodump_output/airodump_log.txt

while true
do
    i=$((i+1))
    Scanning_com="airodump-ng wlan0mon -c 6 --bssid F0:9F:C2:74:28:98" #populate with the correct interface, channel and the BSSID of the AP
    

    #perform in a loop - kill the process after random time
    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n\n*** $i) $start_current_time Executing airodump scan \n"

    printf $(eval $Scanning_com) & script1=$!
    printf "\n\n"
    Random_Time=$(shuf -i10-900 -n1) #from 30 sec to 15 minutes
    sleep $Random_Time #change to random time
    kill $script1
    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    
    #sleeping random time
    Random_Time_Sleep=$(shuf -i10-300 -n1) #from 30 sec to 5 minutes
    sleep $Random_Time_Sleep #change to random time

    printf "\n $i) start: $start_current_time , stop: $stop_current_time [duration: $Random_Time] , slept for: $Random_Time_Sleep\n" 2>&1 | tee -a airodump_output/airodump_log.txt
    


done
