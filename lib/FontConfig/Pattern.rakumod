#| FontConfig patterns and searching
unit class FontConfig::Pattern
    does Iterable;

use FontConfig;
also is FontConfig;

use FontConfig::Match;
use FontConfig::Raw;
use NativeCall;

method parse(Str:D $query, |c) {
    my FcPattern:D $pattern = FcPattern::parse($query);
    self.new: :$pattern, |c;
}

method match(::?CLASS:D $pattern is copy:) {
    $pattern .= clone: :configure unless $.configured;
    with self.configure.font-match($pattern.pattern, my int32 $result) -> FcPattern $pattern {
        FontConfig::Match.new: :$pattern;
    }
    else {
        FontConfig::Match;
    }
}

method match-series(::?CLASS:D $pattern: |c) handles <Seq List Array iterator> {
    (require ::('FontConfig::Match::Series')).match($pattern, |c);
}

=begin pod

=head2 Description

A pattern is used for font matching. The following fields
are commonly used for matching

=begin table
Field | Values | Constants | Description
========================================
file | Str | | The filename holding the font
family | Str | | Font family names
scalable | Bool | | Whether glyphs can be scaled
color | Bool | | Whether any glyphs have color
charset | CharSet | | Font characters
postscriptname | Str | | Font postscript name
spacing | Int | proportional=0, dual=90, mono=100, charcell=110 |
size | Range | Supported font sizes
pixelsize | Num | | Supported pixel sizes
style | Str | | Font style. Overrides weight and slant
slant | Int | roman=0, italic=100, oblique=110 |
weight | thin=0, extralight=40, ultralight=40, light=50 demilight=55 book=70 regular=80 normal=80 medium=100 demibold=180 bold=200 extrabold=205 black=210 extrablack=215  
width | ultracondensed=50, extracondensed=63, condensed=75, semicondensed=87, normal=100, semiexpanded=113, expanded=125, extraexpanded=150, ultraexpanded=200 |
antialias | Bool | |
outline | Bool | | Whether the glyphs are outlines
fontversion | Int | |
fontformat | Str | | E.g. 'CFF', 'TrueType', 'Type 1'
=end table

This class inherits from L<FontConfig> and has all its methods available.

=head2 Methods

=head3 new

=for code :lang<raku>
method new(*%atts --> FontConfig::Pattern)

Create a new pattern for font matching purposes

=head3 parse

=for code :lang<raku>
method parse(Str $patt --> FontConfig::Pattern)

Create a new pattern from a parsed FontConfig pattern.

=head3 AT-KEY, ASSIGN-KEY, keys, elems, pairs, values

    =begin code :lang<raku>
    $patt<weight> = 205;
    $patt<weight> = 'bold';
    say $patt<weight>;
    $patt<weight>:delete;
    =end code

This module provides am associative interface to [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

Numeric values in the pattern may be set to ranges:

=for code :lang<raku>
$patt<weight> = 195..205;

Values may also hold a list, such as a list of font families:

=for code :lang<raku>
$patt<family> = <Arial sans>;

=head3 match

=for code :lang<raku>
method match(--> FontConfig::Match)

This method returns a FontConfig object for the system font that best
matches this pattern.

The matched object is populated with the actual font properties. The
`file` property contains the path to the font.

    =begin code :lang<raku>
    my FontConfig $match = $pattern.match;
    say 'matched font: ' ~ $match<fullname>;
    say 'actual weight: ' ~ $match<weight>;
    say 'font file: ' ~ $match<file>;
    =end code


=head3 parse

=for code :lang<raku>
method parse(Str $patt --> FontConfig::Pattern)

Create a new pattern from a parsed FontConfig pattern.


=head3 match-series

=for code :lang<raku>
method match(--> FontConfig::Match::Series)

This method returns a series of L<FontConfig::Match> objects ordered by 
closest match first.

=end pod

