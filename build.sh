#!/bin/bash

if [[ -z $ANT_HOME ]] ; then
  # C:\Users\bflannery\Documents\_lib\apache-ant-1.9.4
  export ANT_HOME="/cygdrive/c/Users/bflannery/Documents/_lib/apache-ant-1.9.4" ;
fi ;
x=`echo "$PATH" | egrep 'ant'` ;
if [[ -z $x ]] ; then
  export PATH="$ANT_HOME/bin:$PATH" ;
fi ;

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

which ant 1>&2 ;
where ant 1>&2 ;
ant -version 1>&2 ;
# # None of these work.
# # They all give an error like this:
# #   Buildfile: \cygdrive\c\Users\abc\Documents\path1\build.xml does not exist!
# # 
  # ant -f "$thisDir/build.xml" "$@" ;
  # /bin/bash ant -f "$thisDir/build.xml" "$@" ;
  # $ANT_HOME/bin/ant -f "$thisDir/build.xml" "$@" ;
#
buildfileX="$thisDir/build.xml" ;
buildfileWin=`cygpath -w "$buildfileX" ` ;
ant -f "$buildfileWin" "$@" ;

exit $error ;

#
