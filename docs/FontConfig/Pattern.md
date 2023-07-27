[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)
 :: [Pattern](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Pattern)

class FontConfig::Pattern
-------------------------

FontConfig patterns and searching

Description
-----------

This class represents an input pattern for font matching.

Methods
-------

This class inherits from [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig) and has all its methods available.

### new

```raku
method new(*%atts --> FontConfig::Pattern)
```

Create a new pattern for font matching purposes

### parse

```raku
method parse(Str $patt --> FontConfig::Pattern)
```

Create a new pattern from a parsed FontConfig pattern.

### AT-KEY, ASSIGN-KEY, keys, elems, pairs, values

```raku
$patt<weight> = 205;
$patt<weight> = 'bold';
say $patt<weight>;
$patt<weight>:delete;
```

This module provides am associative interface to [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

Numeric values in the pattern may be set to ranges:

```raku
$patt<weight> = 195..205;
```

Values may also hold a list, such as a list of font families:

```raku
$patt<family> = <Arial sans>;
```

### match

```raku
method match(--> FontConfig::Match)
```

This method returns a FontConfig object for the system font that best matches this pattern.

The matched object is populated with the actual font properties. The `file` property contains the path to the font.

```raku
my FontConfig $match = $pattern.match;
say 'matched font: ' ~ $match<fullname>;
say 'actual weight: ' ~ $match<weight>;
say 'font file: ' ~ $match<file>;
```

### parse

```raku
method parse(Str $patt --> FontConfig::Pattern)
```

Create a new pattern from a parsed FontConfig pattern.

### match-series

```raku
method match(--> FontConfig::Match::Series)
```

This method returns a series of [FontConfig::Match](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Match) objects ordered by closest match first.

