http(){

#This rule is designed to allow connection for all IP to a web server in one or more port.
#$i : each IP for this rule configured in ipconf file
#$j : each port for this rule configured in portconf file

_ip=1
_port=1

echo -e "###### HTTP RULES #####"

fileexist $_ipconf
fileexist $_portconf
if [ $exist -eq 1 ];
then
        paramfind "http" "$_ipconf"
	_httpip="$_param"
        paramfind "http" "$_portconf"
	_httpport="$_param"

        if [ -z "$_httpip" ];
        then
                echo -e "$_noip"
        elif [ -z "$_httpport" ];
        then
                echo -e "$_noport"
        else
                for i in $_httpip
                do
                        for j in $_httpport
                        do
                        _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "HTTP INPUT FOR $i ON $j PORT" 2>&1 >/dev/null)
                        _rulesvalue="Allow HTTP for IP $i on $j port"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
                        done
                done
        fi
fi

}

