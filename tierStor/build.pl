#!/usr/bin/perl
# # USAGE: perl build.pl    # Uses default $storageConstant
# #   OR:  perl build.pl 37 # Uses $storageConstant=37 (MB)

use File::Basename;

my $unit = 'MB' ;
my $kbUnit = 'KB' ; # kibibyte, the binary kilobyte
my $mode = 'check' ; # Or 'ageOff'
my $storageConstant=1.1 ; # MB (see $unit)
my $storageAmplifier=5 ; # This product of this amplifier and the storage constant and the previous limit is exponentially compounded to produce the next limit.
my $storageSquash=0.999 ; # Squashing factor.
# my $storageSquashLimit=(1 * 1024) ; # GB, after which it slows down.
my $storageSquashLimit=($storageConstant * 1024) ; # GB, after which it slows down.
my $storTierPrefix=storTier ;
my $limits = {
  '1' => 1,
  '2' => 20,
  '3' => 300,
  '4' => 3000,
  '5' => 10000,
  '6' => 25000,
  '7' => 100000,
  '8' => 250000,
  '9' => 1000000,
} ;

if ( @ARGV ) {
  $storageConstant = shift( @ARGV ) ;
  if ( $DEBUG > 0 ) {
    print STDERR "Replaced \$storageConstant with $storageConstant.\n" ;
  }
}
if ( @ARGV ) {
  $mode = shift( @ARGV ) ;
  if ( $DEBUG > 0 ) {
    print STDERR "Replaced \$mode with $mode.\n" ;
  }
}

my $DEBUG=1 ;
my $thisScript=$0 ;
# my $thisDir=$(dirname $thisScript) ;
my $thisDir=dirname( $thisScript );
# if [[ -z $thisDir || "$thisDir" == "." ]] ; then
if ( not( defined( $thisDir ) ) or ( $thisDir eq '' ) or ( $thisDir eq '.' ) ) {
  my $pwdX=qx(pwd) ;
  chomp( $pwdX ) ;
  # if [[ $DEBUG -gt 0 ]] ; then
  if ( $DEBUG > 1 ) {
    print STDERR "Updating thisDir from '$thisDir' to '$pwdX'.\n" ;
  }
  $thisDir="$pwdX" ;
}
my $scriptBase = basename($thisScript) ;
my $scriptBaseNoExt = $scriptBase ;
$scriptBaseNoExt =~ s/[.][^.]+$// ;

sub numComma { # Returns a string of a number with thousands separated by commas
  my $result ;
  my $num = shift( @_ ) ;
  # $result = $num ;
  # $result =~ /\./
    # ? s/(?<=\d)(?=(\d{3})+(?:\.))/,/g
    # : s/(?<=\d)(?=(\d{3})+(?!\d))/,/g
    # ;
  # #
  my( $int, $dec ) = split( /\./, $num, 2 ) ;
  $dec ||= '' ;
  $int =~ s/(\d)(?=(\d{3})+(\D|$))/$1\,/g;
  $result = length( $dec ) ? "$int.$dec" : $int ;
  return( $result ) ;
}

