#!/bin/bash
clear

C_RED_BLD='\033[1;31m'
C_GRN_BLD='\033[1;32m'
C_YLW_BLD='\033[1;33m'
C_BLU_BLD='\033[1;94m'
C_WHT_BLD='\033[1;37m'
C_RED='\033[0;91m'
C_GRN='\033[0;92m'
C_YLW='\033[0;93m'
C_BLU='\033[0;94m'
C_WHT='\033[0;37m'
C_BLANK='\033[0m'

echo -e "${C_GRN_BLD}ATA and VFLASH keys generator v1.8b (2019-09)"
echo -e "${C_YLW}Big thanks for all hackers of theirs hard work on RE this shit.${C_BLANK}\n"
echo -e "Install ${C_YLW_BLD}OpenSSL${C_BLANK} and put ${C_YLW_BLD}eid_root_key.bin${C_BLANK} in the same path as this script.\n"
echo "Choose option:"
echo " 1. show supported units list"
echo " 2. generate keys for Fat units with NAND Flash memory"
echo " 3. generate keys for Fat units with NOR Flash memory"
echo " 4. generate keys for Slim units"
echo " 5. generate keys for all Arcade units"
echo " 6. test keys generating"
echo " 7. check environment"
echo " 8. exit script"

echo
while :
do
read model
case $model in
    1)
        clear
        echo
        echo -e "${C_GRN_BLD}Supported models (25xx only with old boot loader!):${C_GRN}\n"
        echo -e "\tArcade (GEX):\t\t  GECR-xxxx\r"
        echo -e "\tAV Testing Tool (AVTool): DECHSyxx, DECH-S2xxx\r"
        echo -e "\tDebug Station (DEX):\t  DECHyxx, DECH-2xxx\r"
        echo -e "\tRetail & KIOSK (CEX/SEX): CECHyxx, CECH-2xxx\n"

        echo -e "${C_RED_BLD}Unsupported and/or untested models:${C_RED}\n"
        echo -e "\tAV Testing Tool (AVTool): DECH-S25xx, DECH-S3xxx, DECH-S4xxx\r"
        echo -e "\tDebug Station (DEX):\t  DECH-25xx, DECH-3xxx, DECH-4xxx\r"
        echo -e "\tReference Tool (DevKit):  all DECR\r"
        echo -e "\tRetail & KIOSK (CEX/SEX): CECH-25xx, CECH-3xxx, CECH-4xxx\r"
        echo -e "\tvarious of prototypes:\t  all CEB, CBEH and DEH${C_BLANK}\n"

        echo -e "Consoles with ${C_YLW_BLD}old boot loader${C_BLANK} have factory firmware ${C_YLW_BLD}3.56 or lower${C_BLANK}.\r"
        echo -e "You can check this using ${C_YLW_BLD}Min Version Checker${C_BLANK} MFW (prepared for your unit type).\n"
        echo -e "The reasons why some models aren't supported are:\n"
        echo -e "\t- we don't know how to get EID Root Key on those units\r"
        echo -e "\t  (in the past ERK was first bytes of decrypted meta loader)\r"
        echo -e "\t- we don't know what and where the seeds are\r"
        echo -e "\t- we don't know what algorithm is used to keys generating\r"
        echo -e "\t- we don't know what algorithm is used to HDD encryption\r"
        echo -e "\t- we don't know how long the key is\r"
        echo -e "\t- we don't know how long the IV is\r"
        echo -e "\t- we know nothing John Snow ;)\n"
        break;;

    2)
        erk_data=$(xxd -p -u -c 32 -l 32 "eid_root_key.bin")
        erk_iv=$(xxd -p -u -c 16 -s -16 "eid_root_key.bin")
        echo "D92D65DB057D49E1A66F2274B8BAC50883844ED756CA79516362EA8ADAC60326" | xxd -r -p > ata_data_seed.bin
        echo "C3B3B5AACC74CD6A48EFABF44DCDF16E379F55F5777D09FBEEDE07058E94BE08" | xxd -r -p > ata_tweak_seed.bin
        echo "E2D05D4071945B01C36D5151E88CB8334AAA298081D8C44F185DC660ED575686" | xxd -r -p > encdec_data_seed.bin
        echo "02083292C305D538BC50E699710C0A3E55F51CBAA535A38030B67F79C905BDA3" | xxd -r -p > encdec_tweak_seed.bin
        openssl aes-256-cbc -e -in "ata_data_seed.bin" -out "ata_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "ata_tweak_seed.bin" -out "ata_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_data_seed.bin" -out "encdec_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_tweak_seed.bin" -out "encdec_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        adk=$(xxd -p -u -c 32 -l 24 ata_data_key.bin)
        atk=$(xxd -p -u -c 32 -l 24 ata_tweak_key.bin)
        edk=$(xxd -p -u -c 32 -l 16 encdec_data_key.bin)
        etk=$(xxd -p -u -c 32 -l 16 encdec_tweak_key.bin)
        echo "$adk" "$atk" | xxd -r -p > ata_key.bin
        echo "$edk" "$etk" | xxd -r -p > flash_key.bin
        break;;

    3)
        erk_data=$(xxd -p -u -c 32 -l 32 "eid_root_key.bin")
        erk_iv=$(xxd -p -u -c 16 -s -16 "eid_root_key.bin")
        echo "D92D65DB057D49E1A66F2274B8BAC50883844ED756CA79516362EA8ADAC60326" | xxd -r -p > ata_data_seed.bin
        echo "C3B3B5AACC74CD6A48EFABF44DCDF16E379F55F5777D09FBEEDE07058E94BE08" | xxd -r -p > ata_tweak_seed.bin
        echo "E2D05D4071945B01C36D5151E88CB8334AAA298081D8C44F185DC660ED575686" | xxd -r -p > encdec_data_seed.bin
        echo "02083292C305D538BC50E699710C0A3E55F51CBAA535A38030B67F79C905BDA3" | xxd -r -p > encdec_tweak_seed.bin
        openssl aes-256-cbc -e -in "ata_data_seed.bin" -out "ata_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "ata_tweak_seed.bin" -out "ata_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_data_seed.bin" -out "encdec_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_tweak_seed.bin" -out "encdec_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        adk=$(xxd -p -u -c 32 -l 24 ata_data_key.bin)
        atk=$(xxd -p -u -c 32 -l 24 ata_tweak_key.bin)
        edk=$(xxd -p -u -c 32 -l 16 encdec_data_key.bin)
        etk=$(xxd -p -u -c 32 -l 16 encdec_tweak_key.bin)
        echo "$adk" "$atk" | xxd -r -p > ata_key.bin
        echo "$edk" "$etk" | xxd -r -p > vflash_key.bin
        break;;

    4)
        erk_data=$(xxd -p -u -c 32 -l 32 "eid_root_key.bin")
        erk_iv=$(xxd -p -u -c 16 -s -16 "eid_root_key.bin")
        echo "D92D65DB057D49E1A66F2274B8BAC50883844ED756CA79516362EA8ADAC60326" | xxd -r -p > ata_data_seed.bin
        echo "C3B3B5AACC74CD6A48EFABF44DCDF16E379F55F5777D09FBEEDE07058E94BE08" | xxd -r -p > ata_tweak_seed.bin
        echo "E2D05D4071945B01C36D5151E88CB8334AAA298081D8C44F185DC660ED575686" | xxd -r -p > encdec_data_seed.bin
        echo "02083292C305D538BC50E699710C0A3E55F51CBAA535A38030B67F79C905BDA3" | xxd -r -p > encdec_tweak_seed.bin
        openssl aes-256-cbc -e -in "ata_data_seed.bin" -out "ata_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "ata_tweak_seed.bin" -out "ata_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_data_seed.bin" -out "encdec_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_tweak_seed.bin" -out "encdec_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        adk=$(xxd -p -u -c 32 -l 16 ata_data_key.bin)
        atk=$(xxd -p -u -c 32 -l 16 ata_tweak_key.bin)
        edk=$(xxd -p -u -c 32 -l 16 encdec_data_key.bin)
        etk=$(xxd -p -u -c 32 -l 16 encdec_tweak_key.bin)
        echo "$adk" "$atk" | xxd -r -p > ata_key.bin
        echo "$edk" "$etk" | xxd -r -p > vflash_key.bin
        break;;

    5)
        echo -e "\n\e[1m\e[93mAll keys are static for this model so You don't need ERK. :)\e[0m"
        echo -e "\e[93mTested on System 357C (GECR-1500).\e[0m"
        echo "359F59BB8C256B91093A92007203ABB33BADF5AC09A0DC005859D6F159C4F54F929214D8FCCB4CE7099ACEBDFC6612B9" | xxd -r -p > eid_root_key_arcade.bin
        echo "DA73ED9020918F4C0A703DCCF890617BFFD25E3340009109583C643DF4A21324" | xxd -r -p > ata_data_and_tweak_seed.bin
        echo "D2BCFF742D571A80DFEE5E2496D19C3A6F25FA0FC69764CAC20F4269EB540FD8" | xxd -r -p > encdec_data_seed.bin
        echo "C19C7F987EDB6E244B07BEDEFA1E6CC9F08524D98C05654CC742141E01F823E1" | xxd -r -p > encdec_tweak_seed.bin
      # echo "5F20A21ED12FF6425B62FDE0D1881C845F20A21ED12FF6425B62FDE0D1881C84" | xxd -r -p > ata_key.bin
      # echo "7B07E0D651130EB443146836DB89B5AB230976E1E842D4F44A5E257615991BA1" | xxd -r -p > vflash_key.bin
        erk_data=$(xxd -p -u -c 32 -l 32 "eid_root_key_arcade.bin")
        erk_iv=$(xxd -p -u -c 16 -s -16 "eid_root_key_arcade.bin")
        openssl aes-256-cbc -e -in "ata_data_and_tweak_seed.bin" -out "ata_data_and_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_data_seed.bin" -out "encdec_data_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_tweak_seed.bin" -out "encdec_tweak_key.bin" -K $erk_data -iv $erk_iv -nopad -nosalt
        adk=$(xxd -p -u -c 32 -l 16 ata_data_and_tweak_key.bin)
        atk=$(xxd -p -u -c 32 -l 16 ata_data_and_tweak_key.bin)
        edk=$(xxd -p -u -c 32 -l 16 encdec_data_key.bin)
        etk=$(xxd -p -u -c 32 -l 16 encdec_tweak_key.bin)
        echo "$adk" "$atk" | xxd -r -p > ata_key.bin
        echo "$edk" "$etk" | xxd -r -p > vflash_key.bin
        break;;

    6)
        echo "000102030405060708090A0B0C0D0E0F544553540000544553540000544553540F0E0D0C0B0A09080706050403020100" | xxd -r -p > eid_root_key.fake
        echo "6ADB10E460DAE9FA9CC1EBAB3F1DB164BC42EB6D2CABFF8A1A68EAF470101438" | xxd -r -p > ata_key_pattern.fake
        echo "382F24C372B0CA83C389ED40D358599B5F19E3857DE33EE003B6022A23FE1BBF" | xxd -r -p > vflash_key_pattern.fake
        echo "1000000000000000000000000000000000000000000000000000000000000004" | xxd -r -p > ata_data_seed.fake
        echo "2000000000000000000000000000000000000000000000000000000000000003" | xxd -r -p > ata_tweak_seed.fake
        echo "3000000000000000000000000000000000000000000000000000000000000002" | xxd -r -p > encdec_data_seed.fake
        echo "4000000000000000000000000000000000000000000000000000000000000001" | xxd -r -p > encdec_tweak_seed.fake
        erk_data=$(xxd -p -u -c 32 -l 32 "eid_root_key.fake")
        erk_iv=$(xxd -p -u -c 16 -s -16 "eid_root_key.fake")
        openssl aes-256-cbc -e -in "ata_data_seed.fake" -out "ata_data_key.fake" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "ata_tweak_seed.fake" -out "ata_tweak_key.fake" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_data_seed.fake" -out "encdec_data_key.fake" -K $erk_data -iv $erk_iv -nopad -nosalt
        openssl aes-256-cbc -e -in "encdec_tweak_seed.fake" -out "encdec_tweak_key.fake" -K $erk_data -iv $erk_iv -nopad -nosalt
        adk=$(xxd -p -u -c 32 -l 16 ata_data_key.fake)
        atk=$(xxd -p -u -c 32 -l 16 ata_tweak_key.fake)
        edk=$(xxd -p -u -c 32 -l 16 encdec_data_key.fake)
        etk=$(xxd -p -u -c 32 -l 16 encdec_tweak_key.fake)
        echo "$adk" "$atk" | xxd -r -p > ata_key.fake
        echo "$edk" "$etk" | xxd -r -p > vflash_key.fake
        if ! diff -q "ata_key.fake" "ata_key_pattern.fake" > /dev/null 2>&1; then
                echo -e "${C_RED_BLD}Something goes wrong${C_BLANK} and the generated ${C_YLW_BLD}fake ATA Key${C_BLANK} is wrong.\r"
                echo -e "Try different OpenSSL version or another Linux distribution.\n"
            else
                echo -e "${C_GRN_BLD}Everything is ok${C_BLANK}, generated ${C_YLW_BLD}fake ATA Key${C_BLANK} is proper.\r"
        fi
        if ! diff -q "ata_key.fake" "ata_key_pattern.fake" > /dev/null 2>&1; then
                echo -e "${C_RED_BLD}Something goes wrong${C_BLANK} and the generated ${C_YLW_BLD}fake VFLASH Key${C_BLANK} is wrong.\r"
                echo -e "Try different OpenSSL version or another Linux distribution.\r"
            else
                echo -e "${C_GRN_BLD}Everything is ok${C_BLANK}, generated ${C_YLW_BLD}fake VFLASH Key${C_BLANK} is proper.\r"
        fi
        rm *.fake
        break;;

    7)
        file_erk_rename_1="eid_root_key"
        file_erk_rename_2="eid_root_key.bin.bin"
        file_erk_ok="eid_root_key.bin"

        if ! type "openssl" > /dev/null 2>&1; then
                echo -e "I did ${C_RED_BLD}NOT found ${C_YLW_BLD}OpenSSL${C_BLANK}. Please, install it..."
            else
                echo -e "${C_GRN_BLD}Good${C_BLANK}, I found ${C_YLW_BLD}OpenSSL${C_BLANK}:"
                openssl version
        fi
        echo
        if [ -f "$file_erk_rename_1" ] || [ -f "$file_erk_rename_2" ]; then
                echo -e "${C_GRN_BLD}Good${C_BLANK}, I found ${C_YLW_BLD}EID Root Key${C_BLANK} but the ${C_RED_BLD}filename was incorrect${C_BLANK}...\r"
                echo -e "so I changed it for you and ${C_GRN_BLD}is ok now${C_BLANK}. :P\n"
                mv -f "eid_root_key" "eid_root_key.bin" 2> /dev/null
                mv -f "eid_root_key.bin.bin" "eid_root_key.bin" 2> /dev/null
            else
                if [ -f "$file_erk_ok" ]; then
                        echo -e "${C_GRN_BLD}Good${C_BLANK}, I found ${C_YLW_BLD}EID Root Key${C_BLANK} file.\n"
                    else
                        echo -e "I did ${C_RED_BLD}NOT found ${C_YLW_BLD}$file_erk_ok${C_BLANK}. Please, put this file in script dir...\n"
                fi
        fi
        echo -e "${C_YLW_BLD}System informations:${C_BLANK}\r"
        hostnamectl
        break;;

    8)
        exit
        break;;

    x)
        rm *.fake                       2> /dev/null
      # rm *.bin                        2> /dev/null
      # rm eid_root_key.bin             2> /dev/null
        rm ata_data_seed.bin            2> /dev/null
        rm ata_tweak_seed.bin           2> /dev/null
        rm ata_data_and_tweak_seed.bin  2> /dev/null
        rm encdec_data_seed.bin         2> /dev/null
        rm encdec_tweak_seed.bin        2> /dev/null
        rm ata_data_key.bin             2> /dev/null
        rm ata_tweak_key.bin            2> /dev/null
        rm ata_data_and_tweak_key.bin   2> /dev/null
        rm encdec_data_key.bin          2> /dev/null
        rm encdec_tweak_key.bin         2> /dev/null
        rm ata_key.bin                  2> /dev/null
        rm flash_key.bin                2> /dev/null
        rm vflash_key.bin               2> /dev/null
        break;;

    *)
        echo
        echo "Write one of the options number..."
        break;;
esac
done

unset erk_data
unset erk_iv
unset adk
unset atk
unset edk
unset etk
unset file_erk_rename_1
unset file_erk_rename_2
unset file_erk_ok

echo
read -p "Done. Press any key to exit. "
