rules(){

#This function will check if a rules is applied or not
#$1 is the return of the rule command sent in the rule (http, ssh, ...)
#$2 is the label of the rule display when we start / stop de firewall
#if $1 is empty then the rule is applied.
#if not, we print the error message

if [ -z "$1" ];
then
        echo -e "$_rulesapplied""$2"
else
        echo -e "$_rulesnotapplied""$2 (Error: $1)"
fi
}
