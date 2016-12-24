dostop(){

#Stop the firewall and allow all connections
#This is not recommended to use this function except for testing an application here.

 iptables -F
 iptables -t nat -F
 iptables -t mangle -F
 iptables -P INPUT ACCEPT
 iptables -P FORWARD ACCEPT
 iptables -P OUTPUT ACCEPT

}
