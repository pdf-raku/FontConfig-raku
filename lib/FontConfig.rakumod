unit class FontConfig:ver<0.0.1>;

use FontConfig::Raw;
use FontConfig::Defs :enums;
use NativeCall;

our $config = FcConfig::load();

has FcPattern:D $.pattern handles<elems format Str> = FcPattern::create();
has Bool $!configured;
has %!store;

submethod TWEAK(:$configure, :pattern($), *%props) {
    self.configure if $configure;
    self{.key} = .value for %props;
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

method constant(Str $name) {
    if FcName::constant($name, my int32 $val) {
        $val
    }
    else {
        fail "unknown '$name' FontConfig constant";
    }
}

multi method ASSIGN-KEY(Str() $key, Str:D $name where FcName::object($key).type == FcTypeInteger|FcTypeBool|FcTypeRange) {
    # named numeric constant, e.g. 'bold'
    if FcName::constant($name, my int32 $val) {
        self.ASSIGN-KEY($key, $val)
    }
    else {
        fail "unknown named constant '$key'";
    }
}
multi method ASSIGN-KEY(Str() $key, FcValue() $val) {
    my $v := $val();
    %!store{$key} = $v if %!store;
    $!pattern.del($key);
    $!pattern.add($key, $val, False)
        if $v.defined;
    $v;
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

multi method FALLBACK(FontConfig:D: $prop where FcName::object($prop).type != FcTypeUnknown) is rw {
    Proxy.new(
        FETCH => { self.AT-KEY($prop); },
        STORE => -> $, $v is raw { self.ASSIGN-KEY($prop, $v) }
    );
}

INIT FontConfig::Raw::init();
