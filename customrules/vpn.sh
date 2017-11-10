#This rule will allow all UDP connection (inclunding ESP) for strongswan VPN in transport mode
vpn(){

_ip=1

echo "###### VPN TRANSPORT RULES #####"

fileexist $_ipconf;


if [ $exist -eq 1 ];
then
  paramfind "vpn" "$_ipconf"
	_vpnip="$_param"

	if [ -z "$_vpnip" ];
        then
                echo -e "$_noip"
        else
                for i in $_vpnip
                do    
		      #policy rules
		      _inputpol=$(iptables -A INPUT --src $i -i eth0 -m policy --dir in --pol ipsec --reqid 1 --proto esp -j ACCEPT)
		      _rulespol="Allow policy for $i"
		      
		      rules "$_inputpol" "$_rulespol"
	
                      #UDP PORT 500
                      _inputudp500=$(iptables -A INPUT -i eth0 --src $i -p udp --sport 500 --dport 500 -j ACCEPT -m comment --comment "ALLOW IPSEC FOR $i ON PORT 500" 2>&1 >/dev/null)
                      _rulesvalue500="Allow IPSEC for $i on 500 port"

                      rules "$_inputudp500" "$_rulesvalue500"

                      #UDP PORT 4500
                      _inputudp4500=$(iptables -A INPUT -i eth0 --src $i -p udp --sport 4500 --dport 4500 -j ACCEPT -m comment --comment "ALLOW IPSEC FOR $i ON PORT 4500" 2>&1  >/dev/null)
                      _rulesvalue4500="Allow IPSEC for $i on 4500 port"
                      rules "$_inputudp4500" "$_rulesvalue4500"
		      
                      ##ESP
                      _inputesp=$(iptables -A INPUT -i eth0 --src $i -p esp -j ACCEPT -m comment --comment "ALLOW ESP FOR $i")
                      _rulesvalueesp="Allow ESP for $i"
                      rules "$_inputesp" "$_rulesvalueesp"                      
                      
                done
        fi
fi
}
