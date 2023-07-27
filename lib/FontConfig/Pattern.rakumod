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

This class represents an input pattern for font matching.

=head2 Methods

This class inherits from L<FontConfig> and has all its methods available.

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

