#!/bin/bash

WrongArg () {
	>&2 echo "wrong arguments!"
	exit 2
}

UnknownStatus () {
	>&2 echo "Unknown Status for $1!"
	exit 1
}

NoModule() {
	>&2 echo "Cannot load acpi_call kernel module!"
	exit 127
}

[ -f /proc/acpi/call ] || modprobe acpi_call || NoModule

if [ $1 = "cleanfan" ]; then
	echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/fan_mode
	sleep 5
	echo 0 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/fan_mode
elif [ $1 = "set" ]; then
	case $2 in
		"performance")
			case $3 in
				"extreme")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' > /proc/acpi/call
					;;
				"balance")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' > /proc/acpi/call
					;;
				"conservation")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0013B001' > /proc/acpi/call
					;;
				*)
					WrongArg
					;;
			esac
			;;

		"battery")
			case $3 in
				"normal")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' > /proc/acpi/call
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05' > /proc/acpi/call
					;;
				"conservation")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' > /proc/acpi/call
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x03' > /proc/acpi/call
					;;
				"rapidcharge")
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x05' > /proc/acpi/call
					echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' > /proc/acpi/call
					;;
				*)
					WrongArg
					;;
			esac
			;;
		*)
			WrongArg
			;;
	esac
elif [ $1 = "get" ]; then
	case $2 in
		"performance")
			FCMO=$(echo '\_SB.PCI0.LPC0.EC0.FCMO' > /proc/acpi/call; cat /proc/acpi/call | tr -d '\0')

			case ${FCMO} in
				"0x0called")
					echo "Intelligent Cooling"
					;;
				"0x1called")
					echo "Extreme Performance"
					;;
				"0x2called")
					echo "Battery Saving"
					;;
				*)
					UnknownStatus "Performance mode FCMO=${FCMO}"
					;;
			esac
			;;

		"battery")
			QCHO=$(echo '\_SB.PCI0.LPC0.EC0.QCHO' > /proc/acpi/call; cat /proc/acpi/call | tr -d '\0')
			BTSM=$(echo '\_SB.PCI0.LPC0.EC0.BTSM' > /proc/acpi/call; cat /proc/acpi/call | tr -d '\0')
			case ${QCHO} in
				"0x0called")
					echo "Rapid Charge Off"
					;;
				"0x1called")
					echo "Rapid Charge On"
					;;
				*)
					UnknownStatus "Rapid Charge QCHO=${QCHO}"
			esac
			case ${BTSM} in
				"0x0called")
					echo "Battery Conservation Off"
					;;
				"0x1called")
					echo "Battery Conservation On"
					;;
				*)
					UnknownStatus "Battery Conservation BTSM=${BTSM}"
			esac
			;;
		*)
			WrongArg
			;;
	esac
else
	WrongArg
fi
