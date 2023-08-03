use Test;
plan 3;
use FontConfig::Match;
use FontConfig::Pattern;
require ::('Font::FreeType');
CATCH {
    when X::CompUnit::UnsatisfiedDependency {
        skip-rest 'Font::FreeType needs to be installed to test query-ft-face()';
        exit 0;
    }
}

my $file = "t/fonts/Vera.ttf";
my $face = ::('Font::FreeType').face($file);

my FontConfig::Pattern $patt;
lives-ok {$patt .= query-ft-face($face, :$file);}

subtest 'query-ft-face() pattern attributes', {
    for (
        :family("Bitstream Vera Sans"), :file<t/fonts/Vera.ttf>,
        :fullname("Bitstream Vera Sans"),
        :postscriptname<BitstreamVeraSans-Roman>,
        :outline(True), :scalable(True), :slant(0), :style<Roman>,
        :weight(80e0), :width(100e0),
    ) {
        is-deeply $patt{.key}, .value, "pattern '$_' attribute";
    }
    is-deeply $patt<stylelang><en>, ['Roman'];
    is-deeply $patt<familylang><en>, ['Bitstream Vera Sans'];
}
    
my FontConfig::Match $match;
lives-ok {$match = $patt.match()};

done-testing;
