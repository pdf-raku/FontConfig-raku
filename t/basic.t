use Test;
plan 4;
use FontConfig::Match;
use FontConfig::Pattern;
use FontConfig::Raw;

constant $MinVersion = v2.13.01;
my $LibVersion = FontConfig::Pattern.version;

note "fontconfig library version: $LibVersion";
ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version ($LibVersion) is < $MinVersion. This module will not operate normally, or pass tests ***";

my FcObjectType $weight = FcObjectType::get-object-type('weight');
is $weight.object, 'weight', 'weight object';
my FontConfig::Pattern:D $patt .= parse: 'Arial,sans-serif:style=italic';

subtest 'pattern tests', {
    plan 17;
    ok $patt.pattern.defined, 'have pattern';
    is $patt.Str, 'Arial,sans:style=italic', 'stringified, initial';
    is $patt.elems, 2, 'elems';
    is-deeply $patt.keys.sort, ("family", "style"), 'pattern members, intial';
    is-deeply $patt.family, ['Arial', 'sans'], 'pattern family members';
    $patt.weight = 'bold';
    is-deeply $patt.weight, 200, 'set weight property to fixed value (bold)';
    $patt.weight = 200..210;
    is-deeply $patt.weight, 200..210, 'set weight property to range';
    is-deeply $patt.aspect, Num, 'unset value return type';

    is-deeply $patt.keys.sort, ("family", "style", "weight"), 'pattern members, after add';
    is $patt<style>, 'italic', 'associative property';
    is $patt.Str, 'Arial,sans:style=italic:weight=[200 210]', 'stringified, after add';
    $patt<weight>:delete;
    is $patt.Str, 'Arial,sans:style=italic', 'stringified, after add and associative delete';
    is-deeply $patt.keys.sort, ("family", "style"), 'pattern members, after add and delete';
    $patt.configure;
    ok $patt.elems > 2, 'pattern elems, after configure';
    isnt $patt.Str, 'Arial,sans:style=italic', 'pattern stringified, after configure';
    nok $patt<file>:exists, 'patern file property, after configure';
    nok $patt<file>.defined, 'patern file property, after configure';
}

subtest 'match tests', {
    plan 7;
    my FontConfig::Match $match;
    lives-ok {$match = $patt.match()}, 'match lives';
    with $match {
        ok .<weight>:exists, 'weight property';
        ok .<file>:exists, 'file associative property exists';
        ok .<file>.defined, 'file associative property defined';
        isa-ok .<file>, Str;
        ok .file.defined, 'file accessor';
        ok .format('%{file}').IO.e, 'matched a file';
    }
    else {
        skip-rest "no matching fonts for: {$patt.Str}";
    }
}

done-testing;

