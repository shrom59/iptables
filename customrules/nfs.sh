
nfs(){

_ip=1
_port=1

echo -e "###### NFS RULES #####"

fileexist $_ipconf;
fileexist $_portconf;
if [ $exist -eq 1 ];
then
        paramfind "nfs" "$_ipconf"
	_nfsip="$_param"
	paramfind "nfs" "$_portconf"
	_nfsport="$_param"

	if [ -z "$_nfsip" ];
        then
                echo -e "$_noip"
        elif [ -z "$_nfsport" ];
        then
                echo -e "$_noport"
        else
                for i in $_nfsip
                do
                        for j in $_nfsport
                        do
                        _rules=$(iptables -t filter -A INPUT -p tcp --src $i --dport $j -j ACCEPT -m comment --comment "ALLOW RULE FOR $i ON $j PORT" 2>&1 >/dev/null)
                        _rulesvalue="Allow RULE for IP $i on $j port"
                        validiprules "$_rules" "$_rulesvalue" "$_invalidmask" "$_invalidip" "$i"
                        done
                done
        fi

fi
}
