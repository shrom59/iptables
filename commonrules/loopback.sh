loopback(){

# Trust loopback to allow current server to connect and communicate without problem to other network (Internet or othe IP)

echo -e "###### LOOPBACK RULES #####"

_loopbackinput=$(iptables -t filter -A INPUT -i lo -j ACCEPT -m comment --comment "LOOPBACK INPUT RULES" 2>&1 >/dev/null)
_rulesvalue="Allow loopback connections"

rules "$_loopbackinput" "$_rulesvalue"

}
