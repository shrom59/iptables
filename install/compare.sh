#!/bin/bash

compare() {

#This function will check if the files in the sources folder are the same in the destination folder
#$1 : source files list
#$2 : Destination files list
#$3 : Name of the file or folder (Common name)
#$4 : This is a file or a direcory ?
#$_installdir : Destination folder 

if [ "$4" = "dir" ];
then
        if [ -d $_installdir/$3 ];
        then
                if [ "$1" != "$2" ];
                then
                        echo -e "Copying the" "$3" "files..."
                        echo -e "$_accon""$_rcolor" "NOT COPIED" "$_dcolor""$_accoff""All the" "$3" "files are not been correctly copied."
                        _error=1
                else
                        echo -e "Copying the" "$3" "files..."
                        echo -e "$_accon""$_gcolor" "COPIED" "$_dcolor""$_accoff""All the" "$3" "files are correctly copied !"
                fi
        else
                echo -e "$_accon""$_rcolor" "NOT CREATED" "$_dcolor""$_accoff""The directory ""$_installdir" "$3" "is not created.Are you really root ?"
                exit 1
        fi
elif [ "$4" = "file" ];
then
        if [ -d $_installdir ];
        then
                if [ "$1" != "$2" ];
                then
                        echo -e "Copying the" "$3" "file..."
                        echo -e "$_accon""$_rcolor" "NOT COPIED" "$_dcolor""$_accoff""The" "$3" "file is not correctly copied."
                        _error=1
                else
                        echo -e "Copying the" "$3" "file..."
                        echo -e "$_accon""$_gcolor" "COPIED" "$_dcolor""$_accoff""The" "$3" "file is correctly copied !"
                fi
        fi
fi
}
