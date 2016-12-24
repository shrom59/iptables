vpnserver(){

#This rule is designed to allow all connection on specific port.
#$i each port for this rule configured in portconf file

_port=1

echo -e "###### VPN RULES #####"

fileexist $_portconf

if [ $exist -eq 1 ];
then
        paramfind "vpnserver" "$_portconf"
        _vpnport="$_param"

        if [ -z "$_vpnport" ];
        then
                echo -e "$_noport"
        else
                for i in $_vpnport
                do
			vpninput=$(iptables -A INPUT -i eth0 -p udp --dport $i -j ACCEPT -m comment --comment "VPN INPUT RULES ON $i PORT" 2>&1 >/dev/null)
			rulesvalue="Open VPN input on $i port"
			rules "$vpninput" "$rulesvalue"
		done
	fi
fi
}
