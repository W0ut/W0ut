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
  FOUNDPASSFILE=/${USER}/MyOUTPUT/brut/found_pass.txt
  ApiBot=`cat /${USER}/MyScript/setting/telegrambot | grep "api_key" | awk -F ' ' '{print $2}'`
  Chat_id=`cat /${USER}/MyScript/setting/telegrambot | grep "id_chat" | awk -F ' ' '{print $2}'`
#╚═╝ VAR ╚════════════════════════════════════╝  END  ╚════╝ */

# ══ End Exit and Clear temp files ════════╗ START ╔═
FUNC_Exit()
{
    killall -9 xterm &>/dev/null
    echo ""
    echo -e "${NM}${WH} [${NM}${RD}!${NM}${WH}] Stoped cracking."
    echo ""
    echo -e "${NM}${WH} [${NM}${RD}!${NM}${WH}] Remove temporary file ."
    rm -rf ${GHashCrack_FOLDER}
    sleep 1
    echo ""
    exit
}
# ══ End Exit and Clear temp files ════════╝  END  ╚═

# ══ Title ════════╗ START ╔═
FUNC_set_title ()
{
    echo -e " ${NM}${PR}==========================================="
    echo -e " ${NM}${RD}        ${BD}${RD}-= START CRACK YOU HASH! =-        ${NM}${RD}"
    echo -e " ${NM}${PR}==========================================="
}
# ══ Title ════════╝  END  ╚═


# ══  Verify the folder of Temporary files ════════╗ START ╔═
GHashCrack_FOLDER="GHashCrack$(date "+%T" | tr -d ":")"
Temp_GHashCrack="/tmp/${GHashCrack_FOLDER}"
Dir=`ls /tmp | grep -E ^${GHashCrack_FOLDER}$`
    if [ "$Dir" != "" ];
        then
            rm -rf ${Temp_GHashCrack}
            mkdir ${Temp_GHashCrack}
        else
            mkdir ${Temp_GHashCrack}
    fi
# ══  Verify the folder of Temporary files ════════╝  END  ╚═

# ══ Folder for rezult ════════╗ START ╔═
Dir_Result=`ls /${USER}/MyOUTPUT | grep -E brut`
if [ "$Dir_Result" == "" ];then
    mkdir /${USER}/MyOUTPUT/brut
fi
File_Result=`ls /${USER}/MyOUTPUT/brut | grep -E found_pass`
if [ "$File_Result" == "" ];then
    echo -e " hash:password:type:date" > /${USER}/MyOUTPUT/brut/found_pass.txt
fi
# ══ Folder for rezult ════════╝  END  ╚═

find /${USER}/MyScript/dic -name '*' -printf "%f  %s %p\n" | sort -k2,2n | awk -F ' ' '{print $3}' > ${Temp_GHashCrack}/file_pass.txt

# ══ Insert info ════════╗ START ╔═
FUNC_insert_info()
{
    echo -e " ${NM}${PR}==========================================="
    echo -e " ${NM} ${BD}${BL}HASH       ${NM}${CY}>>  ${BD}${WH}${STR_HASH}${NM}"
}

# ══ Insert info ════════╗ START ╔═

FUNC_check_pass()
{
    CRACKHASH=$(cat ${FOUNDPASSFILE} | grep -i -E "${STR_HASH}.*" | awk -F ':' '{print $2}')
    HISTPASS=$(hashcat -m ${ONMODE} --show ${Temp_GHashCrack}/check_str_hash.txt 2>/dev/null | grep -i -E "^${STR_HASH}.*" | awk -F ':' '{print $2}')
    TYPEHASH=$(hashcat -h | sed 's/ //g' | grep -a -o "^${ONMODE}|.*" | awk -F '|' '{print $2}' | head -1)
    IDATE=`date +%d-%m-%Y`
    if [[ -n "${CRACKHASH}" ]]
        then
            FOUNDPASS=${CRACKHASH}
            echo -e "${STR_HASH}:${FOUNDPASS}:${TYPEHASH}:${IDATE}" >> ${FOUNDPASSFILE}
        else
            if [[ -n "${HISTPASS}" ]]
                then
                    FOUNDPASS=${HISTPASS}
                    echo -e "${STR_HASH}:${FOUNDPASS}:${TYPEHASH}:${IDATE}" >> ${FOUNDPASSFILE}
                else
                    FOUNDPASS="Not FOUND"
            fi
    fi
    echo -e " ${NM} ${BD}${BL}DICT       ${NM}${CY}>>  ${BD}${RD}${Dict}${NM}"
    echo -e " ${NM} ${BD}${BL}PASS       ${NM}${CY}>>  ${NM}${FOUNDPASS}${NM}"
    if [[ -n "${CRACKHASH}" || -n "${HISTPASS}" ]];
        then
            FOUND="1"
            if [[ -n ${ApiBot} && -n ${Chat_id} ]]
                then
                MSGBOT="HASH cracked -> ${STR_HASH} : ${FOUNDPASS} : ${TYPEHASH}"
                SENDTOBOT=`curl -s "https://api.telegram.org/bot${ApiBot}/sendMessage?chat_id=${Chat_id}&text=${MSGBOT}" &>/dev/null`
            fi  

    fi
}
# ══ Find pass and msg ════════╝  END  ╚═

# ══ Cracked hash ════════╗ START ╔═
FUNC_check_hash()
{
    while read STR_HASH
        do
            FOUND="0"
            FUNC_insert_info
            echo -e ${STR_HASH} > ${Temp_GHashCrack}/check_str_hash.txt
            echo -e "" >> ${Temp_GHashCrack}/check_str_hash.txt
            FINDMODE=$(hashid -m ${Temp_GHashCrack}/check_str_hash.txt | grep -a -o -E 'Hashcat Mode.*' | sed 's/[^0-9]//g' > ${Temp_GHashCrack}/list_mode.txt)
            while read ONMODE
                do
                    if [[ -n "${ONMODE}" && "${FOUND}" == "0" ]] 
                        then
                            TYPEHASH=$(hashcat -h | sed 's/ //g' | grep -a -o "^${ONMODE}|.*" | awk -F '|' '{print $2}' | head -1)
                            echo -e " ${NM} ${BD}${BL}TYPE       ${NM}${CY}>>  ${BD}${WH}${TYPEHASH}${NM}"
                            while read Dict
                                do
                                    if [[ "${FOUND}" == "0" ]]
                                        then
                                            xterm -T "MODE: ${TYPEHASH} / HASH: ${STR_HASH}" -geometry 100x30 -e "hashcat -a 0 -m ${ONMODE} --status --status-timer=15 -o ${FOUNDPASSFILE} ${Temp_GHashCrack}/check_str_hash.txt ${Dict}"
                                            FUNC_check_pass
                                    fi
                            done < ${Temp_GHashCrack}/file_pass.txt
                    fi        
            done < ${Temp_GHashCrack}/list_mode.txt
            echo -e " ${NM}${PR}==========================================="
    done < ${HASHFILE}
    echo -e ""
}
# ══ Cracked hash ════════╝  END  ╚═

HASHFILE=${1}
ITSCAP=$(aircrack-ng ${HASHFILE} &>/dev/null | grep "1 handshake" &>/dev/null)
if [[ -n "${ITSCAP}" ]]
    then
        xterm -T "Get WIFI password" -geometry 100x30 -e "cd /${USER}/MyScript/wifi/get_pass/ && ./crack.sh ${HASHFILE}"
    else
        clear
        echo -e ""
        FUNC_set_title
        FUNC_check_hash
        FUNC_Exit
fi
