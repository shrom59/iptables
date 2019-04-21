dostatus(){

#Display all current rules applied in iptables with the line numbers

echo -e "$_gcolor"" ---------- IPTABLES FOR IPV4 ---------- ""$_dcolor"
iptables -L -n -v -t nat --line-numbers
echo
echo -e "$_gcolor"" ---------- IPTABLES FOR IPV6 ---------- ""$_dcolor"
ip6tables -L -n -v -t nat --line-numbers
}
