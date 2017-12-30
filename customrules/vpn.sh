#This rule will allow all UDP connection (inclunding ESP) for strongswan VPN in transport mode
vpn(){

echo "###### VPN TRANSPORT RULES #####"

                      #UDP PORT 500
                      _inputudp500=$(iptables -A INPUT -i eth0 -p udp --sport 500 --dport 500 -j ACCEPT -m comment --comment "ALLOW IPSEC ON PORT 500" 2>&1 >/dev/null)
                      _rulesvalue500="Allow IPSEC for on 500 port"

                      rules "$_inputudp500" "$_rulesvalue500"

                      #UDP PORT 4500
                      _inputudp4500=$(iptables -A INPUT -i eth0 -p udp --sport 4500 --dport 4500 -j ACCEPT -m comment --comment "ALLOW IPSEC ON PORT 4500" 2>&1  >/dev/null)
                      _rulesvalue4500="Allow IPSEC on 4500 port"
                      rules "$_inputudp4500" "$_rulesvalue4500"
		      
                      ##ESP
                      _inputesp=$(iptables -A INPUT -i eth0 -p esp -j ACCEPT -m comment --comment "ALLOW ESP")
                      _rulesvalueesp="Allow ESP"
                      rules "$_inputesp" "$_rulesvalueesp"                      
}
