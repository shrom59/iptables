torrent(){
_port=1

echo -e "###### TORRENT RULES #####"

fileexist $_portconf

if [ $exist -eq 1 ];
then
        paramfind "torrent" "$_portconf"
        _torrentport="$_param"
	
	if [ -z "$_torrentport" ];
        then
                echo -e "$_noport"
        else
                for i in $_torrentport
                do
			_torrentrule=$(iptables -t filter -A INPUT -p tcp --dport $i -j ACCEPT -m comment --comment "TORRENT INPUT TCP ON $i PORT" 2>&1 >/dev/null) 
			_rulesvalue="Torrent input TCP on $i port"
			rules "$_torrentrule" "$_rulesvalue"
		done
		for i in $_torrentport
                do
			_torrentrule=$(iptables -t filter -A INPUT -p udp --dport $i -j ACCEPT -m comment --comment "TORRENT INPUT UDP ON $i PORT" 2>&1 >/dev/null) 
			_rulesvalue="Torrent input UDP on $i port"
			rules "$_torrentrule" "$_rulesvalue"
		done
	fi
fi
}
