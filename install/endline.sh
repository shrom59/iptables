#!/bin/bash
endline() {
#This function will check if the line in a file exist and write at the end of the if the line exist or create a new line if not

#$1=the file name (ipconf or portconf)

_sep=";"
_checkline=$(cat "$_installdir"/"$1" |grep "$_customrules")
	if [ ! -z "$_checkline" ];
	then
		#sed -i "/"$_customrules"/s/.*/&"$i""$_sep"/" "$_installdir"/"$1"
		sed -i '/'$_customrules'/ s#$#'"$i""$_sep"'#' "$_installdir"/"$1"		
	else
		echo -e "$_customrules""=""$i""$_sep" >> "$_installdir"/"$1"
	fi
}
