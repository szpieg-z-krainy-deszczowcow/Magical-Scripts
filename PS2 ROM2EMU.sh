#!/bin/bash
clear
echo -e "\e[93m\e[1mroms2emu v0.5c by Berion\n\e[0mSpecial thanks to SP193 for info and Misiozol for dump examples!"
echo -e "\nThis simple script will convert proper firmware dumps made by \e[92m\e[1mPlayStation 2 Identification Tool \e[0mto form accepted by \e[92m\e[1mPCSX2 \e[0memulator.\n"

echo -e "\e[93m\e[1mStep 1: \e[0mPlace all dumps to your home dir (\e[92m\e[1mBOOT_ROM\e[0m, \e[92m\e[1mDVD_ROM\e[0m and \e[92m\e[1mNVM\e[0m)."
echo -e "\e[93m\e[1mStep 2: \e[0mChoose from what model dump was made:"

PS3='Please enter your choice: '
opcje=(
	"SCPH-3xxxx"
	"SCPH-5xxxx, SCPH-7xxxx & SCPH-9xxxx"
	"Quit"
	)

select wybierz in "${opcje[@]}"
do
	case $wybierz in

		"SCPH-10000 & SCPH-15000")
			echo -e "\n\e[1mUnsupported yet. :(\e[0m\n"
			break
			;;

		"SCPH-3xxxx")
			echo -e "\n\e[1mLet's slice! ;)\e[0m\n"

			prefix="$(find ${HOME}/*_BOOT_ROM.bin -maxdepth 0 -exec basename {} _BOOT_ROM.bin \;)"
			bootrom="$(find ${HOME}/*_BOOT_ROM.bin -maxdepth 0 -exec basename {} \;)"
			dvdrom="$(find ${HOME}/*_DVD_ROM.bin -maxdepth 0 -exec basename {} \;)"
			eeprom="$(find ${HOME}/*_NVM.bin -maxdepth 0 -exec basename {} \;)"

			dd if=$HOME/"$bootrom" of=$HOME/"$prefix".rom0 bs=2M
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".rom1 bs=256K count=1
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".rom2 bs=256K count=1
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".erom skip=512 count=3584
			dd if=$HOME/"$eeprom" of=$HOME/"$prefix".nvm bs=1K count=1
			# dd if=$HOME/"$eeprom"  of=$HOME/"$prefix".mec bs=4 count=1 skip=chujwieile
			echo -e "\n"
			break
			;;

		"SCPH-5xxxx, SCPH-7xxxx & SCPH-9xxxx")
			echo -e "\n\e[1mLet's slice! ;)\e[0m\n"

			prefix="$(find ${HOME}/*_BOOT_ROM.bin -maxdepth 0 -exec basename {} _BOOT_ROM.bin \;)"
			bootrom="$(find ${HOME}/*_BOOT_ROM.bin -maxdepth 0 -exec basename {} \;)"
			dvdrom="$(find ${HOME}/*_DVD_ROM.bin -maxdepth 0 -exec basename {} \;)"
			eeprom="$(find ${HOME}/*_NVM.bin -maxdepth 0 -exec basename {} \;)"

			dd if=$HOME/"$bootrom" of=$HOME/"$prefix".rom0 bs=2M
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".rom1 bs=512K count=1
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".rom2 bs=512K count=1
			# dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".erom bs=512 skip=1024 count=6144
			dd if=$HOME/"$dvdrom" of=$HOME/"$prefix".erom bs=512 skip=2048 count=6144
			dd if=$HOME/"$eeprom" of=$HOME/"$prefix".nvm bs=1K count=1
			# dd if=$HOME/"$eeprom"  of=$HOME/"$prefix".mec bs=4 count=1 skip=chujwieile
			echo -e "\n"
			break
			;;

		# chińskie, mają ROM2, pewnie też z podziałem na 256/512KB i 1.8/3.1MB
		"SCPH-xxxx9")
			echo -e "\n\e[1mUnsupported yet. :(\e[0m\n"
			break
			;;

		"DESR-xxxxx")
			echo -e "\n\e[1mUnsupported yet. :(\e[0m\n"
			break
			;;

		"DTL-Hxxxxx")
			echo -e "\n\e[1mUnsupported yet. :(\e[0m\n"
			break
			;;

		"Quit")
			break
			;;

        *) echo invalid option;;
    esac
done


##################################################################################################
# NOTATNIK:


# echo -e "\n"
# read -p "Press [Enter] key to exit."


#-------------------------------------------------------------------------------------------------

# SCPH-30003 R (0160EC20010704)
# SCPH-30004 R (0160EC20010704)
#	ROM0	BOOT ROM	cały					0xBFC00000 (3860639 bajty)
#	ROM1	DVD ROM		0x00000000 0x0003FFFF (40000)		0xBE000000 (199099 bajty)
#	ROM2	DVD ROM		0x00000000 0x0003FFFF (40000)		-
#	EROM	DVD ROM		0x00040000 0x001FFFFF (1C0000)		0xBE040000 (1835008 bajty)
#	NVM	EEPROM		cały						   (1024 bajty)

# SCPH-50003   (0170EC20030227)
#	ROM0	BOOT ROM	cały					0xBFC00000 (3900175 bajty)
#	ROM1	DVD ROM		0x00000000 0x0007FFFF (100000)		0xBE000000 (407171 bajty)
#	ROM2	DVD ROM		0x00000000 0x0007FFFF (100000)		-
#	EROM	DVD ROM		0x01000000 0x0037FFFF (300000)		0xBE100000 (3145728 bajty)
#	NVM	EEPROM		cały						   (1024 bajty)

# SCPH-75003   (0220EC20050620)
# SCPH-77003   (0220EC20060210)
#	ROM0	BOOT ROM	cały					0xBFC00000 (4193619 bajty)
#	ROM1	DVD ROM		0x00000000 0x0007FFFF (80000)		0xBE000000 (429135 bajty)
#	ROM2	DVD ROM		0x00000000 0x0007FFFF (80000)		-
#	EROM	DVD ROM		0x00800000 0x0037FFFF (320000)		0xBE080000 (3670016 bajty)
#	NVM	EEPROM		cały						   (1024 bajty)

# SCPH-90004   (0230EC20080220)
#	ROM0	BOOT ROM	cały					0xBFC00000 (4193627 bajty)
#	ROM1	DVD ROM		0x00000000 0x0007FFFF (80000)		0xBE000000 (429135 bajty)
#	ROM2	DVD ROM		0x00000000 0x0007FFFF (80000)		-
#	EROM	DVD ROM		0x00800000 0x0037FFFF (320000)		0xBE080000 (3670016 bajty)
#	NVM	EEPROM		cały						   (1024 bajty)

#-------------------------------------------------------------------------------------------------


# SP193_NFO:
#
# ROM0	Boot ROM.
# ROM1	Contains EROMDRV, which allows access to the encrypted erom device.
# ROM2	Contains the Chinese font. Only exists on Chinese consoles.
# EROM	Contains the DVD player.
# NVM	Contains OSD settings, calibration data for the CD/DVD drive, system settings (e.g. tray eject speed and system fan speed) and IDs (console and i.Link, plus MAC address).
# MEC	Contain the MECHACON version data.

