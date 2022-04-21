use Test;
plan 8;

use FontConfig;
use FontConfig::Raw;
FontConfig.set-config-file("t/empty-config.xml");
is %*ENV<FONTCONFIG_FILE>.IO.relative.Str, "t/empty-config.xml";

# use an empty configuration file to disable font
# loading. This hopefully works on all platforms.

my $patt = FontConfig.parse: 'Arial,sans-serif:style=italic';
isa-ok $patt, 'FontConfig';
ok $patt.defined, 'FontConfig';
ok $patt.pattern.defined;
is $patt.Str, 'Arial,sans:style=italic';
is $patt.elems, 2;

my $match = $patt.match();
isa-ok $match, FontConfig;
nok $match.defined, 'Matching has been disabled';

