#!/usr/bin/bash
# coding BY: MOHAMED_OS

# colors
Color_Off="\e[0m" # Text Reset
Red="\e[0;31m"    # Red
Yellow="\e[0;33m" # Yellow
Blue='\e[0;34m'   # Blue
Green='\e[0;32m'  # Green

if uname -n | grep -qs "^novaler4k" || uname -n | grep -qs "^multibox"; then
    opkg update >/dev/null 2>&1
else
    clear
    echo
    echo -e "${Blue}Goodbye ;)${Color_Off}"
    echo
    exit 1
fi

###########################################
# Configure where we can find things here #
pyVersion=$(python -c"from sys import version_info; print(version_info[0])")
SitUrl='https://raw.githubusercontent.com/MOHAMED19OS/Enigma2_Store/main/NovaStore'
TmpDir='/var/volatile/tmp'

#####################

install() {
    if ! grep -qs "Package: $1" '/var/lib/opkg/status'; then
        echo -e ">>>>   Please Wait Install ${Green}$1${Color_Off}   <<<<"
        echo
        opkg install "$1"
        wait
        sleep 0.8
        clear
    fi
}
####################
#  Depends Checking  #
arrVar=("ffmpeg" "gstplayer" "exteplayer3" "enigma2-plugin-systemplugins-serviceapp")

if [ "${pyVersion}" = 3 ]; then
    arrVar+=("python3-core" "python3-futures3" "python3-image" "python3-json" "python3-multiprocessing" "python3-pillow" "python3-requests" "python3-cryptography")
else
    arrVar+=("python-core" "python-futures" "python-image" "python-imaging" "python-json" "python-multiprocessing" "python-requests" "python-cryptography")
fi
for i in "${arrVar[@]}"; do
    install "$i"
done

####################################
# Build
if [ -z "$Pkg" ]; then
    clear
    echo -e "> ${Red}Nova Store${Color_Off}"
    echo
    echo "  1 - Beengo"
    echo "  2 - NovalerTV"
    echo "  3 - SupTV"
    echo "  4 - UltraCam"
    echo
    echo "  x - Exit"
    echo
    echo "- Enter option:"

    read -r choice
    case $choice in
    "1") Pkg=enigma2-plugin-extensions-beengo ;;
    "2") Pkg=enigma2-plugin-extensions-novalertv ;;
    "3") Pkg=enigma2-plugin-extensions-suptv ;;
    "4") Pkg=enigma2-plugin-extensions-ultracam ;;
    x)
        clear
        echo
        echo -e "${Blue}Goodbye ;)${Color_Off}"
        echo
        exit 1
        ;;
    *)
        echo "Invalid option"
        sleep 3
        exit 1
        ;;
    esac
fi

####################

if [ "$choice" = 1 ] || [ "$choice" = 2 ]; then
    VerPkg='8.1-r0'
elif [ "$choice" = 3 ]; then
    VerPkg='5.0-r0'
elif [ "$choice" = 4 ]; then
    VerPkg='2.1-r0'
fi

IFS='-'
read -ra PkgName <<<"${Pkg}"

rm -rf $TmpDir/"${Pkg:?}"* >/dev/null 2>&1

if [ "$(opkg list-installed "$Pkg" | awk '{ print $3 }')" = "$VerPkg" ]; then
    echo " You are use the laste Version: $VerPkg"

    echo ""
    echo "******************************************************"
    echo "**                                                    "
    echo "**    ${PkgName[3]} : ${VerPkg}                       "
    echo -e "**    Script by  : ${Yellow}MOHAMED_OS${Color_Off} "
    echo -e "**    Support    : ${Blue}https://www.novaler.com/${Color_Off} "
    echo "**                                                    "
    echo "******************************************************"
    echo ""

    sleep 2
    exit 1
elif [ -z "$(opkg list-installed "$Pkg" | awk '{ print $3 }')" ]; then
    echo
    clear
else
    opkg remove --force-depends "$Pkg"
fi

echo -e "${Yellow}Downloading ${PkgName[3]} plugin Please Wait ......${Color_Off}"
wget --no-check-certificate $SitUrl/"${Pkg}"_"${VerPkg}"_all.ipk -qP $TmpDir

echo -e "${Yellow}Insallling ${PkgName[3]} plugin Please Wait ......${Color_Off}"
opkg install --force-overwrite $TmpDir/"${Pkg}"_"${VerPkg}"_all.ipk

rm -rf $TmpDir/"${Pkg:?}"* >/dev/null 2>&1

sleep 0.8
sync
echo ""
echo ""
echo "******************************************************"
echo "**                                                    "
echo "**    ${PkgName[3]} : ${VerPkg}                       "
echo -e "**    Script by  : ${Yellow}MOHAMED_OS${Color_Off} "
echo -e "**    Support    : ${Blue}https://www.novaler.com/${Color_Off} "
echo "**                                                    "
echo "******************************************************"
echo ""
echo ""

sleep 2
echo -e "${Yellow}" "Device will restart now" "${Color_Off}"
killall -9 enigma2

wait
exit 0