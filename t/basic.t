use Test;
use FontConfig;

my FontConfig:D $fc .= parse: 'Arial';
ok $fc.pattern.defined;
ok $fc.format('%{file}').IO.e, 'matched a file';

pass;
done-testing;