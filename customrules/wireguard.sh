#This rule will allow all UDP connection (inclunding ESP) for strongswan VPN in transport mode
wireguard(){
_wg=1

echo "###### WIREGUARD RULES #####"

fileexist $_wgconf

if [ $exist -eq 1 ];
then
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
fi
}
