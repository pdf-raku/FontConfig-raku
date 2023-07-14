unit class FontConfig:ver<0.0.4>
    does Iterable;

use FontConfig::Raw;
use FontConfig::Defs :enums;
use NativeCall;

has FcConfig $!config;
method config { $!config //= FcConfig::load(); }

has FcPattern:D $.pattern handles<elems format Str> = FcPattern::create();
has Bool $.configured is built;
has %!store;

submethod TWEAK(:$configure, :pattern($), *%props) {
    self.configure if $configure;
    self{.key} = .value for %props;
}

method query-ft-face(Pointer() $face, Str :$file, Int :$id = 0, |c) {
    my FcPattern:D $pattern = FcPattern::query-ft-face($face, $file, $id, Pointer);
     self.new: :$pattern, |c;
}

method version {
    given FontConfig::Raw::version().Str -> $s {
        # Version of the form Xyyzz
        my @v; # X, yy, ZZ
        my $i = $s.chars - 2;
        my $n = 2;
        while $i >= 0 {
            @v.unshift: $s.substr($i, $n);
            $n = $i > 1 ?? 2 !! 1;
            $i -= $n;
        }
        Version.new: @v;
    }
}

method set-config-file(IO() $path is copy) {
    $path .= absolute;
    given $path.Str {
        %*ENV<FONTCONFIG_FILE> = $_;
        FontConfig::Raw::set-config-file($_);
    }
}

method configure {
    $!configured ||= do {
        self.config.substitute($!pattern, FcMatchPattern);
        $!pattern.substitute();
        %!store = ();
        True;
    }
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

multi method ASSIGN-KEY(Str() $key, List $vals) {
    $!pattern.del($key);
    for $vals.list -> FcValue() $val {
        $!pattern.add($key, $val, True);
    }
    %!store{$key} = $vals if %!store;
    $vals;
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
    $!pattern.del($key);
    $!pattern.add($key, $val, False)
        if $v.defined;
    %!store{$key} = $v if %!store;
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
            if $elems == 0 {
            }
            elsif $elems == 1 {
                $!pattern.iter-value($iter, 0, $value, $binding);
                %!store{$key} = $value();
            }
            else {
                my @values = (^$elems).map: -> \id {
                    $!pattern.iter-value($iter, id, $value, $binding);
                    $value();
                }
                %!store{$key} = @values;
            }
        } while $!pattern.iter-next: $iter;
    }
    %!store;
}

method match(|c) is DEPRECATED<Font::Config::Pattern.match> {
    (require FontConfig::Pattern).new(:$!pattern).match: |c;
}

method parse(|c) is hidden-from-backtrace is DEPRECATED<FontConfig::Pattern.parse> {
    (require FontConfig::Pattern).parse: |c;
}

multi method FALLBACK(FontConfig:D: $prop where FcName::object($prop).type != FcTypeUnknown) is rw {
    Proxy.new(
        FETCH => { self.AT-KEY($prop); },
        STORE => -> $, $v is raw { self.ASSIGN-KEY($prop, $v) }
    );
}

multi method FALLBACK(\name, |) {
    die X::Method::NotFound.new( :method(name), :typename(self.^name));
}

INIT FontConfig::Raw::init();
