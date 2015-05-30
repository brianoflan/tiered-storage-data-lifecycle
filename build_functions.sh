#!/bin/bash
# Run 'source' on this file to gain its constants and functions.

if [[ -z $ANT_HOME ]] ; then
  # C:\Users\bflannery\Documents\_lib\apache-ant-1.9.4
  export ANT_HOME="/cygdrive/c/Users/bflannery/Documents/_lib/apache-ant-1.9.4" ;
  if [[ ! -d "$ANT_HOME" ]] ; then
    export ANT_HOME="" ;
    unset ANT_HOME ;
  fi ;
fi ;
if [[ -z $DEBUG ]] ; then
  DEBUG=1 ;
fi ;
isCygwin=`cygpath . 2>/dev/null` ;
# PATH
  x=`echo "$PATH" | egrep -i 'ant'` ;
  if [[ -z $x ]] ; then
    if [[ $ANT_HOME ]] ; then
      export PATH="$ANT_HOME/bin:$PATH" ;
    fi ;
  fi ;
# PATH
if [[ -z $storTierPrefix ]] ; then
  storTierPrefix=storTier ;
fi ;



build() {
  if [[ $DEBUG -gt 0 ]] ; then
    echo "which ant" 1>&2 ;
    which ant 1>&2 ;
    
    if [[ $isCygwin ]] ; then
      echo "where ant" 1>&2 ;
      where ant 1>&2 ;
    fi ;
    
    ant -version 1>&2 ;
  fi ;
  
  
  # # None of these work.
  # # They all give an error like this:
  # #   Buildfile: \cygdrive\c\Users\abc\Documents\path1\build.xml does not exist!
  # # 
    # ant -f "$thisDir/build.xml" "$@" ;
    # /bin/bash ant -f "$thisDir/build.xml" "$@" ;
    # $ANT_HOME/bin/ant -f "$thisDir/build.xml" "$@" ;
  #
  # buildfileX="$thisDir/build.xml" ;
  buildfileX="$thisDir/$tier_res/build.xml" ;
  buildfileWin=$buildfileX ;
  if [[ $isCygwin ]] ; then
    buildfileWin=`cygpath -w "$buildfileX" ` ;
  fi ;
  x=`pwd` ;
  echo "pwd $x" ;
  ant -f "$buildfileWin" "$@" ;
}

mk_find_file() { # $findArgs $outputFile
  findArgs="$1" ;
  fo="$2" ;
  fof="$thisDir/$fo" ;
  if [[ -f "$fof" ]] ; then
    rm -rf "$fof" ;
  fi ;
  # eval "find \"$thisDir\" -path .git -prune -o $findArgs" > /tmp/$fo ;
  cd "$thisDir" || echo "ERROR: Failed to 'cd $thisDir'." ;
  eval "find . $findArgs" | egrep -v '\/\.(git|old)' | env -i sort > /tmp/$fo ;
  mv /tmp/$fo "$thisDir/" ;
}

resetTiers() {
  if [[ -d "$thisDir/.old" ]] ; then
    rm -rf "$thisDir/.old"/* 2>/dev/null ;
  fi ;
  mkdir "$thisDir/.old" 2>/dev/null ;
  
  x=`ls -d "$thisDir"/$storTierPrefix* ` ;
  if [[ $x ]] ; then
    if [[ $storTierPrefix ]] ; then
      mv "$thisDir"/$storTierPrefix* "$thisDir/.old/" ;
    fi ;
  fi ;
  
  for n in 1 2 3 4 5 6 7 8 9 ; do
    mkdir "$thisDir/$storTierPrefix$n" ;
  done ;
}



#
