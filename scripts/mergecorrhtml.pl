#!/usr/bin/perl -w
#
# mergecorrhtml.pl
#
# mergecorrhtml [options] -i inputHTML [inputCorrections]
#            -b bookcode
#            -u include with unspecified bookcode
#            -v verbose reporting
#
# Merges _sorted_ HTML correction lists: one in a HTML file, one bare list. It
# will dump any remaining corrections in the lists after completion. The chief
# reasons that this should happen is if the lists aren't sorted. The correction
# list in the input HTML should be surrounded by the following markers on lines
# by themselves:
#
#  <!--mergecorrhtml:BEGIN-->
#  [list goes here]
#  <!--mergecorrhtml:END-->
#
# Typical usage would be in concert with corrtohtml and sortcorrhtml:
#
#  corrtohtml <correctionFile> | sorcorrhtml | mergecorrhtml -b <book> <html>
#
# Output will appear on standard out which would usually be redirected to file.
#
################################################################################

use strict;

my $programName = 'mergecorrhtml';
my $usage = "$programName [options] inputHTML\n" .
            "\t-b bookcode\n" .
            "\t-u include unspecified book\n" .
            "\t-v verbose reporting\n";

my $htmlRegex;
my $corrRegex;
my $issueRegex;
my $markerRegex;

################################################################################
# Process command line

my $optsProcessed = 0;
my $inFile;
my $bookCode = "";
my $bookCodeReport = "";
my $includeUnspecifiedBook = 0;
my $verbose = 0;

while( $#ARGV > -1 && not $optsProcessed ) {
  my $commandLineItem = shift @ARGV;
  if( $commandLineItem eq "-b" ) {
    $bookCode = shift @ARGV or die $usage;
  }
  elsif( $commandLineItem eq "-u" ) {
    $includeUnspecifiedBook = 1;
  }
  elsif( $commandLineItem eq "-v" ) {
    $verbose = 1;
  }
  elsif( $commandLineItem eq "--help" ) {
    print $usage and exit;
  }
  else {
    unshift @ARGV, $commandLineItem;
    $optsProcessed = 1;
  }
}

if( $verbose ) {
    $bookCodeReport = " [$bookCode]";
}

$inFile = shift @ARGV or die $usage;

