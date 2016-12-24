ssh(){

#This rule is designed to allow connection for all IP to a ssh server in one or more port.
#$i : each IP for this rule configured in ipconf file
#$j : each port for this rule configured in portconf file

_ip=1
_port=1

echo -e "###### SSH RULES #####"

fileexist $_ipconf;
fileexist $_portconf;
if [ $exist -eq 1 ];
then
        paramfind "ssh" "$_ipconf"
	_sship="$_param"
	paramfind "ssh" "$_portconf"
	_sshport="$_param"

	if [ -z "$_sship" ];
        then
                echo -e "$_noip"
        elif [ -z "$_sshport" ];
        then
                echo -e "$_noport"
        else
                for i in $_sship
                do
                        for j in $_sshport
                        do
                        _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "ALLOW SSH FOR $i ON $j PORT" 2>&1 >/dev/null)
                        _rulesvalue="Allow SSH for IP $i on $j port"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
                        done
                done
        fi

fi
}
