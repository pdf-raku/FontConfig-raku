use Test;
use FontConfig;

my FontConfig:D $patt .= parse: 'Arial:style=italic';
ok $patt.pattern.defined;
is $patt.Str, 'Arial:style=italic';
is $patt.elems, 2;
is-deeply $patt.keys.sort, ("family", "style");
is $patt.family, 'Arial';
$patt.weight = 'bold';
is-deeply $patt.weight, 200;
$patt.weight = 200..210;
is-deeply $patt.weight, 200..210;

is-deeply $patt.keys.sort, ("family", "style", "weight");
is $patt<style>, 'italic';
is $patt.Str, 'Arial:style=italic:weight=[200 210]';
$patt<weight>:delete;
is $patt.Str, 'Arial:style=italic';
is-deeply $patt.keys.sort, ("family", "style");
$patt.configure;
ok $patt.elems > 2;
isnt $patt.Str, 'Arial:style=italic';
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