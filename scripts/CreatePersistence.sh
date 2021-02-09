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

THEDISK=${1}
FUNC_isMounted() {
    THEMNT=`findmnt -rno SOURCE "${THEDISK}" >/dev/null`
}

echo -en " ${WH}[${RD}!${WH}] ${GR}Create encrypted partition? [${WH}N${GR}/y] ${CY}> ${RD}"
read ANSWER
if [[ ${ANSWER} == "y" ]]
    then
        clear
        echo -e ""
        echo -e " ${NM}${PR}=============== encrypted ================="
        echo -e ""
        cryptsetup --verbose --verify-passphrase luksFormat ${THEDISK} && cryptsetup luksOpen ${THEDISK} my_usb
        MNTCRYPTDISK=`mkfs.ext3 /dev/mapper/my_usb && e2label /dev/mapper/my_usb secret &&  mkdir -p /mnt/my_usb && mount /dev/mapper/my_usb /mnt/my_usb && echo "/ union" > /mnt/my_usb/persistence.conf && umount /dev/mapper/my_usb && cryptsetup luksClose /dev/mapper/my_usb`
    else
        clear
        echo -e ""
        echo -e " ${NM}${PR}============= NO encrypted ================"
        echo -e ""
        MNTDISK=`mkfs.ext3 -L persistence ${THEDISK} && e2label ${THEDISK} persistence &&  mkdir -p /mnt/usb && mount ${THEDISK} /mnt/usb && echo "/ union" > /mnt/usb/persistence.conf && umount ${THEDISK}`
fi
clear
echo -e ""
FUNC_isMounted
if [[ -n "${THEMNT}" ]]
    then
        if [[ ${ANSWER} == "y" ]]
            then
                echo -e " ${NM}${PR}=============== encrypted ================="
                echo -e ""
            else
                echo -e " ${NM}${PR}============= NO encrypted ================"
                echo -e ""
        fi
        echo -e " ${WH}[${RD}!${WH}] ${GR}Disk ${THEDISK} create!"
    else
        echo -e " ${WH}[${RD}!${WH}] ${GR}Something went wrong!"
fi
exit