#| A sorted series of results from matching a FontConfig pattern
unit class FontConfig::Match::Series
    does Iterable;

use FontConfig::Match;
use FontConfig::Pattern;
use FontConfig::Raw;

has FontConfig::Pattern:D $.pat is required;
has FcFontSet:D $.set .= new;
has Bool:D $.trim = False;
has UInt $.best;

submethod TWEAK(UInt :$limit) {
    with $limit {
        ## warn ':limit is deprecated, please use :best';
        $!best //= $limit;
    }
}

method elems {
    min($!set.nfont, $!best.Int // Inf);
}

multi method AT-POS(UInt:D $i where $i < $!set.nfont --> FontConfig::Match) {
    my FcPattern:D $pattern = $!pat.configure.render-prepare: $!pat.pattern, $!set.fonts[$i];
    FontConfig::Match.new: :$pattern;
}

multi method AT-POS(UInt:D) { FontConfig::Match }

method iterator(::?CLASS:D $set:) handles<Seq List Array> {
    class iterator does Iterator {
        has uint $.i = 0;
        has FontConfig::Match::Series:D $.set is required;
        has uint $!n = $!set.elems;

        submethod TWEAK(UInt :$best) {
            with $best {
                $!n = $_ if $_ < $!n;
            }
        }

        method pull-one {
            $!i >= $!n
               ?? IterationEnd
               !! $!set.AT-POS($!i++);
        }
    }

    iterator.new: :$set, :$!best;
}

method parse(Str:D $query, |c) {
    my int32 $result-type;
    my FcPattern $pattern = FcPattern::parse($query)
        // die "unable to parse pattern: '$query'";
    my FontConfig::Pattern:D $pat .= new: :$pattern, :configure;
    self.match: $pat, |c;
}

method match(FontConfig::Pattern:D $pat, Bool :$trim = False, |c) {
    my int32 $result-type;
    my FcFontSet $set = $pat.configure.font-sort($pat.pattern, $trim, FcCharSet, $result-type);
    self.new: :$pat, :$set, |c;
}

=begin pod

=head2 Synopsis

=begin code :lang<raku>
use FontConfig::Match::Series;
my $n = 0;
my $best = 10;
say "The $best best matching fonts are:";
for FontConfig::Match::Series.parse('Arial,sans:style<italic>', :$best) -> FontConfig::Match $match {
    say (++$n)~ $match.format(':%{fullname}: %{file} (%{fontformat})');
}
=end code

=head2 Description

This class returns a sequence of matches from a FontConfig pattern, ordered by best match first. This may be useful, if there are extra selection or sort critera, or the final selection is being performed interactively.

=end pod
