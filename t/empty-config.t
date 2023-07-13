use Test;
plan 8;

use FontConfig;
use FontConfig::Pattern;
use FontConfig::Match;
use FontConfig::Raw;
FontConfig.set-config-file("t/empty-config.xml");
is %*ENV<FONTCONFIG_FILE>.IO.relative.Str, "t/empty-config.xml";

# use an empty configuration file to disable font
# loading. This hopefully works on all platforms.

my FontConfig::Pattern $patt .= parse: 'Arial,sans-serif:style=italic';
isa-ok $patt, 'FontConfig';
ok $patt.defined, 'FontConfig';
ok $patt.pattern.defined;
is $patt.Str, 'Arial,sans:style=italic';
is $patt.elems, 2;

my FontConfig::Match $match = $patt.match();
isa-ok $match, FontConfig::Match;
nok $match.defined, 'Matching has been disabled';

