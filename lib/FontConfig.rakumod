unit class FontConfig;

use FontConfig::Raw;
use FontConfig::Defs :enums;
use NativeCall;

our $config = FcConfig::load();

has FcPattern:D $.pattern is required handles<elems format Str>;
has Bool $!configured;
has %!store;

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
        %!store = ();
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

method ASSIGN-KEY(Str() $key, FcValue() $val) {
    %!store{$key} = $val() if %!store;
    $!pattern.add($key, $val, False); 
}

method DELETE-KEY(Str:D $key) {
    self.Hash unless %!store;
    my $v := %!store{$key}:delete;
    $!pattern.del($key);
    $v;
}

method Hash handles<keys values pairs AT-KEY EXISTS-KEY>{
    unless %!store {
        my FcValue $value .= new;
        my FcPattern::Iter $iter .= new;
        $!pattern.iter-start: $iter;
        my int32 $binding;

        repeat {
            my $key := $!pattern.iter-key($iter);
            my $elems := $!pattern.iter-elems($iter);
            if $elems == 1 {
                $!pattern.iter-value($iter, 0, $value, $binding);
                %!store{$key} = $value();
            }
            else {
                my @values = (0 ..^ $elems).map: -> \id {
                    $!pattern.iter-value($iter, id, $value, $binding);
                    $value();
                }
                %!store{$key} = @values;
            }
        } while $!pattern.iter-next: $iter;
    }
    %!store;
}

INIT FontConfig::Raw::init();
