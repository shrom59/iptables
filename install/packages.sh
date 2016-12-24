#!/bin/bash
#$1 is the packages name.
packages(){
_packages=$(dpkg-query -l "$1" 2>&1 /dev/null |grep ii |awk '{print $1}')
if [ "$_packages" == "ii" ]; #if the package is installed, we continue, else we quit generate $_installerr=1 to quit later ;)
then
         echo -e "$_accon""$_gcolor" "INSTALLED" "$_dcolor""$_accoff""The package" "$1" "seems installed"
else
        echo -e "$_accon""$_rcolor" "NOT INSTALLED" "$_dcolor""$_accoff""The package" "$1" "seems not installed."
        _installerr=1
fi
}
