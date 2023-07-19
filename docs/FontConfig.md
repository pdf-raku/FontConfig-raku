[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)

Description
-----------

[FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig) is the base class for [FontConfig::Pattern](FontConfig::Pattern) (queries) and [FontConfig::Match](FontConfig::Match) (matches).

Methods
-------

### constant

    :lang<raku> method constant(Str $name --> UInt)

Fontconfig has symbolic constants for numeric properties. For example, in the pattern: `Ariel;weight=bold`, `bold`, evaluates to 200. The `constant()` method can be used to look-up these constants.

    my \bold = FontConfig.constant("bold"); # 200
    if $match<bold> >= bold {
        say "matching font is bold";
    }

Note that the Raku bindings resolve symbolic constants when a string is assigned to a numeric property. So:

    :lang<raku> $match<weight> = "extrabold";

Is equivalent to:

    :lang<raku> $match<weight> = FontConfig.constant("extrabold");

### query-ft-face

    :lang<raku> method query-ft-face(Pointer() $face, Str() :$file, UInt :$id --> FontConfig)

This method computes a FontConfig pattern based on the attributes of an existing FreeType font. It can be used to discover FontConfig attributes for a specific font.

The match() method will find the best font, reachable by FontConfig's configuration, that matches the original font, which may or may not be the original font.

**The following example requires installation of the `Font::FreeType` module.**

```raku
use FontConfig;
use Font::FreeType;
my $file = "t/fonts/Vera.ttf";
my Font::FreeType::Face $face = Font::FreeType.face($file);
my FontConfig $patt .= query-ft-face($face, :$file);
say $patt.fullname; # Bitstream Vera Sans
say $patt.file;     # t/fonts/Vera.ttf
say $patt.weight;   # 80
```

### AT-KEY, ASSIGN-KEY, keys, elems, pairs, values

```raku
$patt<weight> = 205;
$patt<weight> = 'bold';
say $patt<weight>;
$patt<weight>:delete;
```

This class provides am associative interface to [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

Numeric values in the pattern may be set to ranges:

    :lang<raku> $patt<weight> = 195..205;

Values may also hold a list, such as a list of font families:

    :lang<raku> $patt<family> = <Arial sans>;

### Str

The Str method serializes a pattern to a string representation;

    :lang<raku> say $patt.Str; # Arial,sans:style=italic:weight=205

### version

    :lang<raku> method version returns Version

This method returns the installed fontconfig library version. Please note that the minimum supported version is `v2.13.1`.

