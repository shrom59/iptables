blacklist(){

#We will block all ip who has not autorised.
#For exemple, you found an IP who DOSing you, you will able to block it here 
#$i : each IP for this rule configured in ipconf file 
_ip=1

echo -e "###### BLACKLIST RULES #####"

fileexist $_ipconf
if [ $exist -eq 1 ];
then
	paramfind "blacklist" "$_ipconf"
	_blacklistip="$_param"

	if [ -z "$_blacklistip" ];
	then
		echo -e "$_noip"
	else
		for i in $_blacklistip
		do
			_rules=$(iptables -I INPUT -s $i -j DROP -m comment --comment "BLOCKING ALL FOR : $i" 2>&1 >/dev/null)
			_rulesvalue="Block  ICMP for IP $i"
			validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
		done
	fi
fi

}
