#!/bin/bash

#This function will test if the ip in parameter is an correct hosntame or IP.

#This function will also check if the ip was already installed or not in the ip connfiguration.
#$1 the custom ip
#$_ip will be "ok" if we can install the rule using rule copy later ;)
#$_ip="ok" if the ip is added or if the ip is configured in the ip configuration

checkadd () {

_checkip=$(cat "$_installdir"/"$_ipconf" |grep -w "$_customrules" |grep -w "$i")
if [ -z "$_checkip" ]; #If the ip does not exist, we we informe the user
then
	echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""$i"" format is good but not written in" "$_installdir"/"$_ipconf"".""Are you root ?""$_cr"
else # else we informed that all is ok :)
	echo -e "$_accon""$_gcolor" "ADDED" "$_dcolor""$_accoff""$i"" is added to" "$_installdir"/"$_ipconf""$_cr"
        ((_ip++))
fi

}

ipadd () {
if [ "$1" == "c" ];
then
        echo -e "$_rcolor""The" "$_customrules" "rule will not be installed because the IP configuration parameters is required""$_dcolor"
	break
else
	 for i in "$@"
	 do
		_checkip=$(cat "$_installdir"/"$_ipconf" |grep -w "$_customrules" |grep -w "$i")
		IP=$(ipcalc $i | grep "INVALID ADDRESS")
                MASK=$(ipcalc $i | grep "INVALID MASK")
		if [ ! -z "$_checkip" ]; #If the port exist in the portconf, we informed the user, but we will copy the rule afterall to be sure that those one is correct(if the user modify it, it allow him to restore it ;)). so $_port wiil be "ok".
                then
			echo -e "$_accon""$_rcolor" "ALREADY ADDED" "$_dcolor""$_accoff""The IP ""$i"" is already exists in" "$_installdir""$_ipconf""$_cr""for this rule"
	        elif [[ $i =~ ^[a-zA-Z]|[a-zA-Z][a-zA-Z\-]*[a-zA-Z]\.*([A-Za-z]|[A-Za-z][A-Za-z\-]*[A-Za-z])$ ]]; #If this is an hostname
		then
			endline "$_ipconf"
			checkadd "host"
		elif [[ $i =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; #Else If this this look like an ip with a mask
		then
			if [ -z "$IP" ]; #If $i look like A.B.C.D/YY
	                then
        	                if [ -z "$MASK" ]; #If $REP have a valid mask
                	        then
					endline "$_ipconf"
					checkadd
                        	else
					echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""$i" "contain an invalid mask""$_dcolor"
	                        fi
	                else
				echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""$i" "is not a correct IP""$_dcolor"
			fi
		elif [[ $i =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]];
		then
			if [ -z "$IP" ]; #If $i look like A.B.C.D
                        then
                                if [ -z "$MASK" ]; #If $REP have a valid mask
                                then
					endline "$_ipconf"
                                        checkadd
                                else
                                        echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""$i" "contain an invalid mask""$_dcolor"
                                fi
                        else
                                echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""$i" "is not a correct IP""$_dcolor"
                        fi
		else
			echo -e "$_accon""$_rcolor" "NOT ADDED" "$_dcolor""$_accoff""The ip ""$i"" format is not good and not added to" "$_installdir"/"$_ipconf"".""(The format is incorrect)""$_cr"	
		fi
        done
fi
}
