use Test;
plan 15;
use FontConfig;
FontConfig.set-config-file("t/custom-conf.xml");

my FontConfig:D $patt .= new;
my FontConfig $match;
ok $patt.pattern.defined;
is $patt.Str, '';
is $patt.elems, 0;
is-deeply $patt.keys.sort, ();

lives-ok {$match = $patt.match()};
ok $match.defined;
is $match.file.IO.relative, "t/fonts/Vera.ttf";
is $match.style, 'Roman';
is $match.weight, 80;

$patt .= parse: 'Vera:weight=bold';
is $patt.Str, 'Vera:weight=200';
lives-ok {$match = $patt.match()};
ok $match.defined;
is $match.file.IO.relative, "t/fonts/VeraBd.ttf";
is $match.style, 'Bold';
is $match.weight, 200;

done-testing;

