#!/bin/bash

#################### General variables ###################
_rcolor="\\033[1;31m"
_gcolor="\\033[1;32m"
_dcolor="\\033[0;39m"
_accon="["
_accoff="] - "
_cr="\n"
_tmpcurrent=$(pwd)
_current="$_tmpcurrent""/"
_portconf=portconf #Name of the portconf file (your application port will be stored in this)
_ipconf=ipconf #Name of the ipconf file (your application ip will be stored in this)
_wgconf=wgconf #Name of the wgconf file (specific for wireguard rule)

#################### Needed functions ###################
  
source "$_current"compare.sh
source "$_current"portadd.sh
source "$_current"rulecopy.sh
source "$_current"packages.sh
source "$_current"checkipport.sh
source "$_current"ipadd.sh
source "$_current"endline.sh
source "$_current"wgadd.sh

#################### End of needed functions ###################

##### Just a welcome message :) #####

echo -e "Firewall installation script"

##### We check if needed packages is installed or nor #####

packages iptables
packages ipcalc
packages dpkg
packages grep

if [ "$_installerr" = "1" ]; #we have check all need package and we quit if all package are not installed.
then
	echo -e "$_rcolor""The installation can't be continue until need plackage are not installed.You have to install needed packages first.""$_dcolor"
	exit 1
fi

##### Checking if this script is run as root. If not we exit the install script #####

if [[ $EUID -ne 0 ]]; # We check if we are root or not and we quit if not.
then
	echo -e "$_rcolor""You can't install the firewall if you are not root""$_dcolor""$_cr"
	exit 1
fi

##### Asking where the script files will be stored and put in in $_installdir_ #####

read -e -p "Where do you want to install the firewall script files ?
Install directory : " _installdir

_installdir=${_installdir%/}

##### Asking wich nanme do you want ot give to the firewall initialisation script #####

read -e -p "Wich alias name do you want to manage your firewall ?
Name : " _fwname

##### If the source and dest folder are the same, we quit. #####

if [ "$_current" = "$_installdir" ];
then
	echo -e "$_rcolor""You can't install the firewall in the same direcroy as the installation source folder.""$_dcolor"	
	exit 1
fi

##### Testing if this directory exist or we will create it #####

if [ ! -d "$_installdir" ]; #If the install dir doesn't exist we create it.
then
	mkdir -p $_installdir
	if [ -d "$_installdir" ]; #if $_installdir exist or not, the user will be informed
	then
		echo -e "Creating the install directory..."
		echo -e "$_accon""$_gcolor" "CREATED" "$_dcolor""$_accoff""The directory ""$_installdir" "has been created successfully"
	else
		echo -e "Creating the install directory..."
		echo -e "$_accon""$_rcolor" "NOT CREATED" "$_dcolor""$_accoff""The directory ""$_installdir" "can't be created.Are you really root ?"
		exit 1
	fi
else #If you already run the installation script the $_installdir should be exist.
	echo -e "Creating the install directory..."
	echo -e "$_accon""$_gcolor" "ALREADY EXIST" "$_dcolor""$_accoff""The directory ""$_installdir" "already exist"
fi 
##### Copy the firewall script files in $_installdir #####

#Includes files
#Here we will copy all the needfunction for this firewall
_includelist=$(ls -1 "$_current"../includes ) #Listing the includes files to check if all is correctly copied
for i in $_includelist
do
	_includelistold=$(cd "$_current"../includes/ && ls -1 $i)
	if [ ! -d "$_installdir"/includes/ ];
        then
                mkdir "$_installdir"/includes/
        fi
	cp ../includes/"$i" "$_installdir"/includes/"$i"
	_includelistnew=$(cd $_installdir/includes/ && ls -1 $i && cd $_current ) #Listing the copied files and check in compare function if it's the same or not (to be sure there is no custom functions)
	compare "$_includelistold" "$_includelistnew" "$i" "file"
done


#Rules files
#Here we copy all the needed rules in a file. This will allow you to play with dev rules and testign rules also. 
_ruleslist=$(ls -1 "$_current"../commonrules ) #Listing the files to check if all is correctly copied and write it in a rules_ok file under $_installdir

if [ -e "$_installdir"/rules_ok ];
then
                rm -r "$_installdir"/rules_ok
fi

for i in $_ruleslist
do
	_ruleslistold=$(cd "$_current"../commonrules/ && ls -1 $i)
	if [ ! -d "$_installdir"/rules/ ];
	then
		mkdir "$_installdir"/rules/
	fi
	cp ../commonrules/"$i" "$_installdir"/rules/"$i"
	_ruleslistnew=$(cd $_installdir/rules/ && ls -1 $i && cd $_current) #Listing the copied files and check in compare function if it's the same or not
	_crule=$(echo "$i" | cut -d "." -f 1)
	echo "$_crule" >> "$_installdir"/rules_ok #This will use later to load only added rule and not * from folder for security reason
	compare "$_ruleslistold" "$_ruleslistnew" "$i" "file"
