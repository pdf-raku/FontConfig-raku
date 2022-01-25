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
$patt<weight> = 500;
say $patt.Str;
Arial:style=italic:weight=500
my FontConfig $match = $patt.match;
say $match.format('%{file}');
say $match<file>;
# e.g. /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf
```

Description
----------
Bindings to the FontConfig library.
