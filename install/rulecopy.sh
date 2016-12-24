#!/bin/bash

rulecopy () {
#This function will copy the selected rules during isntallation


if [ $_port -ge 1  ] || [ $_ip -ge 1 ];
then
		_customrulesold=$(cd "$_current""../customrules/" && ls -1 "$_customrules".sh)
	        cp "$_current"../"customrules/"$_customrules".sh" "$_installdir/rules"
        	customrulesnew=$(cd $_installdir/rules/ && ls -1 "$_customrules".sh && cd $_current) #We list the rules to compare if the copy is ok.
	        compare "$_custrulesold" "$_customrulesnew" "$_customrules.sh" "file"
		_sep=";"
		sed -i "/established/i "$_customrules""$_sep"" $_installdir/includes/dostart.sh #We add the rule before teh established line in dostart.sh function file.
		sed -i "/"$_customrules"/a echo" "$_installdir"/includes/dostart.sh #we add "echo" line to be more clear 
		echo "$_customrules" >> "$_installdir"/rules_ok #This will use in init script to load only added rule and not * from a folder for security reason
elif [ $_ip -l 1 ];
then
		echo -e "$_accon""$_rcolor" "NOT COPIED" "$_dcolor""$_accoff""The" "$_customrules" "rule is not copied because the ip configuration failed.""$_cr"
elif [ $_port -l 1 ];
then
        echo -e "$_accon""$_rcolor" "NOT COPIED" "$_dcolor""$_accoff""The" "$_customrules" "rule is not copied because the port configuration failed.""$_cr"
fi
}
