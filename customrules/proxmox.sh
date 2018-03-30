proxmox()

#This rule will allow all connection from one or many IP for a Proxmox cluster on all port

{
	_ip=1

	echo -e "###### PROXMOX RULES #####"

	fileexist $_ipconf;
	if [ $exist -eq 1 ];
	then
      paramfind "proxmox" "$_ipconf"
			_sship="$_param"
			  if [ -z "$_sship" ];
				then
				      echo -e "$_noip"
        else
							      for i in $_sship
										do
                        _rules=$(iptables -t filter -A INPUT --src $i -j ACCEPT -m comment --comment "ALLOW PROMOX SERVER FROM $i" 2>&1 >/dev/null)
												_rulesvalue="Allow Proxmox server from IP $i"
												validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
										done
        fi

	fi
}
