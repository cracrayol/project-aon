#!/usr/bin/perl -w
#
# Sort Correction HTML
#
# Sorts input correction HTML. Can also filter out corrections for undesired
# books.
#
# Assumes that corrections appear one per line. Good practice would be to pipe
# the output of corrtohtml.pl to this function:
#
#   corrtohtml.pl corrections | sortcorrhtml.pl
#
################################################################################

use strict;

my $progName = "sortcorrhtml";
my $usage = "$progName [options]\n" .
            "\t-b bookcode   exclude corrections specified for other books\n" .
            "\t-s            strip book tags\n" .
            "\t-v            verbose reporting\n";

my $optsProcessed = 0;
my $bookCode = "";
my $bookCodeReport = "";
my $stripBookInfo = 0;
my $includeUnspecifiedBook = 0;
my $verbose = 0;

while( $#ARGV > -1 && not $optsProcessed ) {
  my $commandLineItem = shift @ARGV;
  if( $commandLineItem eq "-b" ) {
    $bookCode = shift @ARGV or die $usage;
  }
  elsif( $commandLineItem eq "-s" ) {
    $stripBookInfo = 1;
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

my @bookSortOrder = &getBookSortOrder( );
my @sectSortOrder = &getSectSortOrder( );

my %buckets = ( );

my $corrRegex = qr{^.+?(<!--[[:space:]]*([^-]+?)[[:space:]]*-->)?<a href="([^.]+)[^#]+#([[:digit:]]*)};

my $bookRegex;
if( $bookCode ne "" ) {
  $bookRegex = qr{^.+?(<!--[[:space:]]*($bookCode)[[:space:]]*-->)<a href="([^.]+).htm};
}

my $stripRegex;
if( $bookCode ne "" ) {
  $stripRegex = qr{<!--[[:space:]]*$bookCode[[:space:]]*-->}; 
}
else {
  $stripRegex = qr{<!--[[:space:]]*[^-]+?[[:space:]]*-->};
}

my @lines = <>;
my $maxIssue = 0;

foreach my $line (@lines) {
  if( $bookCode ne "" ) {
    ($line =~ m{$bookRegex}) or next; # skip other books
  }

  ($line =~ m{$corrRegex}) or die( "Error ($progName)$bookCodeReport: unrecognized correction: $line\n" );
  my( $book, $sect, $issue ) = ($2, $3, $4);
  $book = "unknown" unless defined $book;
  $issue = "unassigned" unless defined $issue && $issue ne "";
  $buckets{$book} = { } unless exists $buckets{$book};
  $buckets{$book}->{$sect} = { } unless exists $buckets{$book}->{$sect};
  $buckets{$book}->{$sect}->{$issue} = [ ] unless exists $buckets{$book}->{$sect}->{$issue};

  if( $stripBookInfo ) {
    $line =~ s/$stripRegex//;
  }

  if( $issue ne "unassigned" && $issue > $maxIssue ) { $maxIssue = $issue; }

  push @{$buckets{$book}->{$sect}->{$issue}}, $line;
}

foreach my $bookKey (keys %buckets) {
  my $found = 0;
  foreach my $book (@bookSortOrder) {
    if( $bookKey eq $book ) { $found = 1; }
  }
  unless( $found ) { die( "Error ($progName)$bookCodeReport: unknown book code: $bookKey\n" ); }

  foreach my $sectKey (keys %{$buckets{$bookKey}}) {
    $found = 0;
    foreach my $sect (@sectSortOrder) {
      if( $sectKey eq $sect ) { $found = 1; }
    }
    unless( $found ) { die( "Error ($progName)$bookCodeReport: unknown section: $sectKey\n" ); }
  }
}

for( my $i = 0; $i <= $#bookSortOrder; ++$i ) {
  for( my $j = 0; $j <= $#sectSortOrder; ++$j ) {
    for( my $k = 0; $k <= $maxIssue; ++$k ) {
      print @{$buckets{$bookSortOrder[$i]}->{$sectSortOrder[$j]}->{$k}} if exists $buckets{$bookSortOrder[$i]} && exists $buckets{$bookSortOrder[$i]}->{$sectSortOrder[$j]} && exists $buckets{$bookSortOrder[$i]}->{$sectSortOrder[$j]}->{$k};
    }
    while( $#{$buckets{$bookSortOrder[$i]}->{$sectSortOrder[$j]}->{'unassigned'}} > -1 ) {
      print shift @{$buckets{$bookSortOrder[$i]}->{$sectSortOrder[$j]}->{'unassigned'}};
    }
  }
}

################################################################################

sub getBookSortOrder {
  return qw{
    unknown
    01fftd
    02fotw
    03tcok
    04tcod
    05sots
    06tkot
    07cd
    08tjoh
    09tcof
    10tdot
    11tpot
    12tmod
    13tplor
    14tcok
    15tdc
    16tlov
    17tdoi
    18dotd
    19wb
    20tcon
    21votm
    22tbos
    23mh
    24rw
    25totw
    26tfobm
    27v
    28thos
    01gstw
    02tfc
    03btng
    04wotw
    01hh
    02smr
    03toz
    04cc
    tmc
    rh
  };
}

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
