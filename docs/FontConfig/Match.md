[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)
 :: [Match](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Match)

class FontConfig::Match
-----------------------

A result from matching a FontConfig Pattern

Synopsis
--------

```raku
use FontConfig;
use FontConfig::Pattern;
use FontConfig::Match;
use FontConfig::Match::Series;

my FontConfig::Pattern $patt .= parse: 'Arial,sans:style<italic>';

# find the closest match
my FontConfig::Match $best-match = $patt.match;
say "Best matching font: " ~ $best-match.format(':%{fullname}: %{file} (%{fontformat})');

# find a series of matches. Ordered by best match first
say "Best five matching fonts:";
my $n = 0;
for $patt.match-series(:trim) -> FontConfig::Match $match {
    say (++$n)~ $match.format(':%{fullname}: %{file} (%{fontformat})');
    last if $n >= 5;
}
```

Methods
-------

This class is based on [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig) and has all its method available.

