use Test;
use FontConfig;

my FontConfig:D $fc .= parse: 'Arial:style=bold';
ok $fc.pattern.defined;
is $fc.Str, 'Arial:style=bold';
is $fc.elems, 2;
is-deeply $fc.keys.sort, ("family", "style");
is $fc.Hash<family>, 'Arial';
is $fc.Hash<style>, 'bold';
$fc.configure;
ok $fc.elems > 2;
isnt $fc.Str, 'Arial:style=bold';
lives-ok {$fc .= match()};
ok $fc.format('%{file}').IO.e, 'matched a file';

pass;
done-testing;