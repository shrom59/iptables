#This rule will allow all UDP connection (inclunding ESP) for strongswan VPN in transport mode
wireguard(){
_wg=1
_port=1
_ip=1

echo "###### WIREGUARD RULES #####"

fileexist $_wgconf

if [ $exist -eq 1 ];
then
	paramfind "wireguard" "$_ipconf"
	_wgip="$_param"
	paramfind "wireguard" "$_portconf"
	_wgport="$_param"

	paramfind "wireguard" "$_wgconf"
	_vpnint=$(echo "$_param" | cut -d " " -f1)
	_vpnbound=$(echo "$_param" | cut -d " " -f2)


        #WIREGUARD FORWARD INPUT RULE 
        _wgfwinrule=$(iptables -A FORWARD -i $_vpnint -j ACCEPT -m comment --comment "ALLOW INPUT FORWARD FOR WIREGUARD ON ""$_vpnint" 2>&1 >/dev/null)
        _wgrulevalue="Allow input for wireguard on ""$_vpnint"

        rules "$_wgfwinrule" "$_wgrulevalue"

        #WIREGUARD OUTPUT FORWARD RULE 
        _wgfwoutrule=$(iptables -A FORWARD -o $_vpnint -j ACCEPT -m comment --comment "ALLOW OUTPUT FORWARD FOR WIREGUARD ON ""$_vpnint" 2>&1 >/dev/null)
        _wgruleoutvalue="Allow output wireguard on ""$_vpnint"

        rules "$_wgfwoutrule" "$_wgruleoutvalue"

        #WIREGUARD POSTROUTING RULE 
        _wgfwpostrule=$(iptables -t nat -A POSTROUTING -o "$_vpnbound" -j MASQUERADE -m comment --comment "ALLOW OUTPUT FORWARD FOR WIREGUARD ON ""$_vpnint" 2>&1 >/dev/null)
        _wgrulepostvalue="Allow postrouting wireguard on ""$_vpnbound"

        rules "$_wgfwpostrule" "$_wgrulepostvalue"

	if [ -z "$_wgip" ];
	then
		echo -e "$no_ip"
	elif [ -z "$_wgport" ];
	then
		echo -e "$no_port"
	else
		for i in $_wgip
		do
			for j in $_wgport
	  		do 				
				#WIREGUARD UDP PORT RULE 
       	        		_wgportrule=$(iptables -t filter -A INPUT -p udp --src $i --dport $j -j ACCEPT -m comment --comment "ALLOW WIREGUARD PORT FOR $i ON $j PORT" 2>&1 >/dev/null)
		                _wgportrulevalue="Allow WIREGUARD for IP $i on $j port"
		                rules "$_wgportrule" "$_wgportrulevalue"
			done
		done
	fi
fi
}
