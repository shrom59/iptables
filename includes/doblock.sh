doblock(){

#This function will block all the traffic on this server.
#So this function should be lunch only if you are under attack.
#The only to access to your server is a KVM method or reboot your server.
#$_rep = Y/y or N/n. If Y/y then all traffic will be block drectly.
#If N/n then, nothing will be changed. 

echo -n "You're about block all traffic, do ou really want to do that (y/n) : "
read _rep
case $_rep in
        y|Y)
	 echo -e "$_rcolor""Blocking all traffic..""$_dcolor"
	 iptables -F
	 iptables -t nat -F
	 iptables -t mangle -F
	 iptables -P INPUT DROP
	 iptables -P FORWARD DROP
	 iptables -P OUTPUT DROP
	echo -e "$_rcolor""Traffic blocked""$_dcolor"
	exit 1
	;;
        n|N)
         echo -e "$_gcolor""Aborted, nothing changed""$_dcolor"
         exit 1;
        ;;
        *)
	 echo "You have to made a choice.."
         exit 1;
        ;;
esac
}
