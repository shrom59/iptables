#!/bin/bash

checkipport() {
########## This function will check in rule file if we need to add an IP or port in configuration file ##########

portcheck () {
#### Port checking ####

_portneeded=$(cat ../customrules/"$_customrules".sh |grep "_port=" |cut -d "=" -f 2)
_port=0
case $_portneeded in
	1)
		read -e -p "What's the input port of ""$_customrules"" server ? (separate port by space or type 'c' to cancel)
Port : " _serverport
		portadd $_serverport
	;;
	2)
		read -e -p "What's the ""$_customrules"" input TCP port ? (separate port by space or type 'c' to cancel)
Port : " _tcpport
		portadd $_tcpport
        	read -e -p "What's the ""$_customrules"" input UDP port ? (separate port by space or type 'c' to cancel)
Port : " _udpport
	        portadd $_udpport
	;;
	*)
		echo -e "$_gcolor""No port need to be added here""$_dcolor"
		_port=1
	;;
esac
}

ipcheck () {

#### IP checking ####

_ipneeded=$(cat ../customrules/"$_customrules".sh |grep "_ip=" |cut -d "=" -f 2)
_ip=0
case $_ipneeded in
	1)
		read -e -p "Enter the source IP(s) or Hostname(s) do you want to add separate by space (type 'c' to cancel)?
IP(s) or Hostname(s) : " _serverip
		ipadd $_serverip
	;;
	*)
		echo -e "$_gcolor""No ip need to be parameters here""$_dcolor"
		_ip=1
	;;
	esac
}

wgcheck () {

#### WG checking ####

_wgneeded=$(cat ../customrules/"$_customrules".sh |grep "_wg=" |cut -d "=" -f 2)
_wg=0
case $_wgneeded in
	1)
		read -e -p "Enter the VPN interface name (type 'c' to cancel)?
VPN interface name : " _vpnintname
		read -e -p "Enter the interface name where VPN will be bound to (type 'c' to cancel)?
Bound interface name : " _boundintname

		wgadd $_vpnintname $_boundintname
	;;
	*)
		echo -e "$_gcolor""No wg interface name need to be parameters here""$_dcolor"
		_wg=1
	;;
	esac
}


case "$1" in 
	port)
		portcheck
	;;
	ip)
		ipcheck
	;;
	wg)
		wgcheck
	;;
	*)
		portcheck
			while true
                        do
                                if [ $_port -eq 0 ] ; #If the port is not numeric we loop until valid number is entered to avoid unreachable server after installation
                                then
                                        echo -e "$_rcolor""A correct port configuration is required for this rule""$_dcolor"
                                        checkipport "port"
                                        continue #Loop until a port is placed.
                                else
                                break #We continue the install.
                                fi
                        done
		ipcheck
			while true
                        do
                                if [ $_ip -eq 0 ] ; #If the ip is not in good format we loop until valid number is entered to avoid unreachable server after installation
                                then
                                        echo -e "$_rcolor""A correct IP configuration is required for this rule""$_dcolor"
                                        checkipport "ip"
                                        continue #Loop until a port is placed.
                                else
                                break #We continue the install.
                                fi

                        done
		wgcheck
			while true
                        do
                                if [ $_wg -eq 0 ] ; #If the wg correct we loop until valid number is entered to avoid unreachable server after installation
                                then
                                        echo -e "$_rcolor""A correct WG configuration is required for this rule""$_dcolor"
                                        checkipport "wg"
                                        continue #Loop until a port is placed.
                                else
                                break #We continue the install.
                                fi

                        done
	;;
esac
	
}
