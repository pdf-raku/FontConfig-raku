unit class FontConfig::Set
    does Iterable;

use FontConfig;
use FontConfig::Raw;

has FontConfig:D $.pat is required;
has FcFontSet:D $.set .= new;
has Bool:D $.trim = False;

method elems { $!set.nfont }

multi method AT-POS(UInt:D $i where $i < $!set.nfont) {
    my $match = $!set.fonts[$i];
    $!pat.render-prepare($match);
}

multi method AT-POS(UInt:D) { FontConfig }

method iterator(::?CLASS:D $set:) {
    class iterator does Iterator {
        has uint $.i = 0;
        has FontConfig::Set:D $.set is required;
        method pull-one {
            warn $!i;
            $!i >= $!set.elems
               ?? IterationEnd
               !! $!set.AT-POS($!i++);
        }
    }
    iterator.new: :$set;
}

multi method match(Str:D $str, |c) {
    my int32 $result-type;
    my FcPattern $pattern = FcPattern::parse($str)
        // die "unable to parse pattern: '$str'";
    my FontConfig:D $pat .= new: :$pattern, :configure;
    self.match: $pat, |c;
}

multi method match( FontConfig:D $pat, Bool :$trim = False) {
    my int32 $result-type;
    my FcFontSet $set = $pat.config.font-sort($pat.pattern, $trim, FcCharSet, $result-type);
    self.new: :$pat, :$set;
}
