use Test;
use FontConfig;
use FontConfig::Raw;

constant $MinVersion = v2.13.1;
my $LibVersion = FontConfig.version;

note "fontconfig library version: $LibVersion";
ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version is too old. This module will not operate normally, or pass tests ***";

my FcName $weight = FcName::object('weight');
is $weight.object, 'weight';
my FontConfig:D $patt .= parse: 'Arial,sans-serif:style=italic';
ok $patt.pattern.defined;
note FontConfig.version();
is $patt.Str, 'Arial,sans:style=italic';
is $patt.elems, 2;
is-deeply $patt.keys.sort, ("family", "style");
is-deeply $patt.family, ['Arial', 'sans'];
$patt.weight = 'bold';
is-deeply $patt.weight, 200;
$patt.weight = 200..210;
is-deeply $patt.weight, 200..210;

is-deeply $patt.keys.sort, ("family", "style", "weight");
is $patt<style>, 'italic';
is $patt.Str, 'Arial,sans:style=italic:weight=[200 210]';
$patt<weight>:delete;
is $patt.Str, 'Arial,sans:style=italic';
is-deeply $patt.keys.sort, ("family", "style");
$patt.configure;
ok $patt.elems > 2;
isnt $patt.Str, 'Arial,sans:style=italic';
nok $patt<file>:exists;
nok $patt<file>.defined;

my FontConfig $match;
lives-ok {$match = $patt.match()};
ok $match<weight>:exists;
ok $match<file>:exists;
ok $match<file>.defined;
isa-ok $match<file>, Str;
ok $match.format('%{file}').IO.e, 'matched a file';

done-testing;

