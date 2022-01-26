use Test;
use FontConfig;

my FontConfig:D $fc .= parse: 'Arial:style=italic';
ok $fc.pattern.defined;
is $fc.Str, 'Arial:style=italic';
is $fc.elems, 2;
is-deeply $fc.keys.sort, ("family", "style");
is $fc<family>, 'Arial';
$fc<weight> = 'bold';
is-deeply $fc<weight>, 200;
$fc<weight> = 200..210;
is-deeply $fc<weight>, 200..210;

say $fc.Str;
is-deeply $fc.keys.sort, ("family", "style", "weight");
is $fc<style>, 'italic';
is $fc.Str, 'Arial:style=italic:weight=[200 210]';
$fc<weight>:delete;
is $fc.Str, 'Arial:style=italic';
is-deeply $fc.keys.sort, ("family", "style");
$fc.configure;
ok $fc.elems > 2;
isnt $fc.Str, 'Arial:style=italic';
nok $fc<file>:exists;
nok $fc<file>.defined;
lives-ok {$fc .= match()};
ok $fc<file>:exists;
ok $fc<file>.defined;
isa-ok $fc<file>, Str;
ok $fc.format('%{file}').IO.e, 'matched a file';

done-testing;