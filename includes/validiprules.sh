validiprules(){

#This function will check if the IP or hostname format is correct or not
#$1 is the result of the rule command passed in iptables
#$2 is the label name who is displayed when we start / stop the firewall

if [ $# -eq 5 ];
then
	#If it's look's like a hostname
	if [[ $i =~ ^[a-zA-Z]|[a-zA-Z][a-zA-Z\-]*[a-zA-Z]\.*([A-Za-z]|[A-Za-z][A-Za-z\-]*[A-Za-z])$ ]];
	then
		rules "$1" "$2" 
	elif [[ $i =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}$ ]]; #If it look's like an ip with a mask
	then
		_ip=$(ipcalc $i | grep -i "INVALID ADDRESS")
	   	_mask=$(ipcalc $i | grep -i "INVALID MASK")
         	if [ -z "$_ip" ]; #If The ip format seems good then 
	        then
        	        if [ -z "$_mask" ]; #If the mask seems good then
                	then
				rules "$1" "$2" #we add the rule
			else
				echo -e "$_rulesnotapplied $2 (Error : Invalid mask for $i)" # We print an error message
			fi
		else
			echo -e "$_rulesnotapplied $2 (Error : Invalid IP for $i) " #We print an error message
		fi
	elif [[ $i =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; # If it look's like an IP without mask
        then
		_ip=$(ipcalc $i | grep -i "INVALID ADDRESS")
                _mask=$(ipcalc $i | grep -i "INVALID MASK")
                if [ -z "$IP" ]; #If look like A.B.C.D
                then
                        if [ -z "$MASK" ]; #If have a valid mask
			then
				rules "$1" "$2" #we add the rule
			else
				echo -e "$_rulesnotapplied $2 (Error : Invalid mask for $i)" #We print an error message
			fi
		else
			echo -e "$_rulesnotapplied $2 (Error : Invalid IP for $i)" #we print an error message
                fi
	else
		echo -e "$RULESNOTAPPLIED $2 (Error : Invalid format for $i)" #we print an error message
	fi
else
   echo -e "$_rcolor""Parameters missings, IPs in parameters file will not added in firewall rules""$_drcolor"
fi

}