done


#Script to run, start, stop ... the firewall
_fwlist=$(cd "$_current"../ && ls -1 init)
cp ../init "$_installdir"
_fwlistnew=$(cd $_installdir && ls -1 init && cd $_current) #List the copied "fw" and compare if it's copied or not
compare "$_fwlist" "$_fwlistnew" "init" "file"

##### If we catch en error during copy, we exiting the installation #####

if [ "$_error" = 1 ]; #if the is an error during the copy, we exit the install.
then
	echo -e "$_rcolor""The files are not correctly copied, so the installation can't continue.""$_dcolor"
	exit 1
fi


##### Moving "fw" to $_fwname #####

echo -e "Renaming the firewall control script name..."

if [ $_fwname != "init" ]; #If the file have the same name we don't copy it else, we just check that it was copied.
then

	if [ -e $_installdir/$_fwname ]; #If the file was copied before we delete it, to restore it later
	then
		rm  $_installdir/$_fwname
	fi

	mv $_installdir/init $_installdir/$_fwname #we rename the fw file (init script) to the desired name

	if [ ! -e $_installdir/$_fwname ]; #if the rename $_fwname doesnt exist, we informe the user. The user will be informe if the rename was done.
	then
		echo -e "$_accon""$_rcolor" "NOT RENAMED" "$_dcolor""$_accoff""The init file has not been renamed. Are you root ?"
		exit 1
	else
		echo -e "$_accon""$_gcolor" "RENAMED" "$_dcolor""$_accoff""The init file has been renamed to" "$_fwname"
	fi
else #else if the name was same as default, we don't do anything.
	echo -e "$_accon""$_gcolor" "NOT RENAMED" "$_dcolor""$_accoff""The new name of the init file is the same"
	exit 1
fi

##### Create the port conf file #####

if [ ! -e "$_installdir"/"$_portconf" ]; #if the $_portconf file doesn't exist we create it and initiate it
then
	touch "$_installdir"/"$_portconf"
        	if [ ! -e  "$_installdir"/"$_portconf" ]; #if the config file does not exist, we exit the install beacause its required.
                then
                	echo -e "$_rcolor""The port config file has not been created. Are you root ?""$_dcolor"
                        echo -e "$_rcolor""The installation can't be continue""$_dcolor"
                        exit 1
                fi
fi

##### Create the ip conf file #####

if [ ! -e "$_installdir"/"$_ipconf" ]; #if the $_ipconf file doesn't exist we create it and initiate it
then
        touch "$_installdir"/"$_ipconf"
                if [ ! -e  "$_installdir"/"$_ipconf" ]; #if the config file does not exist, we exit the install beacause its required.
                then
                        echo -e "$_rcolor""The ip config file has not been created. Are you root ?""$_dcolor"
                        echo -e "$_rcolor""The installation can't be continue""$_dcolor"
                        exit 1
                fi
fi

##### Generating the dostart.sh file #####

if [ ! -e "$_installdir"/includes/dostart.sh ];
then
	touch "$_installdir"/includes/dostart.sh
		if [ ! -e  "$_installdir"/includes/dostart.sh ]; #if the dostart.sh file does not exist, we exit the install beacause its required.
                then
                        echo -e "$_rcolor""The do start.sh file has not been created. Are you root ?""$_dcolor"
                        echo -e "$_rcolor""The installation can't be continue""$_dcolor"
                        exit 1
		else
			echo "dostart() {" >> "$_installdir"/includes/dostart.sh
		        echo "" >> "$_installdir"/includes/dostart.sh
		        echo "clean;" >> "$_installdir"/includes/dostart.sh
		        echo "echo" >> "$_installdir"/includes/dostart.sh
		        echo "loopback;" >> "$_installdir"/includes/dostart.sh
		        echo "echo" >> "$_installdir"/includes/dostart.sh
		        echo "established;" >> "$_installdir"/includes/dostart.sh
		        echo "echo" >> "$_installdir"/includes/dostart.sh
		        echo "defaultpolicy" >> "$_installdir"/includes/dostart.sh
		        echo "echo" >> "$_installdir"/includes/dostart.sh
		        echo "" >> "$_installdir"/includes/dostart.sh
		        echo "}" >> "$_installdir"/includes/dostart.sh
			echo "Creating the function to control the rules..."
			echo -e "$_accon""$_gcolor" "CREATED" "$_dcolor""$_accoff""The dostart.sh file exist"
                fi