$issueRegex = qr{[^#]+?(?:#([[:digit:]]+))};

$htmlRegex = qr{^(<div.*?>)()<a(.*?)href="}; # unused capture to match other regex below
if( $bookCode eq "" ) {
  $corrRegex = $htmlRegex;
}
elsif( $includeUnspecifiedBook ) {
  $corrRegex = qr{^(<div.*?>)(<!--[[:space:]]*${bookCode}[[:space:]]*-->)?<a(.*?)href="};
}
else {
  $corrRegex = qr{^(<div.*?>)(<!--[[:space:]]*${bookCode}[[:space:]]*-->)<a(.*?)href="};
}
$markerRegex = qr{^<div[[:space:]]+?class="section".*$};

################################################################################
# Read in HTML into which we're merging and correction HTML

open( INFILE, "<$inFile" ) or die( "Error ($programName)$bookCodeReport: unable to open \"$inFile\" for read: $!\n" );
my @lines = <INFILE>;
close INFILE;

#### Consume preamble

while( $#lines > -1 && $lines[ 0 ] !~ m{^[[:space:]]*<!--mergecorrhtml:BEGIN-->[[:space:]]*$} ) {
  print shift @lines;
}
print shift @lines if( $#lines > -1 );

my @inHTML;

#### Get good stuff

while( $#lines > -1 && $lines[ 0 ] !~ m{^[[:space:]]*<!--mergecorrhtml:END-->[[:space:]]*$} ) {
  if( $lines[ 0 ] =~ m/$htmlRegex/ ) {
    push( @inHTML, shift @lines );
  }
  elsif( $lines[ 0 ] =~ m/$markerRegex/ ) {
    shift @lines;
  }
  elsif( $lines[ 0 ] =~ m/^[[:space:]]*$/ ) {
    shift @lines;
  }
  else {
    die( "Error ($programName)$bookCodeReport: unrecognized input HTML: " . $lines[ 0 ] . "\n" );
  }
}

my @inCorr;
while( my $corr = <> ) {
  push( @inCorr, $corr ) if( $corr =~ m{$corrRegex} );
}

################################################################################
# Merge!

my @sectSortOrder = &getSectSortOrder( );

foreach my $section (@sectSortOrder) {
  my $issue;
  print "<div class=\"section\"><a name=\"$section\">$section</a></div>\n";
  while( $#inHTML > -1 && $inHTML[ 0 ] =~ m/$htmlRegex$section\.htm${issueRegex}/ ) {
    $issue = $4;
    while( $#inCorr > -1 && $inCorr[ 0 ] =~ m/$corrRegex$section\.htm${issueRegex}/ && $issue eq $4 ) {
      my $corr = shift @inCorr;
      my $comm = "";
      if( $corr !~ m{^.+?:[[:space:]]*<div[^>]+?class="[^"]*cm} ) { warn( "Warning ($programName)$bookCodeReport: discarding data in issue comment: $corr" ); }
      while( $corr =~ s{^.*?(<div[^>]+?class="[^"]*cm[^>]+>.*?</div>)}{} ) {
        $comm .= $1;
      }
      $inHTML[ 0 ] =~ s{</div>$}{$comm</div>}
    }
    print shift @inHTML;
  }
  while( $#inCorr > -1 && $inCorr[ 0 ] =~ m/$corrRegex$section\.htm/ ) {
    my $corr = shift @inCorr;
    $corr =~ s{$corrRegex}{$1<a$3href="};
    ++$issue;
    $corr =~ s{#:}{#$issue:};
    print $corr;
  }
}

################################################################################
# Print the remainder of the input HTML and corrections

if( $#inHTML > -1 ) {
  warn( "Warning ($programName)$bookCodeReport: input HTML probably out of order\n\tor unrecognized section--error near:\n\t" . $inHTML[ 0 ] . "\n" );
  print @inHTML;
}
if( $#inCorr > -1 ) {
  warn( "Warning ($programName)$bookCodeReport: input corrections probably out of order\n\tor unrecognized section--error near:\n\t" . $inCorr[ 0 ] . "\n" );
  print @inCorr;
}

print @lines;


################################################################################
################################################################################
# Subroutines

sub getSectSortOrder {
  return qw{
    _unknown
    toc
    title
    dedicate
    acknwldg
    coming
    tssf
    gamerulz
    discplnz
    powers
    equipmnt
    cmbtrulz
    lorecrcl
    levels
    imprvdsc
    kaiwisdm
    sage
    numbered
    part1
    sect1
    sect2
    sect3
    sect4
    sect5
    sect6
    sect7
    sect8
    sect9
    sect10
    sect11
    sect12
    sect13
    sect14
    sect15
    sect16
    sect17
    sect18
    sect19
    sect20
    sect21
    sect22
    sect23
    sect24
    sect25
    sect26
    sect27
    sect28
    sect29
    sect30
    sect31
    sect32
    sect33
    sect34
    sect35
    sect36
    sect37
    sect38
    sect39
    sect40
    sect41
    sect42
    sect43
    sect44
    sect45
    sect46
    sect47
    sect48
    sect49
    sect50
    sect51
    sect52
    sect53
    sect54
    sect55
    sect56
    sect57
    sect58
    sect59
    sect60
    sect61
    sect62
    sect63
    sect64
    sect65
    sect66
    sect67
    sect68
    sect69
    sect70
    sect71
    sect72
    sect73
    sect74
    sect75
    sect76
    sect77
    sect78
    sect79
    sect80
    sect81
    sect82
    sect83
    sect84
    sect85
    sect86
    sect87
    sect88
    sect89
    sect90
    sect91
    sect92
    sect93
    sect94
    sect95
    sect96
    sect97
    sect98
    sect99
    sect100
    sect101
    sect102
    sect103
    sect104
    sect105
    sect106
    sect107
    sect108
    sect109
    sect110
    sect111
    sect112
    sect113
    sect114
    sect115
    sect116
    sect117
    sect118
    sect119
    sect120
    sect121
    sect122
    sect123
    sect124
    sect125
    sect126
    sect127
    sect128
    sect129
    sect130
    sect131
    sect132
    sect133
    sect134
    sect135
    sect136
    sect137
    sect138
    sect139
    sect140
    sect141
    sect142
    sect143
    sect144
    sect145
    sect146
    sect147
    sect148
    sect149
    sect150
    sect151
    sect152
    sect153
    sect154
    sect155
    sect156
    sect157
    sect158
    sect159
    sect160
    sect161
    sect162
    sect163
    sect164
    sect165
    sect166
    sect167
    sect168
    sect169
    sect170
    sect171
    sect172
    sect173
    sect174
    sect175
    sect176
    sect177
    sect178
    sect179
    sect180
    sect181
    sect182
    sect183
    sect184
    sect185
    sect186
    sect187
    sect188
    sect189
    sect190
    sect191
    sect192
    sect193
    sect194
    sect195
    sect196
    sect197
    sect198
    sect199
    part2
    sect200
    sect201
    sect202
    sect203
    sect204
    sect205
    sect206
    sect207
    sect208
    sect209
    sect210
    sect211
    sect212
    sect213
    sect214
    sect215
    sect216
    sect217
    sect218
    sect219
    sect220
    sect221
    sect222
    sect223
    sect224
    sect225
    sect226
    sect227
    sect228
    sect229
    sect230
    sect231
    sect232
    sect233
    sect234
    sect235
    sect236
    sect237
    sect238
    sect239
    sect240
    sect241
    sect242
    sect243
    sect244
    sect245
    sect246
    sect247
    sect248
    sect249
    sect250
    sect251
    sect252
    sect253
    sect254
    sect255
    sect256
    sect257
    sect258
    sect259
    sect260
    sect261
    sect262
    sect263
    sect264
    sect265
    sect266
    sect267
    sect268
    sect269
    sect270
    sect271
    sect272
    sect273
    sect274
    sect275
    sect276
    sect277
    sect278
    sect279
    sect280
    sect281
    sect282
    sect283
    sect284
    sect285
    sect286
    sect287
    sect288
    sect289
    sect290
    sect291
    sect292
    sect293
    sect294
    sect295
    sect296
    sect297
    sect298
    sect299
    sect300
    sect301
    sect302
    sect303
    sect304
    sect305
    sect306
    sect307
    sect308
    sect309
    sect310
    sect311
    sect312
    sect313
    sect314
    sect315
    sect316
    sect317
    sect318
    sect319
    sect320
    sect321
    sect322
    sect323
    sect324
    sect325
    sect326
    sect327
    sect328
    sect329
    sect330
    sect331
    sect332
    sect333
    sect334
    sect335
    sect336
    sect337
    sect338
    sect339
    sect340
    sect341
    sect342
    sect343
    sect344
    sect345
    sect346
    sect347
    sect348
    sect349
    sect350
    sect351
    sect352
    sect353
    sect354
    sect355
    sect356
    sect357
    sect358
    sect359
    sect360
    sect361
    sect362
    sect363
    sect364
    sect365
    sect366
    sect367
    sect368
    sect369
    sect370
    sect371
    sect372
    sect373
    sect374
    sect375
    sect376
    sect377
    sect378
    sect379
    sect380
    sect381
    sect382
    sect383
    sect384
    sect385
    sect386
    sect387
    sect388
    sect389
    sect390
    sect391
    sect392
    sect393
    sect394
    sect395
    sect396
    sect397
    sect398
    sect399
    sect400
    ill1
    ill2
    ill3
    ill4
    ill5
    ill6
    ill7
    ill8
    ill9
    ill10
    ill11
    ill12
    ill13
    ill14
    ill15
    ill16
    ill17
    ill18
    ill19
    ill20
    passing
    map
    action
    crsumary
    crtable
    random
    errata
    footnotz
    illstrat
    license
  };
}
