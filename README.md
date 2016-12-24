# iptables

Here it is my iptables installation script :

Firt off all don't forget that I'm not a dev guy so if this script look's awfull for you please leave it alone ;)

To run you just have to put you self on the directory where you download it then :

* Go in install dir and run install.sh script
* Follow the instruction and the firewall will be installed in easy way :=)

If you want to add more rules you can use some template I putted in template dir.
If you put then you rules in customrules diretory, you will be able to install it then ;)

For custom rules you will be need to know that :

$_ip=1 means that you expect that the user will add an ip/hostname for this rule.
$_port=1  means that you expect that the user will add an port for this rule.

The IP can have those format for exemple :

1.2.3.4
1.2.3.4/32
name.domaine.tld

Enjoy :)
