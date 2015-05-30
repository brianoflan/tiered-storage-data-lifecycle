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

mkdir -p "$thisDir"/${storTierPrefix}1/abc ;
mkdir -p "$thisDir"/${storTierPrefix}2/def/abc ;
mkdir -p "$thisDir"/${storTierPrefix}3/def ;
dd if=/dev/zero of="$thisDir"/${storTierPrefix}1/abc/file1.txt bs=1024 count=1127
dd if=/dev/zero of="$thisDir"/${storTierPrefix}2/def/abc/file2.txt bs=1024 count=1127
dd if=/dev/zero of="$thisDir"/${storTierPrefix}3/def/file3.txt bs=1024 count=11027

touch "$thisDir"/${storTierPrefix}1/abc/abc.txt ;
touch "$thisDir"/${storTierPrefix}2/def/abc/def.abc.txt ;
touch "$thisDir"/${storTierPrefix}2/def/def.txt ;

touch -d '2010-04-03' "$thisDir"/${storTierPrefix}1/abc/abc.old.txt ;
touch -d '2010-04-03' "$thisDir"/${storTierPrefix}2/def/abc/def.abc.old.txt ;
touch -d '2010-04-03' "$thisDir"/${storTierPrefix}2/def/def.old.txt ;



fo="find_orig.txt" ;
rm -rf "$fo" 2>/dev/null ;
mk_find_file "-print" "$fo" ;

build ageoff ;

fo="find_age_once.txt" ;
rm -rf "$fo" 2>/dev/null ;
mk_find_file "-print" "$fo" ;

build ageoff ;

fo="find_age_twice.txt" ;
rm -rf "$fo" 2>/dev/null ;
mk_find_file "-print" "$fo" ;

error='' ;
for x in orig age_once age_twice ; do
  diff=`diff find_$x.txt find_$x.gold.txt ` ;
  if [[ $diff ]] ; then
    echo "ERROR:  Found difference between result (find_$x.txt)" ;
    echo "        and how it should be (find_$x.gold.txt)." ;
    if [[ $error ]] ; then
      error="$error, $x"
    else
      error="$x"
    fi ;
  fi ;
done ;

if [[ $error ]] ; then
  echo "RESULT: FAILED." ;
  echo "        (Found error in these pieces of the test: $error.)"
  exit 1 ;
fi ;
  echo "RESULT: SUCCESS." ;
exit 0 ;

#
