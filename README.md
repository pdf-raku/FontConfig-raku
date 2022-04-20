FontConfig-raku

Raku interface to the FontConfig native library

Synopsis
-------

```raku
use FontConfig;

# %ENV{FONTCONFIG_FILE} = 'my-fonts.conf';
my FontConfig:D $patt .= parse: 'Arial,sans:style<italic>';
# -- OR --
$patt .= new: :family<Arial sans>, :style<italic>;

$patt.weight = 'bold';
say $patt.Str;
# Arial,sans:style=italic:weight=205

my FontConfig $match = $patt.match;
say $match.file;
say $match.format('%{file}');
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

Numeric values in the pattern may be set to ranges:

    $patt<weight> = 195..205;

Values may also hold a list, such as a list of font families:

    $patt<family> = <Arial sans>;

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

Fontconfig has symbolic constants for numeric properties. For example, in the pattern: `Ariel;weight=bold`, `bold`,
evaluates to 200. The `constant()` method can be used to look-up these constants.

    my \bold = FontConfig.constant("bold"); # 200
    if $match<bold> >= bold {
        say "matching font is bold";
    }

Note that the Raku bindings resolve symbolic constants when a string is assigned
to a numeric property. So:

    $match<weight> = "extrabold";

Is equivalent to:

    $match<weight> = FontConfig.constant("extrabold");

### query-ft-face

    method query-ft-face(Pointer() $face, Str() :$file, UInt :$id --> FontConfig)

This method computes a FontConfig pattern based on the attributes of an existing
FreeType font. It can be used to discover FontConfig attributes for a specific font.

The match() method will find the best font, reachable by FontConfig's configuration,
that matches the original font, which may or may not be the original font.

**The following example requires installation of the L<Font::FreeType> module.**

    use FontConfig;
    use Font::FreeType;
    my $file = "t/fonts/Vera.ttf";
    my Font::FreeType::Face $face = Font::FreeType.face($file);
    my FontConfig $patt .= query-ft-face($face, :$file);
    say $patt.fullname; # Bitstream Vera Sans
    say $patt.file;     # t/fonts/Vera.ttf
    say $patt.weight;   # 80


### Str

The Str method serializes a pattern to a string representation;

    say $patt.Str; # Arial,sans:style=italic:weight=205

### version

    method version returns Version

This method returns the installed fontconfig library version. Please note that
the minimum supported version is `v2.13.1`.


## Property Accessors

The Raku FontConfig bindings provide automatic accessors for known properties

    $patt.weight = 'bold';
    say $patt.weight;

## FontConfig Configuration

The environment variable %*ENV<FONTCONFIG_FILE> defines the location of the FontConfig configuration file.

This may need to be set to provide a custom configuration file, or if FontConfig is giving an error "Cannot load default config file".

