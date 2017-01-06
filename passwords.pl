#!/usr/bin/perl
#
# Toby's Password Generator
# Script that outputs passwords in a variety of styles:
# * 16, 32, 64 character long alpha numerics
# * 16 character long alpha numerics and "easy" symbols
# * 16 character long alpha numerics and "hard" symbols
# * 32 character long hex
# * words + numbers + symbols
# * 20 bare words (for all your battery horse staple needs)
#

use strict;
use warnings;

use Getopt::Long;
use Data::Dumper;
use List::Util qw(shuffle);

# Word source should be pre-stripped of words from popular password word lists
# You probably want to filter it further to be words of at least 3 characters
# and no more than 8 characters (so they are easy to type/more memorable)
my $WORD_SOURCE = '/Users/tobyox/Projects/PasswordLists/master.txt';

my $GRID_WIDTH = 72;

# character arrays
# note we skip some characters (1lI, 0O) that can be easy to mis-read
my @ALPHA_L  = ('a'..'k', 'm'..'z');
my @ALPHA_U  = ('A'..'H', 'J'..'N', 'P'..'Z');
my @NUMBERS  = ('2'..'9');
my @SYMBOLS0 = split('', '-=;,.*@&%!');    # symbols that are easier to find on a generic English keyboard
my @SYMBOLS1 = split('', '`-=[];\',.\/\\` ');    # can be typed without using a modifier key (at least, with my keyboard layout)
my @SYMBOLS2 = split('', '~!@#$%^&*()_+{}|:"<>?');
my @HEX      = ('0'..'9', 'a'..'f');

main();
exit -1;

sub main
{
    my $all = 0;
    GetOptions('all' => \$all);

    # basic alpha numeric
    passwordGrid(8, 16, \@ALPHA_L, \@ALPHA_U, \@NUMBERS);
    passwordGrid(4, 32, \@ALPHA_L, \@ALPHA_U, \@NUMBERS);
    passwordGrid(2, 64, \@ALPHA_L, \@ALPHA_U, \@NUMBERS);

    exit 0 if ! $all;

    passwordGrid(8, 16, \@ALPHA_L, \@ALPHA_U, \@NUMBERS, \@SYMBOLS1);

    passwordGrid(8, 16, \@ALPHA_L, \@ALPHA_U, \@NUMBERS, \@SYMBOLS1, \@SYMBOLS2);
    passwordGrid(4, 32, \@HEX);

    if (! -f $WORD_SOURCE) {
        die("Word source \"$WORD_SOURCE\" not found")
    } else {
        my @wordPool;
        getWordPool($WORD_SOURCE, 100, \@wordPool);
        if (scalar @wordPool < 1) {
            die("Failed to create word pool from word source \"$WORD_SOURCE\"");
        }

        memorablePasswordGrid(\@wordPool);
        listOfWords(\@wordPool, 4, 5);
    }

    exit 0;
}

sub getWordPool
{
    my $wordSourceFile = shift;
    my $poolSize = shift;
    my $wordPool = shift;
    if (ref($wordPool) ne 'ARRAY') { die("Not an array reference"); }

    open(my $wlfh, '<', $wordSourceFile) or die("Could not open word source \"$wordSourceFile\"\n");
    my @wordList;
    while (<$wlfh>) {
        chomp;
        push(@wordList, $_);
    }
    close $wlfh;
    my $numberOfWords = scalar(@wordList);

    if ($numberOfWords < $poolSize) {
        warn "WARNING: The word source \"$wordSourceFile\" contains less words than requested size \"$poolSize\"\n";
    } elsif ($numberOfWords < ($poolSize * 5)) {
        warn "WARNING: The word source \"$wordSourceFile\" isn't very big\n";
    }

    for (1..$poolSize) {
        push(@$wordPool, @wordList[ int(rand $numberOfWords) ]);
    }
    @wordList = [];

    return 1;
}

sub listOfWords
{
    my $wordPool = shift;
    if (ref($wordPool) ne 'ARRAY') { die("Not an array reference"); }
    my $totalLines = shift;

    for (1..$totalLines) {
        my $lineLength = 1;
        for (1..15) {
            my $word = shift(@$wordPool);

            $lineLength += length($word) + 1;
            if ($lineLength > $GRID_WIDTH) { last; }

            if (int( rand(2) ) > 0) {
                $word = titleCase($word);
            }

            print " $word";
        }
        print "\n";
    }

    print '-'x74 . "\n";

    return 1;
}

