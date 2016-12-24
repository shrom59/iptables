clean(){

echo -e "###### CLEAN RULES #####"

#Flush all current tables

_persotable=$(iptables -t filter -F 2>&1 >/dev/null)
_rulesvalue="Clean all current tables"

rules "$_persotable" "$_rulesvalue"

#Flush all personnal rules

_flushrules=$(iptables -t filter -X 2>&1 >/dev/null)
_rulesvalue="Flush all personnal rules"

rules "$_flushrules" "$_rulesvalue"

}
