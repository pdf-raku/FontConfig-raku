use Test;
plan 7;
use FontConfig;
use FontConfig::Raw;
use FontConfig::Set;
constant $MinVersion = v2.13.01;

INIT FontConfig.set-config-file: 't/custom-conf.xml';

my $LibVersion = FontConfig.version;
ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version ($LibVersion) is < $MinVersion. This module will not operate normally, or pass tests ***";

my FontConfig::Set $set .= match: 'Arial,sans-serif';

is $set.elems, 2, 'set elems';

subtest 'first match', {
    given $set[0] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Roman', 'style';
        is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file';
    }
}

subtest 'second match', {
    given $set[1] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Bold', 'style';
        is .<file>.IO.relative, 't/fonts/VeraBd.ttf', 'file';
    }
}

$set .= match: 'Arial,sans-serif', :trim;

is $set.elems, 1, 'trim set elems';

subtest 'first trim match', {
    given $set[0] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Roman', 'style';
        is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file';
    }
}

subtest 'iteration', {
    my $i = 0;
    for FontConfig::Set.match('Arial,sans-serif:weight=bold') {
        if $i == 0 {
            is .<family>, 'Bitstream Vera Sans', 'family[0]';
            is .<style>, 'Bold', 'style[0]';
            is .<file>.IO.relative, 't/fonts/VeraBd.ttf', 'file[0]';
        }
        elsif $i == 1 {
            is .<family>, 'Bitstream Vera Sans', 'family[1]';
            is .<style>, 'Roman', 'style[1]';
            is .<file>.IO.relative, 't/fonts/Vera.ttf', 'fil[1]e';
        }
        $i++;
    }
    is $i, 2, 'iteration count';
}

