FontConfig-raku

Raku interface to the FontConfig native library

Synopsis
-------

```raku
use FontConfig;

# %ENV{FONTCONFIG_FILE} = 'my-fonts.conf';
my FontConfig:D $fc .= parse: 'Arial';
say $fc.format('%{file}');
# e.g. /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf
```

Description
----------
Bindings to the FontConfig library.
