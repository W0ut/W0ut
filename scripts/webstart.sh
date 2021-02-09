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
    TYPEHOST="http"
#╚═╝ VAR ╚════════════════════════════════════╝  END  ╚════╝ */

# openssl s_client -connect your_server_ip:443

apt-get install apache2 &> /dev/null
apt-get install openssl &> /dev/null

echo -en " ${WH}[${RD}!${WH}] ${GR}Run http or https? [${WH}HTTP${GR}/https] ${CY}> ${RD}"
read ANSWER
echo -en " ${WH}[${RD}!${WH}] ${GR}Enter your ip address? [${WH}192.168.1.100${GR}] ${CY}> ${RD}"
read DOMAINIP
echo -en " ${WH}[${RD}!${WH}] ${GR}Enter your host name? [${WH}mysite${GR}] ${CY}> ${RD}"
read DOMAINNAME
if [[ -n ${DOMAINIP} && -n ${DOMAINNAME} ]]
    then
        clear
        echo -e ""
        service apache2 start &>/dev/null
        # service apache2 reload &>/dev/null
        if [[ ${ANSWER} == "HTTP" || ${ANSWER} == "http" || -z ${ANSWER} ]]
            then
                echo -e " ${NM}${PR}=============== HTTP ================="
                echo -e ""
            else
                TYPEHOST="https"
                echo -e " ${NM}${PR}=============== HTTPS ================"
                echo -e ""
                a2enmod ssl &>/dev/null
                a2ensite default-ssl &>/dev/null
                service apache2 reload &>/dev/null
                mkdir /etc/apache2/ssl &>/dev/null
                xterm -T "Create SSL Certificate" -geometry 180x40 -e "openssl req -x509 -nodes -days 700 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt"
                THESERV=`cat /etc/apache2/sites-enabled/default-ssl.conf | grep -nPo '\S.*?(?=\s*$)' | grep -Ea "ServerName.*" | awk -F ':' '{print $2, $1}' | grep -v '^#' | awk '{print $NF}'`
                THESSLCRT=`cat /etc/apache2/sites-enabled/default-ssl.conf | grep -nPo '\S.*?(?=\s*$)' | grep -Ea "SSLCertificateFile.*" | awk -F ':' '{print $2, $1}' | grep -v '^#' | awk '{print $NF}'`
                THESSLKEY=`cat /etc/apache2/sites-enabled/default-ssl.conf | grep -nPo '\S.*?(?=\s*$)' | grep -Ea "SSLCertificateKeyFile.*" | awk -F ':' '{print $2, $1}' | grep -v '^#' | awk '{print $NF}'`
                # ══ Change /etc/apache2/sites-enabled/default-ssl.conf ════════╗ START ╔═
                if [[ -n "${THESERV}" ]]
                    then
                        sed -i "${THESERV}c\ServerName ${DOMAINNAME}\n/" /etc/apache2/sites-enabled/default-ssl.conf
                    else
                        sed -i "s/<VirtualHost.*/<VirtualHost *:443>\n              ServerName ${DOMAINNAME}\n/" /etc/apache2/sites-enabled/default-ssl.conf
                fi
                if [[ -n "${THESSLCRT}" ]]
                    then
                        sed -i "${THESSLCRT}c\SSLCertificateFile \/etc\/apache2\/ssl\/apache.crt/" /etc/apache2/sites-enabled/default-ssl.conf
                fi
                if [[ -n "${THESSLKEY}" ]]
                    then
                        sed -i "${THESSLKEY}c\SSLCertificateKeyFile \/etc\/apache2\/ssl\/apache.key/" /etc/apache2/sites-enabled/default-ssl.conf
                fi
                # ══ Change /etc/apache2/sites-enabled/default-ssl.conf ════════╝  END  ╚═
        fi
        THESERV2=`cat /etc/apache2/sites-available/000-default.conf | grep -nPo '\S.*?(?=\s*$)' | grep -Ea "ServerName.*" | awk -F ':' '{print $2, $1}' | grep -v '^#' | awk '{print $NF}'`
        THEREDIRECT=`cat /etc/apache2/sites-available/000-default.conf | grep -nPo '\S.*?(?=\s*$)' | grep -Ea "Redirect.*" | awk -F ':' '{print $2, $1}' | grep -v '^#' | awk '{print $NF}'`
        # ══ Change /etc/apache2/sites-available/000-default.conf ════════╗ START ╔═
        if [[ -n "${THESERV2}" ]]
            then
                sed -i "${THESERV2}c\/ServerName ${DOMAINNAME}\n/" /etc/apache2/sites-available/000-default.conf
            else
                sed -i "s/<VirtualHost.*/<VirtualHost *:80>\n              ServerName ${DOMAINNAME}\n/" /etc/apache2/sites-available/000-default.conf
        fi
        if [[ -n "${THEREDIRECT}" ]]
            then
                sed -i "${THEREDIRECT}c\/Redirect \"/\" \"${TYPEHOST}://${DOMAINNAME}/\"/" /etc/apache2/sites-available/000-default.conf
            else
                sed -i "s/ServerName.*/ServerName ${DOMAINNAME}\n       Redirect "/" "https://${DOMAINNAME}/"/" /etc/apache2/sites-available/000-default.conf
        fi
        # ══ Change /etc/apache2/sites-available/000-default.conf ════════╝  END  ╚═
        # service apache2 start &>/dev/null
        service apache2 reload &>/dev/null
        # ══ Change host file ════════╗ START ╔═
        THEFILEHOST=`ls /etc | grep -aoE "^host$"`
        THEFILEHOSTS=`ls /etc | grep -aoE "^host$"`
        if [[ -n "${THEFILEHOST}" ]]
            then
                THEHOST=`cat /etc/host | grep -o -a -E "${DOMAINIP}.*"`
                if [[ -n "${THEHOST}" ]]
                    then
                        sed -i "s/${THEHOST}.*/${DOMAINIP} ${DOMAINNAME}\n/" /etc/host
                    else
                        echo -e "${DOMAINIP} ${DOMAINNAME}" >> /etc/host
                fi
        fi
        if [[ -n "${THEFILEHOSTS}" ]]
            then
                THEHOSTS=`cat /etc/hosts | grep -o -a -E "${DOMAINIP}.*"`
                if [[ -n "${THEHOSTS}" ]]
                    then
                        sed -i "s/${THEHOSTS}.*/${DOMAINIP} ${DOMAINNAME}\n/" /etc/hosts
                    else
                        echo -e "${DOMAINIP} ${DOMAINNAME}" >> /etc/hosts
                fi
        fi
        # ══ Change host file ════════╝  END  ╚═
        service apache2 restart &>/dev/null
        clear
        echo -e " ${NM}${WH}The server ${TYPEHOST}://${DOMAINNAME} is ${RD} running!"
        echo -e ""
        echo -e " ${NM}${BL}TYPE       ${NM}${CY}>>  ${NM}${WH}${TYPEHOST}"
        echo -e " ${NM}${BL}IP ADDRESS ${NM}${CY}>>  ${NM}${WH}${DOMAINIP}"
        echo -e " ${NM}${BL}DOMAIN NAME${NM}${CY}>>  ${NM}${GR}${DOMAINNAME}"
        echo -e ""
    else
        echo -e " ${WH}[${RD}!${WH}] ${GR}You can't work with empty values!"
fi
exit