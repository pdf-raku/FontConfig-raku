[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)
 :: [Match](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Match)
 :: [Series](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Match/Series)

class FontConfig::Match::Series
-------------------------------

A sorted series of results from matching a FontConfig pattern

Synopsis
--------

```raku
use FontConfig::Match::Series;
my $n = 0;
my $limit = 10;
say "$limit best match fonts:";
for FontConfig::Match::Series.parse('Arial,sans:style<italic>', :$limit) -> FontConfig::Match $match {
    say (++$n)~ $match.format(':%{fullname}: %{file} (%{fontformat})');
}
```

Description
-----------

This class returns a sequence of matches from a FontConfig pattern, ordered by best match first. This may be useful, if there are extra selection or sort critera, or the final selection is being performed interactively.

