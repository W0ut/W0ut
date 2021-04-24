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

# ══ Variables ════════╗ START ╔═
    WORD='Soft'
    MAX="20"
    ThisDir=$(pwd)
    checkInet=''
# ══ Variables ════════╝  END  ╚═

# ══ check internet connection ════════╗ START ╔═
ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` > /dev/null && checkInet='1' || checkInet=''
# ══ check internet connection ════════╝  END  ╚═

if [[ ${checkInet} == '1' ]]
    then
        apt-get install dos2unix &> /dev/null
        apt-get install xterm &> /dev/null
        apt-get install apt-transport-https &> /dev/null

        # ══ Add Sublime text 3 ════════╗ START ╔═
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - &> /dev/null
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list &> /dev/null
        # ══ Add Sublime text 3 ════════╝  END  ╚═
fi

clear
dos2unix ${ThisDir}/setting/* &> /dev/null
echo ""
sleep 1.5
xterm -T "UPDATE ${ChSoft}" -geometry 100x30 -e "apt-get update"    # APT-GET-UPDATE

# ══ Change the BASHRC and ZSHRC to your own ════════╗ START ╔═
File_BSH=`ls ${ThisDir}/shell | grep -E bashrc`
File_ZSH=`ls ${ThisDir}/shell | grep -E zshrc`
ItShell=`echo $SHELL`
if [[ "${ItShell}" == "/usr/bin/zsh" ]]
    then
        if [[ -n "$File_ZSH" ]];
            then
                THESHELL=~/.zshrc
                mv ~/.zshrc ~/zshrc_old &> /dev/null
                cp ${ThisDir}/shell/zshrc ~/.zshrc &> /dev/null
                dos2unix  ~/.zshrc &> /dev/null
        fi
    else
        if [[ -n "$File_BSH" ]];
            then
                THESHELL=~/.bashrc
                mv ~/.bashrc ~/bashrc_old &> /dev/null
                cp ${ThisDir}/shell/bashrc ~/.bashrc &> /dev/null
                dos2unix  ~/.bashrc &> /dev/null
        fi
fi
# ══ Change the BASHRC and ZSHRC to your own ════════╝  END  ╚═

# ══ Create table ════════╗ START ╔═
FUNC_create_tabl() {
    max_lf=""
    max_rh=""
    S=${#WORD}
    let IZ=${S}%2
    MIN=$((($MAX-$S)/2))
    for (( STIND=0;STIND<${MIN};STIND++))
        do
            max_lf=${max_lf}'.'
    done
    if [ $IZ == 0 ]
        then
            for (( STIND=0;STIND<${MIN};STIND++))
                do
                    max_rh=${max_rh}'.'
            done
        else
            for (( STIND=0;STIND<=${MIN};STIND++))
                do
                    max_rh=${max_rh}'.'
            done
    fi
}
# ══ Create table ════════╝  END  ╚═

# ══ Function of creating folders and files ════════╗ START ╔═
FUNC_create_folder_and_files() {
    if [[ "Dir" == "${ChTp}" ]];
        then
            if ! [ -d /${USER}${CrFF} ]; then
                mkdir /${USER}${CrFF}
                # echo -e "Create Folder  /${USER}${CrFF}"
            fi
        else
            if ! [ -f /${USER}${CrFF} ]; then
                echo -e "" > /${USER}${CrFF}
                # echo -e "Create File  /${USER}${CrFF}"
            fi
    fi
}
# ══ Function of creating folders and files ════════╝  END  ╚═

# ══ Creating folders and files ════════╗ START ╔═
while read line
    do
        ChType=`echo "${line: -1}"`
        IFS='/' read -r -a array <<< ${line}
        LastEl=`echo ${array[${#array[@]}-1]}`
        CrFF=''
        for el in "${array[@]}"
        do
            if [ -n "${el}" ];
                then
                    if [[ "/" == "${ChType}" ]];
                        then
                            ChTp='Dir'
                        else
                            if [[ "${LastEl}" == "${el}" ]]
                                then
                                    ChTp='File'
                                else
                                    ChTp='Dir'
                            fi                        
                    fi
                    CrFF="${CrFF}/${el}"
                    FUNC_create_folder_and_files
            fi
        done
done < ${ThisDir}/setting/list_create_folder_and_files
# ══ Creating folders and files ════════╝  END  ╚═

# ══ Insert data for TelegramBot ════════╗ START ╔═
    echo -e ""
    echo -en " ${WH}[${RD}!${WH}] ${GR}Use TelegramBot for messages? [${WH}N${GR}/y] ${CY}> ${RD}"
    read ANSWER
    if [[ ${ANSWER} == "y" ]]
        then
            echo -e ""
            echo -en " ${WH}[${RD}!${WH}] ${GR}Enter ApiKey [ex.: ${WH}bot0010000:AFFSFssdv-_gIPVkd-cJvQK7T2S4JQlY${GR}] ${CY}> ${RD}"
            read ApiKey
            echo -e "api_key ${ApiKey}" > /${USER}/MyScript/setting/telegrambot
            echo -e ""
            echo -en " ${WH}[${RD}!${WH}] ${GR}Enter IdChat [ex.: ${WH}-1222222${GR}] ${CY}> ${RD}"
            read IdChat
            echo -e "id_chat ${IdChat}" >> /${USER}/MyScript/setting/telegrambot
        else
            echo -e "api_key " > /${USER}/MyScript/setting/telegrambot
            echo -e "id_chat " >> /${USER}/MyScript/setting/telegrambot
    fi
    clear
    echo -e ""
# ══ Insert data for TelegramBot ════════╝  END  ╚═

# ══ download the recommended repositories ════════╗ START ╔═
FUNC_download_repositories() {
    WORD=$DWNSOFT
    MAX="30"
    CHKSOFT=`ls /${USER}/soft | grep -E ${DWNSOFT}`
    FUNC_create_tabl
    if [[ -n "$CHKSOFT" ]]
        then
            echo -e " ${GR}[${YW}${DWNSOFT}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${GR}✔${NM}${BL}]"
            sleep 1
        else
            echo -e " ${SVC}${GR}[${YW}${DWNSOFT}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${RD}x${NM}${BL}]"
            sleep 1
            echo -e " ${CL1}${RSC}${BL}[${BD}${RD}!${NM}${BL}] ${GR}Download ${DWNSOFT}"
            xterm -T "DOWNLOAD ${DWNSOFT}" -geometry 100x30 -e "cd /${USER}/soft && git clone ${DWNURL}"
            CHKSOFT=`ls /${USER}/soft | grep -E ${DWNSOFT}`
            if [[ -n "$CHKSOFT" ]]
                then
                    echo -e " ${CL1}${RSC}${GR}[${YW}${DWNSOFT}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${GR}✔${NM}${BL}]"
                    sleep 1
                else
                    echo -e " ${CL1}${RSC}${GR}[${YW}${DWNSOFT}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${RD}x${NM}${BL}]"
                    sleep 1
            fi
    fi
}
if [[ ${checkInet} == '1' ]]
    then
        echo -en " ${WH}[${RD}!${WH}] ${GR}Download the recommended repositories? [${WH}N${GR}/y] ${CY}> ${RD}"
        read ADDREP
        clear
        echo -e ""
        if [[ ${ADDREP} == "y" ]]
            then
                WORD='Download status.'
                MAX="34"
                FUNC_create_tabl
                echo -e " ${NM}${GR}[${YW}${max_lf}${BD}${GR}Download status${NM}${YW}${max_rh}${GR}]"
                while read DWNURL DWNSOFT
                    do
                        FUNC_download_repositories
                done < ${ThisDir}/setting/list_dwn_soft
        fi
        echo -e ""
fi
echo -e ""
# ══ download the recommended repositories ════════╝  END  ╚═

# ══ Function for checking the installation and installing ════════╗ START ╔═
    FUNC_check_install() {    
        Chk=`dpkg-query -W -f='${status}' ${ChSoft} 2>/dev/null | grep "install ok installed"`
        WORD=$ChSoft
        MAX="30"
        FUNC_create_tabl
        if [[ -n "$Chk" ]]
            then
                # FUNC_create_tabl
                echo -e " ${GR}[${YW}${ChSoft}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${GR}✔${NM}${BL}]"
                sleep 1
            else
                echo -e " ${SVC}${GR}[${YW}${ChSoft}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${RD}x${NM}${BL}]"
                sleep 1
                echo -e " ${CL1}${RSC}${BL}[${BD}${RD}!${NM}${BL}] ${GR}Installing ${ChSoft}"
                xterm -T "INSTALLER ${ChSoft}" -geometry 100x30 -e "apt-get install ${ChSoft} -y"
                Chk=`dpkg-query -W -f='${status}' ${ChSoft} 2>/dev/null | grep "install ok installed"`
                if [[ -n "$Chk" ]]
                    then
                        echo -e " ${CL1}${RSC}${GR}[${YW}${ChSoft}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${GR}✔${NM}${BL}]"
                        sleep 1
                    else
                        # FUNC_create_tabl
                        echo -e " ${CL1}${RSC}${GR}[${YW}${ChSoft}${GR}]${WH}${max_lf}${max_rh}${BL}[${BD}${RD}x${NM}${BL}]"
                        sleep 1
                fi
        fi
   }
# ══ Function for checking the installation and installing ════════╝  END  ╚═

if [[ ${checkInet} == '1' ]]
    then
# ══ Сhecking the installation ════════╗ START ╔═
        WORD='installation status.'
        MAX="34"
        FUNC_create_tabl
        echo -e " ${NM}${GR}[${YW}${max_lf}${BD}${GR}installation status${NM}${YW}${max_rh}${GR}]"
        while read ChSoft
            do
                FUNC_check_install
        done < ${ThisDir}/setting/list_check_soft
# ══ Check installed programs ════════╝  END  ╚═
fi

# ══ We fill the files ════════╗ START ╔═
echo -e "  date, essid, bssid, password, pin" > /${USER}/MyOUTPUT/wifi/WIFI_PASS.txt
echo -e "testplus" > /${USER}/MyScript/dic/pluspass.txt
echo -e "testword" > /${USER}/MyScript/dic/one/kill.txt
# ══ We fill the files ════════╝  END  ╚═

# ══ Copy my scripts in new folder ════════╗ START ╔═
cp -r ${ThisDir}/scripts/* /${USER}/MyScript/ &> /dev/null

cp ${ThisDir}/dic/* /${USER}/MyScript/dic/one/ &> /dev/null
cp ${ThisDir}/setting/* /${USER}/MyScript/setting/ &> /dev/null
cp ${ThisDir}/README /${USER}/MyScript/README &> /dev/null
# ══ Copy my scripts in new folder ════════╝  END  ╚═

# ══ We solve the issue of encoding ════════╗ START ╔═
dos2unix /${USER}/MyScript/* &> /dev/null
dos2unix /${USER}/MyScript/setting/* &> /dev/null
dos2unix /${USER}/MyScript/wifi/* &> /dev/null
dos2unix /${USER}/MyScript/wifi/get_hash/* &> /dev/null
dos2unix /${USER}/MyScript/wifi/get_pin/* &> /dev/null
dos2unix /${USER}/MyScript/wifi/get_pass/* &> /dev/null
dos2unix /${USER}/MyScript/wifi/kill_wifi/* &> /dev/null
# ══ We solve the issue of encoding ════════╝  END  ╚═

# ══ Add rights ════════╗ START ╔═
chmod -R +x /${USER}/MyScript/
# ══ Add rights ════════╝  END  ╚═

# ══ Add My alias ════════╗ START ╔═
echo -e "alias getpass='cd /${USER}/MyScript/wifi/get_pass/ && ./crack.sh'" >> ${THESHELL}
echo -e "alias hashcrack='cd /${USER}/MyScript/ && ./hashcrack.sh'" >> ${THESHELL}
echo -e "alias ifindmac='cd /${USER}/MyScript/ && ./maps.sh'" >> ${THESHELL}
echo -e "alias getpin='cd /${USER}/MyScript/wifi/get_pin/ && ./wash.sh'" >> ${THESHELL}
echo -e "alias gethash='cd /${USER}/MyScript/wifi/get_hash/ && ./get_hash.sh'" >> ${THESHELL}
echo -e "alias ikill='cd /${USER}/MyScript/wifi/kill_wifi/ && ./killwifi.sh'" >> ${THESHELL}
echo -e "alias idos='cd /${USER}/MyScript/ && ./hpingAttack.sh'" >> ${THESHELL}
echo -e "alias ichwl='cd /${USER}/MyScript/ && ./chinterface.sh'" >> ${THESHELL}
echo -e "alias webstart='cd /${USER}/MyScript/ && ./webstart.sh'" >> ${THESHELL}
if [[ ${ADDREP} == "y" ]]
    then
        echo -e "alias cupp='cd /${USER}/soft/cupp/ && python3 cupp.py'" >> ${THESHELL}
        echo -e "alias socialphish='cd /${USER}/soft/SocialPhish/ && ./socialphish.sh'" >> ${THESHELL}
        echo -e "alias duf='cd /${USER}/soft/duf/ && ./duf'" >> ${THESHELL}
fi
# ══ Add My alias ════════╝  END  ╚═

# ══ Setting for Tor, Privoxy and Proxychains ════════╗ START ╔═
ChkTor=`dpkg-query -W -f='${status}' tor 2>/dev/null | grep "install ok installed"`
ChkPrivoxy=`dpkg-query -W -f='${status}' privoxy 2>/dev/null | grep "install ok installed"`
ChkProxychains=`dpkg-query -W -f='${status}' proxychains 2>/dev/null | grep "install ok installed"`
if [[ -n "${ChkTor}" && -n "${ChkPrivoxy}" ]]
    then
        export all_proxy="socks://localhost:9050/"
        export http_proxy="http://localhost:8118/"
        export https_proxy="http://localhost:8118/"
        export ftp_proxy="http://localhost:8118/"
        export no_proxy="localhost,127.0.0.0/8,::1"
        # set privoxy
        sed -i 's/^forward-socks4 .*/forward-socks4 \/ localhost:9050 ./' /etc/privoxy/config
        The4a=`cat /etc/privoxy/config | grep -o -E "^forward-socks4a"`
        The5=`cat /etc/privoxy/config | grep -o -E "^forward-socks5"`
        The5t=`cat /etc/privoxy/config | grep -o -E "^forward-socks5t"`
        if [[ -n "${The4a}" ]]
            then
                sed -i 's/^forward-socks4a.*/forward-socks4a \/ localhost:9050 ./' /etc/privoxy/config
            else
                echo -e '' >> /etc/privoxy/config
                echo -e 'forward-socks4a / localhost:9050 .' >> /etc/privoxy/config
        fi
        if [[ -n "${The5}" ]]
            then
                sed -i 's/^forward-socks5 .*/forward-socks5 \/ localhost:9050 ./' /etc/privoxy/config
            else
                echo -e 'forward-socks5 / localhost:9050 .' >> /etc/privoxy/config
        fi
        if [[ -n "${The5t}" ]]
            then
                sed -i 's/^forward-socks5t .*/forward-socks5t \/ localhost:9050 ./' /etc/privoxy/config
            else
                echo -e 'forward-socks5t / localhost:9050 .' >> /etc/privoxy/config
        fi
fi
if [[ -n "${ChkTor}" && -n "${ChkProxychains}" ]]
    then
        # set proxychains
        Thes4=`cat /etc/proxychains.conf | grep -o -E "^socks4"`
        Thes5=`cat /etc/proxychains.conf | grep -o -E "^socks5"`
        sed -i 's/^\#dynamic_chain/dynamic_chain/' /etc/proxychains.conf
        sed -i 's/^strict_chain/#strict_chain/' /etc/proxychains.conf
        sed -i 's/^random_chain/#random_chain/' /etc/proxychains.conf
        sed -i 's/^\#quiet_mode/quiet_mode/' /etc/proxychains.conf
        sed -i 's/^\#proxy_dns/proxy_dns/' /etc/proxychains.conf
        if [[ -n "${Thes4}" ]]
            then
                sed -i "s/^socks4.*/socks4     127.0.0.1 9050/" /etc/proxychains.conf
            else
                echo 'socks4     127.0.0.1 9050' >> /etc/proxychains.conf
        fi
        if [[ -n "${Thes5}" ]]
            then
                sed -i "s/^socks5.*/socks5     127.0.0.1 9050/" /etc/proxychains.conf
            else
                echo 'socks5     127.0.0.1 9050' >> /etc/proxychains.conf
        fi
        
fi
# ══ Setting for Tor, Privoxy and Proxychains ════════╝  END  ╚═

echo -e "${NRC}"
echo -e ""
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}Results Folder${WH}...............................${CY}:${WH} /${USER}/MyOUTPUT/"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}Folder with setting${WH}..........................${CY}:${WH} /${USER}/MyScript/setting"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}Folder with my scripts${WH}.......................${CY}:${WH} /${USER}/MyScript/"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}Folder with all dictionaries${WH}.................${CY}:${WH} /${USER}/MyScript/dic/one/"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}File with found Wifi passwords${WH}...............${CY}:${WH} /${USER}/MyOUTPUT/wifi/${RD}WIFI_PASS.txt"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}File with cracked passwords${WH}..................${CY}:${WH} /${USER}/MyOUTPUT/brut/${RD}found_pass.txt"
echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}File to generate a dictionary with passwords${WH}.${CY}:${WH} /${USER}/MyScript/dic/${RD}pluspass.txt"
if [[ ${ADDREP} == "y" ]]
    then
        echo -e " ${BL}[${BD}${RD}!${NM}${BL}]${YW}Аolder with downloaded repositories${WH}..........${CY}:${WH} /${USER}/soft/"
fi
echo -e ""
echo -e " ${NM}${WH}-= ${BD}${RD}END ${NM}${WH}=-" 

# ══ Reset terminal config ════════╗ START ╔═
if [[ "${ItShell}" == "/usr/bin/zsh" ]]
    then
        source ~/.zshrc &> /dev/null
    else
        source ~/.bashrc &> /dev/null
fi
# ══ Reset terminal config ════════╝  END  ╚═