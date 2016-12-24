paramfind(){

#This function will find all the ip/port who has to be applied for the adding rule
#$1 : the rule who to need this ip/port
#$2 : the configuration file (ipconf/portconf) where we want to find the IP/port. 
#e.g : we will find all the ip for http rule ($1) in ipconf file ($2).

_param=""
_param=$(cat "$2" | grep -iw $1 | cut -d = -f2 | tr -s ";" " ")

}
