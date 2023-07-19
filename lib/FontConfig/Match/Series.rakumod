#| A sorted series of results from matching a FontConfig pattern
unit class FontConfig::Match::Series
    does Iterable;

use FontConfig::Match;
use FontConfig::Pattern;
use FontConfig::Raw;

has FontConfig::Pattern:D $.pat is required;
has FcFontSet:D $.set .= new;
has Bool:D $.trim = False;

method elems { $!set.nfont }

multi method AT-POS(UInt:D $i where $i < $!set.nfont --> FontConfig::Match) {
    my FcPattern:D $pattern = $!pat.config.render-prepare: $!pat.pattern, $!set.fonts[$i];
    FontConfig::Match.new: :$pattern;
}

multi method AT-POS(UInt:D) { FontConfig::Match }

method iterator(::?CLASS:D $set:) {
    class iterator does Iterator {
        has uint $.i = 0;
        has FontConfig::Match::Series:D $.set is required;
        method pull-one {
            $!i >= $!set.elems
               ?? IterationEnd
               !! $!set.AT-POS($!i++);
        }
    }
    iterator.new: :$set;
}

method Seq handles<List Array> {
    (^$.elems).map: {$.AT-POS: $_}
}

method parse(Str:D $query, |c) {
    my int32 $result-type;
    my FcPattern $pattern = FcPattern::parse($query)
        // die "unable to parse pattern: '$query'";
    my FontConfig::Pattern:D $pat .= new: :$pattern, :configure;
    self.match: $pat, |c;
}

multi method match(FontConfig::Pattern:D $pat, Bool :$trim = False) {
    my int32 $result-type;
    my FcFontSet $set = $pat.config.font-sort($pat.pattern, $trim, FcCharSet, $result-type);
    self.new: :$pat, :$set;
}
