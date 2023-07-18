unit class FontConfig::Pattern;

use FontConfig;
also is FontConfig;

use FontConfig::Match;
use FontConfig::Raw;

method parse(Str:D $query, |c) {
    my FcPattern:D $pattern = FcPattern::parse($query);
    self.new: :$pattern, |c;
}

method match(::?CLASS:D $pattern is copy:) {
    $pattern .= clone: :configure unless $.configured;
    with self.config.font-match($pattern.pattern, my int32 $result) -> FcPattern $pattern {
        FontConfig::Match.new: :$pattern;
    }
    else {
        FontConfig::Match;
    }
}

method match-list(::?CLASS:D $pattern: |c) handles <Seq List Array> {
    (require ::('FontConfig::Match::List')).match($pattern, |c);
}
