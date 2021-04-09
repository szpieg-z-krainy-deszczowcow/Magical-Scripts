#!/bin/bash
clear
echo -e "\e[1m\e[92mDrive Key Assembler v0.9\e[0m"
echo -e "\e[93mBig thanks for all hackers of theirs hard work on RE this shit.\e[0m\n"
echo -e "Put \e[1m\e[93mflash.bin\e[0m and \e[1m\e[93meid_root_key.bin\e[0m in the same path as this script.\n"
echo "Choose your operation:"
echo " 1. Generate Drive Key for NAND consoles."
echo " 2. Generate Drive Key for NOR consoles."
echo " 3. Extract EID Root Key from Drive Key."
echo " 4. Exit script."

echo
while :
do
read option
case $option in
    1)
        var=$(xxd -p -u -c 48 -s 531360 -l 48 "flash.bin")
        echo "$var" | xxd -r -p > data.temp
        cat data.temp eid_root_key.bin > drive_key.bin
        rm data.temp
        break;;

    2)
        var=$(xxd -p -u -c 48 -s 197536 -l 48 "flash.bin")
        echo "$var" | xxd -r -p > data.temp
        cat data.temp eid_root_key.bin > drive_key.bin
        rm data.temp
        break;;

    3)
        var=$(xxd -p -u -c 48 -s 48 -l 48 "drive_key.bin")
        echo "$var" | xxd -r -p >  eid_root_key.bin
        break;;

    4)
        exit
        break;;
    *)
        echo
        echo "Write one of the options number..."
        break;;
esac
done
echo
read -p "Done. Press any key to exit."
