#!/bin/bash

export tier_res=../.. ;


DEBUG=1 ;
thisScript=$0 ;
thisDir=$(dirname $thisScript) ;
if [[ -z $thisDir || "$thisDir" == "." ]] ; then
  pwdX=$(pwd) ;
  if [[ $DEBUG -gt 0 ]] ; then
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


tier_func="$thisDir/$tier_res/build_functions.sh" ;
if [[ ! -e "$tier_func" ]] ; then
  echo "ERROR: Failed to find file $tier_func." ;
  exit 1 ;
fi ;
source "$tier_func" ;



resetTiers ;
rm -rf "$thisDir"/.old ;

#
