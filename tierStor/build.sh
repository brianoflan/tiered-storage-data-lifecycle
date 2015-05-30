#!/bin/bash

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

which awk 1>&2 ;
d="/cygdrive/c/Users/bflannery/Documents/save/save2/subsave1_cyg/cyg/bin" ;
if [[ -d "$d" ]] ; then
  # export PATH="/usr/bin:$PATH" ;
  export PATH="$d:$PATH" ;
  echo "PATH q($PATH)." 1>&2 ;
fi ;

# C:\Users\bflannery\Documents\save\_save6a\strawperl
# C:/Users/bflannery/Documents/save/_save6a/strawperl
# d="/cygdrive/c/Users/bflannery/Documents/save/_save6a/strawperl" ;
d="/cygdrive/c/Users/bflannery/Documents/save/_save6a/strawpl5p10" ;
if [[ -d "$d" ]] ; then
  export PATH="$d/perl/site/bin:$d/perl/bin:$PATH" ;
fi ;
x=`pwd` ;
echo "pwd $x" 1>&2 ;
perl "$thisDir/$scriptBaseNoExt.pl" "$@" ;
exit $? ;



# # # 
# Old:
# # # 



storageConstant=2 ; # MB
storageAmplifier=1.1 ; # MB, exponentially compounded
storCorePrefix=storCore ;

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

n=1 ;
d="$thisDir/../$storCorePrefix$n" ;
limitInit=$((limitInit + storageConstant )) ;
while [[ -d "$d" ]] ; do
  kb=$(du -ks "$d" | awk '{print $1}') ;
  limit=$((n * n * storageAmplifier )) ;
  limitX=$((limit + limitInit )) ;
  if [[ $DEBUG -gt 0 ]] ; then
    echo "n $n limit $limitX" ;
  fi ;
  
  # TODO
  
  n=$((n+1)) ;
  d="$thisDir/$storCorePrefix$n" ;
done ;


#
