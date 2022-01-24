unit class FontConfig;

use FontConfig::Raw;
use FontConfig::Defs :enums;

our $config = FcConfig::load();

has FcPattern:D $.pattern is required handles<format Str>;
has Bool $!configured;

submethod TWEAK(:$configure) {
    self.configure if $configure;
}

method parse(Str:D $spec, |c) {
    my FcPattern:D $pattern = FcPattern::parse($spec);
    self.new: :$pattern, |c;
}

method configure {
    $!configured ||= do {
        $config.substitute($!pattern, FcMatchPattern);
        $!pattern.substitute();
        True;
    }
}

method match($obj is copy:) {
    $obj .= clone: :configure unless $!configured;
    my FcPattern $pattern = $config.font-match($obj.pattern, my int32 $result);
    # todo handle $result
    self.new: :$pattern;
}

method clone(|c) {
    my $pattern = $!pattern.clone();
    self.new: :$pattern, |c;
}

INIT FontConfig::Raw::init();
