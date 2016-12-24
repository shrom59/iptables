https(){

#This rule is designed to allow connection for all IP to a web server in one or more port.
#$i : each IP for this rule configured in ipconf file
#$j : each port for this rule configured in portconf file

_ip=1
_port=1

echo -e "###### HTTPS RULES #####"

fileexist $_ipconf
fileexist $_portconf
if [ $exist -eq 1 ];
then
	 paramfind "https" "$_ipconf"
        _httpsip="$_param"
        paramfind "https" "$_portconf"
        _httpsport="$_param"
		
        if [ -z "$_httpsip" ];
        then
                echo -e "$_noip"
        elif [ -z "$_httpsport" ];
        then
                echo -e "$_noport"
        else
                for i in $_httpsip
                do
                        for j in $_httpsport
                        do
                        _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "HTTPS INPUT FOR $i ON $j PORT" 2>&1 >/dev/null)
                        _rulesvalue="Allow HTTPS for IP $i on $j port"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
                        done
                done
        fi
fi

}