sub main {
  my $maxN = 0 ;
  my %badTiers = () ;
  my @errors = () ;
  my $n=1 ;
  my $d="$thisDir/../$storTierPrefix$n" ;
  # my $limitInit=$((limitInit + storageConstant )) ;
  # my $limitInit=$limitInit + $storageConstant ;
  my $limitPrior = 0 ;
  if ( -d "$d" ) {
    if ( $DEBUG > 2 ) {
      print STDERR "Found folder '$d'.\n" ;
    }
  } else {
    if ( $DEBUG > 1 ) {
      print STDERR "No folder '$d'.\n" ;
    }
  }
  # while [[ -d "$d" ]] ; do
  while ( -d "$d" ) {
    $maxN = $n ;
    # my $kb=qx(du -ks "$d" |  awk '{print \$1}') ; # TODO: Replace awk with something more Perl-y.
      my $kb=qx(du -ks "$d" | gawk '{print \$1}') ; # TODO: Replace awk with something more Perl-y.
    #
    chomp( $kb ) ;
    # print STDERR "n $n, kb $kb.\n" ;
    my $m = $n - 1 ;
    # my $limit= ( $n * $n * $n * $n ) * $storageAmplifier ;
    # my $limit= ( $m * $m * $storageAmplifier ) ;
    my $limit= $storageConstant ;
    $limit *=  ( $m * $m * $storageAmplifier ) ;
    $limit *=  ( $m * $m * $storageAmplifier ) ;
    if ( $DEBUG > 2 ) {
      print STDERR "  limit pre-calc '$limit'\n" ;
    }
    # my $limitX=$limit + $limitInit ;
    my $limitX=$limit + $storageConstant + $limitPrior;
    if ( $limitX > $storageSquashLimit ) {
      my $use_prelimit = '' ;
      my $prelimit = 0 ;
      if ( $limit > $storageSquashLimit ) {
        $prelimit += $limit - $storageSquashLimit ;
      }
      if ( $limitPrior > $storageSquashLimit ) {
        $prelimit += $limitPrior - $storageSquashLimit ;
      }
      # $limit =  ( $n * $n * $storageAmplifier * $storageSquash) ;
      # $limit =  ( $m * $m * $m * $storageAmplifier * $storageSquash) ;
      $limit =  $storageConstant ;
      $limit *=  ( $m * $m * $storageAmplifier * $storageSquash) ;
      $limit *= ( $m * $m * $storageAmplifier * $storageSquash) ;
      if ( $DEBUG > 2 ) {
        print STDERR "  limit pre-calc '$limit'\n" ;
      }
      # $limit += ( $limitX - $storageSquashLimit );
      if ( $use_prelimit ) {
        $limit += $prelimit ;
      }
      if ( $DEBUG > 2 ) {
        print STDERR "    limit pre-calc '$limit'\n" ;
      }
      
      if ( $DEBUG > 2 ) {
        print STDERR "Squashing from   limit     '$limitX'\n" ;
      }
      $limitX=$limit + $storageConstant + $limitPrior;
      if ( $DEBUG > 2 ) {
        print STDERR "                        to '$limitX'.\n" ;
      }
      
    }
    
    if ( $limits->{ $n } ) {
      my $DEBUGMAX = 1 ;
      if ( $DEBUG > $DEBUGMAX ) {
        print STDERR "Replacing limit $limitX (from calculation) " ;
      }
      $limitX = $limits->{ $n } * $storageConstant ;
      if ( $DEBUG > $DEBUGMAX ) {
        print STDERR "with limit $limitX (from lookup table).\n" ;
      }
    }
    
    $limitPrior = $limitX ;
    my $limitXKb=($limitX * 1024) ;
    # if [[ $DEBUG -gt 0 ]] ; then
    if ( $DEBUG > 1 ) {
      # print STDERR "n $n                   limit $limitX\n" ;
      {
        # my $pretty = $limitX ;
        # # $pretty =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
        # $pretty =~ s/(\d)(?=(\d{3})+(\D|$))/$1\,/g;
        my $pretty = numComma( $limitX ) ;
        print STDERR "n $n                        '$pretty'.\n" ;
      }
      if ( $DEBUG > 0 ) {
        print STDERR "\n" ;
      }
      
    }
    
    # TODO
    if ( $limitXKb < $kb ) {
      my $msg = "\nStorage tier $n is\n   $d\n  and is $kb $kbUnit, over the $limitXKb $kbUnit limit.\n" ;
      # print STDERR "$msg\n" ;
      # $error = $error ? "$error  $msg" : $msg ;
      push( @errors, $msg ) ;
      $badTiers{$n} = 1 ;
      # if ( $mode eq 'ageOff' ) {
        
      # }
    } else {
      if ( $DEBUG > 1 ) {
        print STDERR "Size of n ($n) is $kb $kbUnit: Less than limit of $limitXKb $kbUnit.\n" ;
      }
    }
    
    $n+=1 ;
    $d="$thisDir/../$storTierPrefix$n" ;
    if ( -d "$d" ) {
      if ( $DEBUG > 2 ) {
        print STDERR "Found folder '$d'.\n" ;
      }
    } else {
      if ( $DEBUG > 1 ) {
        print STDERR "No folder '$d'.\n" ;
      }
    }
  }
  if ( @errors ) {
    my $msg = join( '  ', @errors ) ;
    # print STDERR "ERROR: $msg.\n" ;
    # exit 1 ;
    print STDOUT join( ',', sort { $b cmp $a } ( keys( %badTiers ) ) ) ;
    print STDOUT "\n" ;
    die( "ERROR:  $msg\n." ) ;
  }
}

main() ;
print STDERR "SUCCESS.\n" ;
exit( 0 ) ;

#
