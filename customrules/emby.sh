emby(){

#This rule is designed to allow connection for all IP to a emby server in one or more port.
#$i : each IP for this rule configured in ipconf file
#$j : each port for this rule configured in portconf file

_ip=1
_port=1

echo -e "###### EMBY RULES #####"

fileexist $_ipconf
fileexist $_portconf
if [ $exist -eq 1 ];
then
        paramfind "emby" "$_ipconf"
	_embyip="$_param"
	paramfind "emby" "$_portconf"
	_embyport="$_param"
        if [ -z "$_embyip" ];
        then
                echo -e "$_noip"
        elif [ -z "$_embyport" ];
	then
		echo -e "$_noport"
	else
		for i in $_embyip
                do
			for j in $_embyport 
			do 
                        _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "EMBY INPUT FOR $i ON $j PORT" 2>&1 >/dev/null)
                        _rulesvalue="Allow EMBY for IP $i on $j port"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
			done
                done
        fi
fi
}
