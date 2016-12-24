rtorrent(){
_port=1

echo -e "###### RTORRENT RULES #####"

fileexist $_portconf

if [ $exist -eq 1 ];
then
        paramfind "rtorrent" "$_portconf"
        _rtorrentport="$_param"
	
	if [ -z "$_rtorrentport" ];
        then
                echo -e "$_noport"
        else
                for i in $_rtorrentport
                do
			_rtorrentrule=$(iptables -t filter -A INPUT -p tcp --dport $i -j ACCEPT -m comment --comment "RTORRENT RULES ON $i PORT" 2>&1 >/dev/null) 
			_rulesvalue="rTorrent Input traffic on $i port"
			rules "$_rtorrentrule" "$_rulesvalue"
		done
	fi
fi
}
