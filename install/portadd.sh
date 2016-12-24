#!/bin/bash
portadd() {

#This function will test if the port in parameter is numeric or not

#This function will also check if the port was already installed or not in the port connfiguration.
#$1 the custom port
#$_port will be "ok" if we can install the rule using rule copy later ;)
#$_port="ok" if the port is added or if the port is configured in the port configuration (first install)
if [ "$1" == "c" ];
then
	echo -e "$_rcolor""The" "$_customrules" "rule will not be installed because the port configuration parameters is required""$_dcolor"
	break
else
	for i in "$@"
	do
	        _checkport=$(cat "$_installdir"/"$_portconf" |grep -w "$i")
	       if [ ! -z $_checkport ]; #If the port exist in the portconf, we informed the user, but we will copy the rule afterall to be sure that those one is correct(if the user modify it, it allow him to restore it ;)). so $_port wiil be "ok". 
               then 
			echo -e "$_accon""$_rcolor" "ALREADY ADDED" "$_dcolor""$_accoff""The port ""$i"" is already exists in" "$_installdir""$_portconf""$_cr""for this rule or another one."
	        elif [ $i -le 65535 ]; #else if, the $i is numeric.
	        then
	                endline "$_portconf"
			#echo -e "$_customrules""=""$i" >> "$_installdir"/"$_portconf"
	                _checkport=$(cat "$_installdir"/"$_portconf" |grep -w "$_customrules" |grep -w "$i")
	                if [ -z "$_checkport" ]; #If the port does not exist, we we informe the user
	                then
        	           echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""The port ""$i"" format is good but not written in" "$_installdir"/"$_portconf"".""Are you root ?""$_cr"
	                else # else we informed that all is ok :)
	                   echo -e "$_accon""$_gcolor" "ADDED" "$_dcolor""$_accoff""The port ""$i"" is added to" "$_installdir"/"$_portconf""$_cr"
	                   ((_port++))
	                fi
	        else # else the port seems not be a number.
	                echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""The port ""$i"" is not added to" "$_installdir"/"$_portconf"".""(This is not a number or the port is over than 65535)""$_cr"
	        fi
	done
fi
}