# passwords in the style: Pass11Word or PassWord11
sub memorablePasswordGrid
{
    my $wordPool = shift;
    if (ref($wordPool) ne 'ARRAY') { die("Not an array reference"); }

    my $colWidth = int($GRID_WIDTH / 3);
    for (1..3) {
        my $lineLength = 0;
        for (1..6) {
            my $word1 = shift(@$wordPool);
            my $word2 = shift(@$wordPool);

            # decide how/if we should capitalise the words
            if (int( rand(4) ) > 2) {
                $word1 = titleCase($word1);
            } else {
                if (int( rand(5) ) > 2) {
                    $word2 = titleCase($word2);
                }
            }

            my $l = int( rand(4) ) + 1;
            my $nonAlphas = generatePassword($l, \@NUMBERS, \@SYMBOLS0);

            my $password = '';
            # how should the words be arranged in relation to the non alphas
            if (int( rand(5) ) > 2) {
                $password = $word1 . $nonAlphas . $word2;
            } else {
                # force title case to make it more memorable
                $password = $word1 . titleCase($word2) . $nonAlphas;
            }

            next if ! qualityPassword($password);

            if (($lineLength + $colWidth) > $GRID_WIDTH) { last; }

            printf "% $colWidth" . 's', $password;

            $lineLength += $colWidth;
        }
        print "\n";
    }

    print '-'x74 . "\n";

    return 1;
}

# does the password meet the complexity requirements?
sub qualityPassword
{
    my $password = shift;

    my $matches = 0;
    $matches++ if $password =~ m/[a-z]/;
    $matches++ if $password =~ m/[A-Z]/;
    $matches++ if $password =~ m/[0-9]/;
    $matches++ if $password =~ m/[,.\/;'\[\]\\` ~!@#$%^&*(){}|:"<>?]/;

    return 0 if $matches < 3;
    return 1;
}

sub titleCase
{
    my $word = shift;
    return uc(substr($word, 0, 1)) . lc(substr($word, 1));
}

sub passwordGrid
{
    my $numberOfPasswords = shift;
    my $lengthOfPasswords = shift;
    my @chars = @_;

    # how to layout the grid
    my $colMax = 1;
    my $colWidth = $GRID_WIDTH;
    if ($lengthOfPasswords > ($GRID_WIDTH / 2)) {
        $colMax = 1;
        $colWidth = $GRID_WIDTH;
    } elsif ($lengthOfPasswords > ($GRID_WIDTH / 4)) {
        $colMax = 2;
        $colWidth = int($GRID_WIDTH / 2);
    } elsif ($lengthOfPasswords > ($GRID_WIDTH / 8)) {
        $colMax = 4;
        $colWidth = int($GRID_WIDTH / 4);
    } elsif ($lengthOfPasswords > ($GRID_WIDTH / 16)) {
        $colMax = 8;
        $colWidth = int($GRID_WIDTH / 8);
    }

    my $passwordCount = 0;
    for (my $row = 0; $passwordCount < $numberOfPasswords; $row++) {
        for (my $col = 0; $col < $colMax; $col++) {
            my $password = generatePassword($lengthOfPasswords, @chars);
            printf "% $colWidth" . 's', $password;
            $passwordCount++;
        }
        print "\n";
    }

    print '-'x74 . "\n";

    return 1;
}

sub generatePassword
{
    my $targetLength = shift;
    my @charTypes = @_;
    my @password;
    my $c = 1;
    foreach my $charType (@charTypes) {
        # favour earlier character types
        my $blockLength = int($targetLength / ($c++));
        #print "\n c = $c; bl = $blockLength";
        my $charTypeSize = scalar( @{$charType} );
        foreach (1..($blockLength)) {
            push(@password, $charType->[ int(rand $charTypeSize) ]);
        }
    }
    my @pw;
    # always start with a character from the first set
    # i prefer passwords starting with a lowercase character
    # comment out the following line if you don't
    push(@pw, shift(@password));
    # mix up the character groups
    push(@pw, shuffle(@password));
    #
    my $password = join('', @pw);
    # fix any broken maths above
    $password = substr($password, 0, $targetLength);
    #
    return $password;
}
