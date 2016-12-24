#!/bin/bash

_rcolor="\\033[1;31m" #Red color
_gcolor="\\033[1;32m" #Greencolor
_dcolor="\\033[0;39m" #Default color
_accon="["
_accoff="] - "

_functionpath="$_basepath""includes/" # Where is the include folder (functions for firewall)
_rulespath="$_basepath""rules/"

_ipconf="$_basepath""ipconf"
_portconf="$_basepath""portconf"

_rulesapplied="$_dcolor""$_accon""$_gcolor"" APPLIED ""$_dcolor""$_accoff"
_rulesnotapplied="$_dcolor""$_accon""$_rcolor"" NOT APPLIED ""$_dcolor""$_accoff"

_nopip="$_rulesnotapplied""There is no ip found for this rule""$_dcolor"
_noport="$_rulesnotapplied""There is no port found for this rule""$_dcolor"
