vpn(){

#This rule will allow all UDP connection (inclunding ESP) for strongswann VPN in transport mode

echo "###### VPN TRANSPORT RULES #####"

##UDP PORT 500
_inputudp500=$(iptables -A INPUT -i ethO -p udp --sport 500 --dport 500 -j ACCEPT -m comment --comment "ALLOW IPSEC PORT 500 " 2>&1 >/dev/null)
_rulesvalue500="Allowing UDP 500 port for IPSec"

rules "$_inputudp500" "$_rulesvalue500"

#UDP PORT 4500
_inputudp4500=$(iptables -A INPUT -i eth0 -p udp --sport 4500 --dport 4500 -j ACCEPT -m comment --comment "ALLOW IPSEC PORT 4500 " 2>&1  >/dev/null)
_rulesvalue4500="Allowing UDP 4500 port for IPSec"
rules "$_inputudp4500" "$_rulesvalue4500"

##ESP
_inputesp=$(iptables -A INPUT -i eth0 -p esp -j ACCEPT -m comment --comment "ALLOW ESP FOR IPSEC")
_rulesvalueesp="Allowing ESP for IPSEC"
rules "$_inputesp" "$_rulesvalueesp"

}