fi

##### Add custom rules #####

_customruleslist=$(ls -1 "$_current"../customrules)

while true 
do
	echo -e "Custom firewall rules availables : "
	for i in $_customruleslist
 	do
		_rulesavailable=$(echo -e "-" $i |cut -d "." -f 1) #We generate a custom rule file name without ".sh" and we list it
		echo $_rulesavailable
	done

	if [ ! -e "$_installdir"/rules/ssh.sh ];
        then
                echo -e "$_rcolor""The SSH rule seems not copied, you should copy this one or ba assured that you can acces to your server after installation because the default rule will drop all traffic who is NOT in the rules list ""$_dcolor"
	fi

read -e -p "Type de name of the custom rules you need to or 'c' to continue the installation :
Rules : " _customrules #We ask if you want to and some rules or delete it
	if [ "$_customrules" = "c" ]; #If "c" key is pressed then we quit 
	then
		break
	elif [ -e "$_current"../customrules/"$_customrules".sh ]; #If the rules custom rules exists, then
	then
		if [ -e $_installdir/rules/"$_customrules".sh ]; #If the custom rules exist in $_installdir
		then
			echo -e "$_rcolor""The" "$_customrules" "rule already copied !""$_dcolor"
			continue
		elif [ -e "$_current"../customrules/$_customrules.sh ];
		then
			if [ "$_customrules" = "wireguard" ];
			then
				if [ ! -e "$_installdir"/"$_wgconf" ]; #if the $_wgconf file doesn't exist we create it and initiate it
				then
				        touch "$_installdir"/"$_wgconf"
			                if [ ! -e  "$_installdir"/"$_wgconf" ]; #if the config file does not exist, we exit the install beacause its required.
			                then
                        			echo -e "$_rcolor""The ""$_installdir"/"$_wgconf" "file has not been created. Are you root ?""$_dcolor"
			                        echo -e "$_rcolor""This rule can't be installed.""$_dcolor"
			                        continue
			                fi
				fi
			fi
			
			checkipport
			rulecopy

			while true
			do
				if [ "$_port" = "nok" ]; #If the port is not numeric we loop until valid number is entered to avoid unreachable server after installation
        			then
			                echo -e "$_rcolor""The port is required for this rule""$_dcolor"
					checkipport "port"
			                continue #Loop until a port is placed.
			        else
		                break #We continue the install.
		        	fi
			done
			while true
			do
				if [ "$_ip" = "nok" ]; #If the port is not numeric we loop until valid number is entered to avoid unreachable server after installation
                                then
                                        echo -e "$_rcolor""The ip configuration is required for this rule""$_dcolor"
                                        checkipport "ip"
                                        continue #Loop until a port is placed.
                                else
                                break #We continue the install.
                                fi

			done
		else
			echo -e "$_rcolor""The ""$_customrules" "rule doesn't exist !""$_dcolor"
		fi 
	else		
		echo -e "$_rcolor""The ""$_customrules" "rule doesn't exist !""$_dcolor"
		continue
	fi
done


##### Add "_basepath" path in $_installdir/includes/vars.sh #####

_checkbasepath=$(cat "$_installdir""/""$_fwname" |grep -wi "_basepath=")
_sepbase="\""

if [ ! -z "$_checkbasepath" ];
then
	_newvalue="_basepath=""$_sepbase""$_installdir""/""$_sepbase"
	_sedparam="s#${_checkbasepath}#${_newvalue}#"
	sed -i $_sedparam "$_installdir""/""$_fwname" #We will add the create the _basepath var in $_installdir""/""$_fwname" in order to load all need function properly
	_checkbasepathend=$(cat "$_installdir""/""$_fwname" |grep -wi "_basepath=""$_sepbase""$_installdir""$_sepbase")
	if [ ! -z _checkbasepathend ];
	then
		echo -e "$_accon""$_gcolor"" MODIFIED ""$_dcolor""$_accoff""The _basepath var in ""$_installdir""/""$_fwname"" is modified correctly"
	else
		echo -e "$_accon""$_rcolor"" NOT MODIFIED ""$_dcolor""$_accoff""The _basepath var in ""$_installdir""/""$_fwname"" is altered but not modified correctly"
		exit 1
	fi
else
	echo -e "$_accon""$_rcolor"" NOT MODIFIED ""$_dcolor""$_accoff""The _basepath var in ""$_installdir""$_installdir""/""$_fwname"" is not modified correctly"
	exit 1
fi

##### Print a message to informe the user that he can now run the firewall #####

echo -e "$_gcolor""Firewall installed ! You can now run it using : ""$_installdir""/""$_fwname""$_dcolor"
