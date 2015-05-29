#!/bin/bash

storTierPrefix=storTier ;

DEBUG=2 ;
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

fo=find_ls_previous_structure.txt ;
fof="$thisDir/$fo" ;
if [[ -f "$fof" ]] ; then
  rm -rf "$fof" ;
fi ;
find "$thisDir" -path .git -prune -o -exec ls -ld {} \; > /tmp/$fo ;
mv /tmp/$fo "$thisDir/" ;

# echo "find $thisDir/.old" ;
# find $thisDir/.old ;
if [[ -d "$thisDir/.old" ]] ; then
  rm -rf "$thisDir/.old"/* 2>/dev/null ;
fi ;
mkdir "$thisDir/.old" 2>/dev/null ;
# echo ;
# echo "find $thisDir/.old" ;
# find $thisDir/.old ;
# echo ;

x=`ls -d "$thisDir"/$storTierPrefix* ` ;
if [[ $x ]] ; then
  if [[ $storTierPrefix ]] ; then
    mv "$thisDir"/$storTierPrefix* "$thisDir/.old/" ;
  fi ;
fi ;

for n in 1 2 3 4 5 6 7 8 9 ; do
  mkdir "$thisDir/$storTierPrefix$n" ;
done ;
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

cd "$thisDir" ;
find ./$storTierPrefix* > ./find_storTier.txt ;

#
