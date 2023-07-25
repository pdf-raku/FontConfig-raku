use Test;
plan 26;
use FontConfig::Match;
use FontConfig::Pattern;
use FontConfig::Raw;

constant $MinVersion = v2.13.01;
my $LibVersion = FontConfig::Pattern.version;

note "fontconfig library version: $LibVersion";
ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version ($LibVersion) is < $MinVersion. This module will not operate normally, or pass tests ***";

my FcObjectType $weight = FcObjectType::get-object-type('weight');
is $weight.object, 'weight';
my FontConfig::Pattern:D $patt .= parse: 'Arial,sans-serif:style=italic';
ok $patt.pattern.defined;
is $patt.Str, 'Arial,sans:style=italic';
is $patt.elems, 2;
is-deeply $patt.keys.sort, ("family", "style");
is-deeply $patt.family, ['Arial', 'sans'];
$patt.weight = 'bold';
is-deeply $patt.weight, 200;
$patt.weight = 200..210;
is-deeply $patt.weight, 200..210;
is-deeply $patt.aspect, Num;
warn $patt.matrix.raku;

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

my FontConfig::Match $match;
lives-ok {$match = $patt.match()};
with $match {
    ok .<weight>:exists;
    ok .<file>:exists;
    ok .<file>.defined;
    ok .file.defined;
    isa-ok .<file>, Str;
    ok .format('%{file}').IO.e, 'matched a file';
}
else {
    skip-rest "no matching fonts for: {$patt.Str}";
}

done-testing;

