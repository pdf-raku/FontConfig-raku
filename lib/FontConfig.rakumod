unit class FontConfig;

use FontConfig::Raw;
use FontConfig::Defs :enums;

our $config = FcConfig::load();

has FcPattern:D $.pattern is required handles<format>;

method parse(Str:D $spec) {
    my FcPattern:D $pattern = FcPattern::parse($spec);
    $config.substitute($pattern, FcMatchPattern);
    $pattern.substitute();
    my FcPattern $font = $config.font-match($pattern, my int32 $result);
    self.new: :pattern($font);
}

INIT FontConfig::Raw::init();

method Str {
    $!pattern.file;
}
