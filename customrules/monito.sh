monito(){
#This rule is designed to allow connection from a Monitoring server in one or more port.
#$i : each IP for this rule configured in ipconf file
#$j : each port for this rule configured in portconf file

_ip=1
_port=1

echo -e "###### MONITORING RULES #####"

fileexist $_ipconf
fileexist $_portconf
if [ $exist -eq 1 ];
then
	paramfind "mnt" "$_ipconf"
	_mntip="$_param"
	paramfind "mnt" "$_portconf"
	_mntport="$_param"
	
	if [ -z "$_mntip" ];
	then
		echo -e "$_noip"
	elif [ -z "$_mntport" ];
	then
		echo -e "$_noport"
	else
	        for i in $_mntip
	        do
	                for j in $_mntport
	                do
		                _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "MONITORING INPUT FROM $i ON $j PORT" 2>&1 >/dev/null)
		                _rulesvalue="Allow MONITORING server from IP $i on $j port"
		                validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
		   	done
		done
	fi
fi

}
