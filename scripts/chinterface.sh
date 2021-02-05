#!/bin/bash

# ══ Regular color ════════╗ START ╔═
    BK=$(tput setaf 232)  # Black
    GY=$(tput setaf 246)  # Gray
    RD=$(tput setaf 160)  # Red
    GR=$(tput setaf 46)   # Green
    YW=$(tput setaf 226)  # Yellow
    OR=$(tput setaf 208)  # Orange
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
#║	SCAN_INTERFACE
#╚══════════════════════════════════════════════╝
	FUNC_Scan_interface() {
		clear
		echo -e " ${NM}${PR}╔════════════════════════╗"
		echo -e " ${NM}${PR}║    ${NM}${YW}SELECT INTERFACE    ${NM}${PR}║"
		echo -e " ${NM}${PR}╚════════════════════════╝"
		echo -en "${NM}${WH}"
		ip link show up | grep -E -o '.*>' | awk -F ':' '{print $2}' | nl -s ')' 2>/dev/null
		echo -e " ${NM}${PR}╚════════════════════════╝"
		echo -en " ${SVC}${NM}Enter NUM for change ${NM}${BD}${CY}> ${BD}${RD}"
		read NUM
		clear
		INTERFACE=`ip link show up | grep -E -o '.*>' | awk -F ':' '{print $2}' | nl -s ')' | grep $NUM | awk '{print $2}' 2>/dev/null`
		echo -e " ${NM}${RD}╔════════════════════════╗"
		echo -e " ${NM}${RD}║  ${NM}${YW}INTERFACE FOR CHANGE  ${NM}${RD}║ ${BD}${CY}>> ${NM}${WH}${INTERFACE}"
		echo -e " ${NM}${RD}╚════════════════════════╝"
		echo -en "  ${BD}${GR}Enter NEW name ${NM}${BD}${CY}> ${BD}${RD}"
		read NEWNAME
		ifconfig $INTERFACE down
		ip link set $INTERFACE name $NEWNAME
		ifconfig $NEWNAME up
		RESULT=`ifconfig | grep -E -o "$NEWNAME" 2>/dev/null`
		if [[ -n "$RESULT" ]]
			then
				clear
				echo ""
				echo -e "  ${BD}${GR}╔═════════════════╗"
				echo -e "  ${BD}${GR}║  ${NM}${YW}NEW INTERFACE  ${BD}${GR}║ ${BD}${CY}>> ${NM}${WH}${NEWNAME}"
				echo -e "  ${BD}${GR}╚═════════════════╝"
				echo ""
				exit
			else
				# SCAN_INTERFACE
				echo $RESULT
		fi
	}
#╚══════════════════════════════  End SCAN_INTERFACE ═╝

FUNC_Scan_interface