use Test;
plan 7;
use FontConfig;
use FontConfig::Pattern;
use FontConfig::Match;
use FontConfig::Raw;
use FontConfig::Match::List;
constant $MinVersion = v2.13.01;

INIT FontConfig.set-config-file: 't/custom-conf.xml';

my FontConfig::Match::List:D $list .= parse: 'Arial,sans-serif';

is $list.elems, 2, 'list elems';

subtest 'first match', {
    given $list[0] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Roman', 'style';
        is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file';
    }
}

subtest 'second match', {
    given $list[1] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Bold', 'style';
        is .<file>.IO.relative, 't/fonts/VeraBd.ttf', 'file';
    }
}

$list .= parse: 'Arial,sans-serif', :trim;

is $list.elems, 1, 'trim list elems';

subtest 'first trim match', {
    given $list[0] {
        is .<family>, 'Bitstream Vera Sans', 'family';
        is .<style>, 'Roman', 'style';
        is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file';
    }
}

subtest 'list iteration', {
    my $i = 0;
    for FontConfig::Match::List.parse('Arial,sans-serif:weight=bold') {
        if $i == 0 {
            is .<family>, 'Bitstream Vera Sans', 'family[0]';
            is .<style>, 'Bold', 'style[0]';
            is .<file>.IO.relative, 't/fonts/VeraBd.ttf', 'file[0]';
        }
        elsif $i == 1 {
            is .<family>, 'Bitstream Vera Sans', 'family[1]';
            is .<style>, 'Roman', 'style[1]';
            is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file[1]';
        }
        $i++;
    }
    is $i, 2, 'iteration count';
}

subtest 'fontconfig match-list', {
    my FontConfig::Pattern $patt .= parse('Arial,sans-serif:weight=bold');
    my FontConfig::Match @matches = $patt.match-list.Seq;
    is +@matches, 2;
    given @matches[0] {
        is .<family>, 'Bitstream Vera Sans', 'family[0]';
        is .<style>, 'Bold', 'style[0]';
        is .<file>.IO.relative, 't/fonts/VeraBd.ttf', 'file[0]';
    }
    given @matches[1] {
        is .<family>, 'Bitstream Vera Sans', 'family[1]';
        is .<style>, 'Roman', 'style[1]';
        is .<file>.IO.relative, 't/fonts/Vera.ttf', 'file[1]';
    }
 
}
