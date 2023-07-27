[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)
 :: [Pattern](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Pattern)

class FontConfig::Pattern
-------------------------

FontConfig patterns and searching

Description
-----------

A pattern is used for font matching. The following fields are commonly used for matching

<table class="pod-table">
<thead><tr>
<th>Field</th> <th>Values</th> <th>Constants</th> <th>Description</th>
</tr></thead>
<tbody>
<tr> <td>file</td> <td>Str</td> <td>| The filename holding the font</td> <td></td> </tr> <tr> <td>family</td> <td>Str</td> <td>| Font family names</td> <td></td> </tr> <tr> <td>scalable</td> <td>Bool</td> <td>| Whether glyphs can be scaled</td> <td></td> </tr> <tr> <td>color</td> <td>Bool</td> <td>| Whether any glyphs have color</td> <td></td> </tr> <tr> <td>charset</td> <td>CharSet</td> <td>| Font characters</td> <td></td> </tr> <tr> <td>postscriptname</td> <td>Str</td> <td>| Font postscript name</td> <td></td> </tr> <tr> <td>spacing</td> <td>Int</td> <td>proportional=0, dual=90, mono=100, charcell=110</td> <td></td> </tr> <tr> <td>size</td> <td>Range</td> <td>Supported font sizes</td> <td></td> </tr> <tr> <td>pixelsize</td> <td>Num</td> <td>| Supported pixel sizes</td> <td></td> </tr> <tr> <td>style</td> <td>Str</td> <td>| Font style. Overrides weight and slant</td> <td></td> </tr> <tr> <td>slant</td> <td>Int</td> <td>roman=0, italic=100, oblique=110</td> <td></td> </tr> <tr> <td>weight</td> <td>thin=0, extralight=40, ultralight=40, light=50 demilight=55 book=70 regular=80 normal=80 medium=100 demibold=180 bold=200 extrabold=205 black=210 extrablack=215</td> <td></td> <td></td> </tr> <tr> <td>width</td> <td>ultracondensed=50, extracondensed=63, condensed=75, semicondensed=87, normal=100, semiexpanded=113, expanded=125, extraexpanded=150, ultraexpanded=200</td> <td></td> <td></td> </tr> <tr> <td>antialias</td> <td>Bool</td> <td>|</td> <td></td> </tr> <tr> <td>outline</td> <td>Bool</td> <td>| Whether the glyphs are outlines</td> <td></td> </tr> <tr> <td>fontversion</td> <td>Int</td> <td>|</td> <td></td> </tr> <tr> <td>fontformat</td> <td>Str</td> <td>| E.g. &#39;CFF&#39;, &#39;TrueType&#39;, &#39;Type 1&#39;</td> <td></td> </tr>
</tbody>
</table>

This class inherits from [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig) and has all its methods available.

Methods
-------

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

