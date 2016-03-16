#!/bin/bash
# USAGE: build.sh # defaults to 'tow' 'build'
#    OR: build.sh 'toh' # runs default 'build' Ant target in the 'toh' direction
#    OR: build.sh 'tow' 'clean' # runs 'clean' Ant target in the 'tow' direction
#    OR: build.sh $direction $target

DEBUG=1 ;
thisScript=$0 ;
thisDir=$(dirname $thisScript) ;
if [[ -z $thisDir || "$thisDir" == "." ]] ; then
  pwdX=$(pwd) ;
  thisDir="$pwdX" ;
fi ;
scriptBase=$(basename $thisScript) ;
scriptBaseNoExt=$(echo $scriptBase | perl -ne 's/[.][^.]+$// && print $_') ;

#

direction='tow' ;
if [[ $1 ]] ; then
  direction=$1 ;
fi ;

tgt='build' ;
if [[ $2 ]] ; then
  tgt=$2 ;
fi ;

cp $thisDir/obxml/OBXml.cfg.$direction $thisDir/obxml/OBXml.cfg ;
cp -rp $thisDir/obxml/strtr/strtr_cfg.$direction $thisDir/obxml/strtr/strtr_cfg ;

echo "ant -f $thisDir/build.xml $tgt" ;
ant -f $thisDir/build.xml $tgt ;

#
