# Password Generator

## Introduction

Script that outputs passwords in a variety of styles:
* 16, 32, 64 character long alpha numerics
* 16 character long alpha numerics and "easy" symbols
* 16 character long alpha numerics and "hard" symbols
* 32 character long hex
* words + numbers + symbols
* 20 bare words (for all your battery horse staple needs)

## Examples

    % passwords.pl --all
      jnmq49B9wnsW7Ass  pkF2Evu5chh9wMV4  wjy3Jw8CBzpN4JeT  uVu8Ms6iJbmZzaX4
      wS9hnCbmULJz8aDx  o3YFjWZ7gfaXrgzh  iHCZ2Vt3M2xcsH4A  so9Ndqj7Z5YdgBwh
    --------------------------------------------------------------------------
        fNmemuKGBwWxaGqDh3wwaGsJr5fFEaHg    vbsJ9xcQ28yrKsgFdTeWKqb2b8rF4kPb
        sVs3buaTyjV2kZoa9fCzXdeD9n2J7ctQ    xgNg5Q7crqYiPc8LGztrbMp54j5P2aEe
    --------------------------------------------------------------------------
            omkMhbLrbnHwodRayzdp5YsaC7tb8ykVe578ciA27coiALhzPYpnLj8M24aUjwUt
            uz6ha22zfnVvSxaGw48myHZdium66JYpke3MYhRownhoqGxo7fooPqWDtxE5mBAe
    --------------------------------------------------------------------------
      cq4sdiYG7Gs7/a=W  rte887qCiHxawJXr  wDgf3,2nwg/A\NfZ  brs.4D/GtGb,f=bG
      c uWetQ/ap7iWFD4  zqkr\Tj6kxfP86/w  ovE745hdV\xZL;nJ  q=NxSxvqjnvocuP9
    --------------------------------------------------------------------------
      n4U.vQz{,8k4joAR  ghuX2sr`|Biv(\iK  yi`YhuokLy#\sJ\m  c+xJd=\Nn9nsBCd,
      q~iVY3oVerKB\xzv  fLzQbd.b`6R8rog8  z87WtMTrsgx%\v2j  hEJPbz-\RfpmdT%v
    --------------------------------------------------------------------------
        8c24ef693f06837c11be61062e847668    a6faaf0feb28221d6490f11fc21dd49c
        4f77488566ab78a7cd44c9dd5df5797c    1fe9cd09977163976a2691e7622f41b4
    --------------------------------------------------------------------------
            abaser82Backup's        Female5*circuity            Upsets5vim's
           Kimble'sNaiad's5%        RussianInstead32        catchingCrosser7
              antTalmud's263          caughtFoggier8         Jugged89goddess
    --------------------------------------------------------------------------
     bandiest duffer sunburn pottered Watling fantasy Rent's Fortiori
     Planers poorly Glowed Honers mesas moon Irked Thayer's Intrigue
     bullock hasp Involves spoons Manley Unisys's Worksop Gregorio Skysails
     Celestas SMSA's Sanskrit uncheck docked humorist Mom's Tomlin target
    --------------------------------------------------------------------------

## Operation

By default the script outputs just alpha numeric passwords.

Pass the -a/--all command-line parameter to display all formats.

Edit the $WORD_SOURCE variable in the script to change the location to the list
of words that. The word source should be pre-stripped of words from popular
password word lists. You probably want to filter it further to be words of at
least 3 characters and no more than 8 characters (so they are easy to type/more
memorable).

## Alternatives

`pwgen` is a good alternative to the random alpha numerics this script
generates.
