vpnclient(){

#This rule is designed to allow all connection on VPN

echo -e "###### VPN RULES #####"

vpninput=$(iptables -A INPUT -i tun0 -j ACCEPT -m comment --comment "VPN INPUT RULES TO ALLOW ALL TRAFFIC ON TUN0" 2>&1 >/dev/null)
rulesvalue="VPN UDP Input traffic"

rules "$vpninput" "$rulesvalue"
}
