FontConfig-raku

Raku interface to the FontConfig native library

Synopsis
-------

```raku
use FontConfig;

# %ENV{FONTCONFIG_FILE} = 'my-fonts.conf';
my FontConfig:D $patt .= parse: 'Arial:style<italic>';
# -- OR --
$patt .= new: :family<Arial>, :style<italic>;
$patt.weight = 'bold';
say $patt.Str;
# Arial:style=italic:weight=205
my FontConfig $match = $patt.match;
say $match.format('%{file}');
say $match.file;
# e.g. /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf
```

Description
----------
Bindings to the FontConfig library.

At this stage, enough of the library is implemented to enable
FontConfig patterns to be parsed or built, and the best matching
font to be located.


Methods
-------

### new

    method new(*%atts --> FontConfig)

Create a new pattern for font matching purposes


### parse

    method parse(Str $patt --> FontConfig)

Create a new pattern from a parsed FontConfig pattern.

### AT-KEY, ASSIGN-KEY, keys, elems, pairs, values

    $patt<weight> = 205;
    $patt<weight> = 'bold';
    say $patt<weight>;
    $patt<weight>:delete;

This module provides am associative interface to [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

### match

    method match(--> FontConfig)

This method performs FontConfig matching and returns the system
font that best matches this pattern.

The matched object is populated with the actual font properties. The
`file` property contains the path to the font.

    my $match = $pattern.match;
    say 'matched font: ' ~ $match<fullname>;
    say 'actual weight: ' ~ $match<weight>;
    say 'font file: ' ~ $match<file>;

### constant

    method constant(Str $name --> UInt)

These are symbolic constants that can be used for numeric properties.

    my \bold = FontConfig.constant("bold");
    if $match<bold> >= bold {
        say "matching font is bold";
    }

Note that symbolic constant lookup is performed if a string is assigned
to a numeric property. So

    $match<weight> = "extrabold";

Is equivalent to:

    $match<weight> = FontConfig.constant("extrabold");

## Property Accessors

The Raku FontConfig bindings provide automatic accessors for known properties

    $patt.weight = 'bold';
    say $patt.weight;
