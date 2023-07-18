[[Raku PDF Project]](https://pdf-raku.github.io)
/ [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku/)
[![Build Status](https://travis-ci.org/pdf-raku/FontConfig-raku.svg?branch=master)](https://travis-ci.org/pdf-raku/FontConfig-raku)

FontConfig-raku
=====

Raku interface to the FontConfig native library

Synopsis
-------

```raku
use FontConfig;
use FontConfig::Pattern;
use FontConfig::Match;
# optional: fontconfig uses the default system configuration, by default 
INIT FontConfig.set-config-file: 'my-fonts.conf';

my FontConfig::Pattern $patt .= parse: 'Arial,sans:style<italic>';
# -- OR --
$patt .= new: :family<Arial sans>, :style<italic>;

$patt.weight = 'bold';
say $patt.Str;
# Arial,sans:style=italic:weight=205

my FontConfig::Match $match = $patt.match;
say $match.file;
say $match.format('%{file}');
# e.g. /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf
```

Description
----------
This module provides Raku bindings to the FontConfig library for system-wide font
configuration and access.

At this stage, enough library bindings are implemented to enable
FontConfig patterns to be parsed or built, and the best matching
font to be located.



## Property Accessors

The Raku FontConfig bindings provide automatic accessors for known properties

    $patt.weight = 'bold';
    say $patt.weight;

## FontConfig Configuration

By default, fontconfig uses system-wide font configuration files. Their
location may depend on your particular distribution and system.

There are several environment variables that can be set to define files and search paths, including: `FONTCONFIG_FILE` and `FONTCONFIG_PATH`.

This may need to be set, prior to running your programs, to provide a custom configuration file, or if FontConfig is giving an error "Cannot load default config file".

The FontConfig class has one method `set-config-file($path)` that can be called from the
current process to set `FONTCONFIG_FILE`. This acts globally and should be called once, before using any other methods.

## Modules in this distribution

* [FontConfig](https://pdf-raku.github.io/FontConfig-raku/) - FontConfig base class for Patterns and Matches
* [FontConfig::Pattern](https://pdf-raku.github.io/FontConfig-raku/Pattern) - FontConfig query Pattern
* [FontConfig::Match](https://pdf-raku.github.io/FontConfig-raku/Match) - FontConfig matching font descriptor
* [FontConfig::Match::List](https://pdf-raku.github.io/FontConfig-raku/Match/List) - Sorted list of FontConfig::Match matching objectwss
* [FontConfig::Raw](https://pdf-raku.github.io/FontConfig-raku/Raw) - FontConfig native bindings

## Install

This module requires a development version of fontconfig:

- Debian/Ubuntu Linux: `sudo apt-get install libfontconfig1-dev`
- Alpine/Linux: `doas apk add fontconfig-dev`
- Mac OS X: `brew install fontconfig`
