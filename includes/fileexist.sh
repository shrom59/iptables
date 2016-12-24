fileexist (){

#Check if a file exist or not.
#$1 the file need to be tested
#If the file exist, then $_exist=1 else, $exist=0

if [ ! -f "$1" ];
then
	exist=0;
	echo -e "$_rcolor""$_rulesnotapplied""$_dcolor""$_accon""$_rcolor""NOT APPLIED""$_dcolor""$_accoff""The" "$1" "file doesn't exist.you have to check it first"
else
	exist=1;
fi

}
