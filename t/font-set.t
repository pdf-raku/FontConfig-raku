use Test;
plan 4;
use FontConfig;
use FontConfig::Raw;
use FontConfig::Set;
constant $MinVersion = v2.13.01;

INIT FontConfig.set-config-file: 't/custom-conf.xml';

my $LibVersion = FontConfig.version;
ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version ($LibVersion) is < $MinVersion. This module will not operate normally, or pass tests ***";

my FontConfig::Set $set .= match: 'Arial,sans-serif:style=italic';

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
