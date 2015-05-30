#!/bin/bash

if [[ -z $tier_res ]] ; then
  export tier_res=. ;
fi ;

# DEBUG=2 ;
thisScript=$0 ;
thisDir=$(dirname $thisScript) ;
if [[ -z $thisDir || "$thisDir" == "." ]] ; then
  pwdX=$(pwd) ;
  if [[ $DEBUG -gt 1 ]] ; then
    echo "Updating thisDir from '$thisDir' to '$pwdX'." ;
  fi ;
  thisDir="$pwdX" ;
fi ;
scriptBase=$(basename $thisScript) ;
scriptBaseNoExt=$(echo $scriptBase | perl -ne 's/[.][^.]+$// && print $_') ;
if [[ $DEBUG -gt 1 ]] ; then
  for x in DEBUG thisScript thisDir scriptBase scriptBaseNoExt ; do
    eval "echo \"$x '\$$x'\"" ;
  done 1>&2 ;
fi ;



# mk_find_file "-exec ls -ld {} \\;" "find_ls_ld_previous_structure.txt" ;
# mk_find_file "-print" "find_previous_structure.txt" ;

resetTiers ;

# cd "$thisDir" ;
# find ./$storTierPrefix* > ./find_storTier.txt ;

#
