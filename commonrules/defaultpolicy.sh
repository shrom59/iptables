defaultpolicy(){

#DROP by default all connections in entry and on forward tables

echo -e "###### DEFAULT POLICY RULES #####"

_dropallinput=$(iptables -t filter -P INPUT DROP 2>&1 >/dev/null)
_rulesvalue="Drop all Input traffic"

rules "$_dropallinput" "$_rulesvalue"

_dropallforward=$(iptables -t filter -P FORWARD DROP 2>&1 >/dev/null) 
_rulesvalue="Drop all forward traffic"

rules "$_dropallforward" "$_rulesvalue"

_dropallinputv6=$(ip6tables -t filter -P INPUT DROP 2>&1 >/dev/null)
_rulesvalue="Drop all Input IPV6 traffic"

rules "$_dropallinputv6" "$_rulesvalue"

_dropallforwardv6=$(ip6tables -t filter -P FORWARD DROP 2>&1 >/dev/null)
_rulesvalue="Drop all Forward IPV6 traffic"

rules "$_dropallforwardv6" "$_rulesvalue"

_dropalloutputv6=$(ip6tables -t filter -P OUTPUT DROP 2>&1 >/dev/null)
_rulesvalue="Drop all Output IPV6 traffic"

rules "$_dropalloutputv6" "$_rulesvalue"

}
