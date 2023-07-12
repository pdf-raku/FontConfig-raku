use Test;
plan 4;
use FontConfig;
use FontConfig::Raw;
use FontConfig::Set;

constant $MinVersion = v2.13.01;
my $LibVersion = FontConfig.version;

ok $LibVersion >=  $MinVersion, "fontconfig library >= $MinVersion (minimum version)"
    or diag "** The fontconfig version ($LibVersion) is < $MinVersion. This module will not operate normally, or pass tests ***";

my FontConfig::Set $set .= match: 'Arial,sans-serif:style=italic';

ok $set.elems, 'set elems';

unless $set.elems {
    skip-rest "Can't test without set elems";
    exit 0;
}

ok $set[0]<style>, 'style defined';
ok $set[0]<file>, 'file defined';

