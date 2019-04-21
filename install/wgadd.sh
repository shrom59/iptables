#!/bin/bash
wgadd() {

#This function will test if the wg interface name in parameter need to be added or not

#This function will also check if the wg was already installed or not in the wg configuration.
#$1 : vpn interface name
#$2 : bound interface name
#$_wg will be "ok" if we can install the rule using rule copy later ;)
#$_wg="ok" if the wg interface name port is added or if the port is configured in the port configuration (first install)
if [ "$1" == "c" ];
then
	echo -e "$_rcolor""The" "$_customrules" "rule will not be installed because the wg interface parameters is required""$_dcolor"
	break
else
	_checkexist=$(cat "$_installdir"/"$_wgconf" |grep -w "$_customrules")
	if [ ! -z "$_checkexist" ];
 	then 
		echo -e "$_accon""$_rcolor" "ALREADY ADDED" "$_dcolor""$_accoff""The wg configuration already exists in" "$_installdir""/""$_wgconf""$_cr"
	else
		for i in "$@"
		do
			endline "$_wgconf"
			_checkexist=$(cat "$_installdir"/"$_wgconf" |grep -w "$_customrules")
			if [ -z "$_checkexist" ];
		 	then 
				echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""The interface name is not added to" "$_installdir""/""$_wgconf""$_cr"
			else
				echo -e "$_accon""$_gcolor" "ADDED" "$_dcolor""$_accoff""The interface name ""$i"" is added to" "$_installdir""/""$_wgconf""$_cr"
				((_wg++))
			fi
		done
	fi
fi
}
