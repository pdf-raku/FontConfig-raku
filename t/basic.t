use Test;
use FontConfig;

my FontConfig:D $fc .= parse: 'Arial:style=bold';
ok $fc.pattern.defined;
is $fc.Str, 'Arial:style=bold';
$fc.configure;
isnt $fc.Str, 'Arial:style=bold';
lives-ok {$fc .= match()};
ok $fc.format('%{file}').IO.e, 'matched a file';

pass;
done-testing;