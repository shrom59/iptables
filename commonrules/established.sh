established(){

#Keeping all current connections to avoid killes used connections when the firewall will be restarted.
#If not and if your are connected to ssh in the remote host, you will be disconnected

echo "###### ESTABLISHED RULES #####"

_inputestabished=$(iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT -m comment --comment "KEEP INPUT ESTABLISHED CONNECTION" 2>&1 >/dev/null)
_rulesvalue="Keeping established input connections"

rules "$_inputestablished" "$_rulesvalue"

}
