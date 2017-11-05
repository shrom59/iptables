icmp(){

#This rule will allow ICMP for one or more IP
#$i : each IP for this rule configured in ipconf file

_ip=1

echo -e "###### ICMP RULES #####"

fileexist $_ipconf
if [ $exist -eq 1 ];
then
	paramfind "icmp" "$_ipconf"
	_icmpip="$_param"

        if [ -z "$_icmpip" ];
        then
                echo -e "$_noip"
        else
                for i in $_icmpip
                do
                        _rules=$(iptables -t filter -A INPUT -p icmp --src $i -j ACCEPT -m comment --comment "ICMP FOR IP : $i " 2>&1 >/dev/nul)
                        _rulesvalue="Allow ICMP for IP $i"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
                done
        fi
fi

}

