defaultpolicy(){

#DROP by default all connections in entry and on forward tables

echo -e "###### DEFAULT POLICY RULES #####"

_dropallinput=$(iptables -t filter -P INPUT DROP 2>&1 >/dev/null)
_rulesvalue="Drop all Input traffic"

rules "$_dropallinput" "$_rulesvalue"

_dropallforward=$(iptables -t filter -P FORWARD DROP 2>&1 >/dev/null) 
_rulesvalue="Drop all forward traffic"

rules "$_dropallforward" "$_rulesvalue"

}
