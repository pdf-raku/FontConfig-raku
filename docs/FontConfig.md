[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)

Description
-----------

[FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig) is the base class for [FontConfig::Pattern](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Pattern) (queries) and [FontConfig::Match](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Match) (matches).

Font Properties
---------------

Common font properties include:

<table class="pod-table">
<thead><tr>
<th>Field</th> <th>Values / Constants</th> <th>Description</th> <th></th>
</tr></thead>
<tbody>
<tr> <td>antialias</td> <td>Bool</td> <td>Whether glyphs can be antialiased</td> <td></td> </tr> <tr> <td>charset</td> <td>CharSet</td> <td>Font characters</td> <td></td> </tr> <tr> <td>color</td> <td>Bool</td> <td>Whether any glyphs have color</td> <td></td> </tr> <tr> <td>family</td> <td>Str</td> <td>Font family names</td> <td></td> </tr> <tr> <td>file</td> <td>Str</td> <td>The filename holding the font</td> <td></td> </tr> <tr> <td>fontformat</td> <td>Str</td> <td>E.g. &#39;CFF&#39;, &#39;TrueType&#39;, &#39;Type 1&#39;</td> <td></td> </tr> <tr> <td>fontversion</td> <td>Int</td> <td>Version number of the font</td> <td></td> </tr> <tr> <td>hinting</td> <td>Bool</td> <td>Whether the rasterizer uses hinting</td> <td></td> </tr> <tr> <td>outline</td> <td>Bool</td> <td>Whether the glyphs are outlines</td> <td></td> </tr> <tr> <td>pixelsize</td> <td>Num</td> <td>Supported pixel sizes</td> <td></td> </tr> <tr> <td>postscriptname</td> <td>Str</td> <td>Font postscript name</td> <td></td> </tr> <tr> <td>scalable</td> <td>Bool</td> <td>Whether glyphs can be scaled</td> <td></td> </tr> <tr> <td>size</td> <td>Range</td> <td>Supported font sizes</td> <td></td> </tr> <tr> <td>slant</td> <td>Int / roman=0, italic=100, oblique=110</td> <td>Font slant</td> <td></td> </tr> <tr> <td>spacing</td> <td>Int</td> <td>proportional=0, dual=90, mono=100, charcell=110</td> <td>Spacing between glypjs</td> </tr> <tr> <td>style</td> <td>Str</td> <td>Font style. Overrides weight and slant</td> <td></td> </tr> <tr> <td>weight</td> <td>Int / thin=0, extralight=40, ultralight=40, light=50 demilight=55 book=70 regular=80 normal=80 medium=100 demibold=180 bold=200 extrabold=205 black=210 extrablack=215</td> <td>Font weight</td> <td></td> </tr> <tr> <td>width</td> <td>Int / ultracondensed=50, extracondensed=63, condensed=75, semicondensed=87, normal=100, semiexpanded=113, expanded=125, extraexpanded=150, ultraexpanded=200</td> <td></td> <td></td> </tr>
</tbody>
</table>

For more properties, see [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

FontConfig command-line toos such as [fc-query](https://linux.die.net/man/1/fc-query) and [fc-match](https://linux.die.net/man/1/fc-match) can be used to query fonts and properties.

Methods
-------

### constant

```raku
method constant(Str $name --> UInt)
```

Fontconfig has symbolic constants for numeric properties. For example, in the pattern: `Ariel;weight=bold`, `bold`, evaluates to 200. The `constant()` method can be used to look-up these constants.

    my \bold = FontConfig.constant("bold"); # 200
    if $match<bold> >= bold {
        say "matching font is bold";
    }

Note that the Raku bindings resolve symbolic constants when a string is assigned to a numeric property. So:

```raku
$match<weight> = "extrabold";
```

Is equivalent to:

```raku
$match<weight> = FontConfig.constant("extrabold");
```

### query-ft-face

```raku
method query-ft-face(Pointer() $face, Str() :$file, UInt :$id --> FontConfig)
```

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

```raku
$patt<weight> = 195..205;
```

Values may also hold a list, such as a list of font families:

```raku
$patt<family> = <Arial sans>;
```

### Str

The Str method serializes a pattern to a string representation;

```raku
say $patt.Str; # Arial,sans:style=italic:weight=205
```

### version

```raku
method version returns Version
```

This method returns the installed fontconfig library version. Please note that the minimum supported version is `v2.13.1`.

