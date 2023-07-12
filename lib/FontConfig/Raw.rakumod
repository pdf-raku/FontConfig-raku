#| Native FontConfig Raku bindings
unit module FontConfig::Raw;

use FontConfig::Defs :$FC-LIB, :$FC-BIND-LIB, :$types, :enums;
use NativeCall;

class FcMatrix    is repr('CPointer') {}
class FcCharSet   is repr('CPointer') is export {}
class FcLangSet   is repr('CPointer') {}
class FcObjectSet is repr('CPointer') is export {
    our sub create(--> FcObjectSet) is native($FC-LIB) is symbol('FcObjectSetCreate') {...}
    method add(Str --> FcBool) is native($FC-LIB) is symbol('FcObjectSetAdd') {...}
}
class FcRange     is repr('CPointer') {
    our sub create-double(num64, num64 --> FcRange) is native($FC-LIB) is symbol('FcRangeCreateDouble') {...}
    our sub create-integer(int32, int32 --> FcRange) is native($FC-LIB) is symbol('FcRangeCreateInteger') {...}
    method get-double(num64 $min is rw, num64 $max is rw) is native($FC-LIB) is symbol('FcRangeGetDouble') {...}
    method clone( --> FcRange) is native($FC-LIB) is symbol('FcRangeCopy') {...}
    method destroy is native($FC-LIB) is symbol('FcRangeDestroy') {...}
    multi method COERCE(Range $_ is raw) {
        .min =~= .min.round && .max =~= .max.round
            ?? create-integer(.min.round, .max.round)
            !! create-double(.min, .max);
    }
}
class FcBinding is repr('CPointer') {}

class FcValue is repr('CStruct') is export is rw {
    has int32 $.type;
    class U is repr('CUnion') is rw {
	has Str       $!s;
        method    s { $!s }
        has int32     $.i;
        has FcBool    $.b;
        has num64     $.d;
        has FcMatrix  $.m;
        has FcCharSet $.c;
        has Pointer   $.f;
        has FcLangSet $.l;
        has FcRange   $!r;
        method    r { $!r }

        multi submethod TWEAK(Str:D :$s!) { $!s := $s }
        multi submethod TWEAK(FcRange:D :$r!) { $!r := $r }
        multi submethod TWEAK(Pointer:D :$f!) { $!f := $f }

        method get($_) {
            when FcTypeUnknown { Mu }
            when FcTypeVoid    { Any }
            when FcTypeInteger { $!i }
            when FcTypeDouble  { $!d }
            when FcTypeString  { $!s }
            when FcTypeBool    { ?$!b }
            when FcTypeMatrix  { $!m }
            when FcTypeCharSet { $!c }
            when FcTypeFTFace  { $!f }
            when FcTypeLangSet { $!l }
            when FcTypeRange   {
                $!r.get-double(my num64 $min, my num64 $max);
                $min =~= $min.Int && $max =~= $max.Int
                    ?? $min.Int .. $max.Int
                    !! $min .. $max;
            }
            default { fail "FcValue has unknown type: $_" }
        }
    };
    HAS U $.u;
    multi method store(Str  $s,    :$!type = FcTypeString)  { $!u.TWEAK(:$s) }
    multi method store(Bool $_,    :$!type = FcTypeBool)    { $!u.b = $_ }
    multi method store(Int  $_,    :$!type = FcTypeInteger) { $!u.i = $_ }
    multi method store(Numeric $_, :$!type = FcTypeDouble)  { $!u.d = $_ }
    multi method store(Range $_ is raw, :$!type = FcTypeRange)  {
        my FcRange() $r = $_;
        $!u.TWEAK(:$r);
    }
    multi method store(Pointer $f, :$!type = FcTypeFTFace ) { $!u.TWEAK(:$f) }
    multi method store($_) { fail "don't know how to set FcValue to {.WHAT.raku}"; }
    multi method COERCE($v) {
        my $obj = self.new;
        $obj.store($v);
        $obj;
    }
    method CALL-ME is rw {
        Proxy.new(
            FETCH => { $!u.get($!type) },
            STORE => -> $, $v {
                $!u.store($v);
            }
        );
    }
}

class FcName is repr('CStruct') is export {
    has Str $.object;
    has int32 $.type;

    our sub object(Str --> FcName) is native($FC-LIB) is symbol('FcNameGetObjectType') {...}
    our sub constant(Str, int32 $v is rw --> FcBool) is native($FC-LIB) is symbol('FcNameConstant') {...}
}

class FcPattern is repr('CPointer') is export {

    class Iter is repr('CStruct') {
        has Pointer $!d1;
        has Pointer $!d2;
    }
    our sub create(--> FcPattern) is native($FC-LIB) is symbol('FcPatternCreate') {...}
    our sub parse(Str --> FcPattern) is native($FC-LIB) is symbol('FcNameParse') {...}
    our sub query-ft-face(Pointer, Str, uint32, Pointer --> FcPattern) is native($FC-LIB) is symbol('FcFreeTypeQueryFace') {...}
    method substitute() is native($FC-LIB) is symbol('FcDefaultSubstitute') {...};
    method format(Str --> Str) is native($FC-LIB) is symbol('FcPatternFormat') {...};
    method Str(--> Str) is native($FC-LIB) is symbol('FcNameUnparse') {...};
    method filter(FcObjectSet $os --> FcPattern) is native($FC-LIB) is symbol('FcPatternFilter') {...}
    method add(Str, FcValue, FcBool --> FcBool) is native($FC-BIND-LIB) is symbol('fc_raku_pattern_add') {...};
    method get(Str, int32 $n, FcValue $v is rw --> FcBool) is native($FC-LIB) is symbol('FcPatternGet') {...};
    method del(Str --> FcBool) is native($FC-LIB) is symbol('FcPatternDel') {...};
    method elems(--> int32) is native($FC-LIB) is symbol('FcPatternObjectCount') {...};
    method clone(--> FcPattern) is native($FC-LIB) is symbol('FcPatternDuplicate') {...};
    method iter-start(Iter:D $iter) is native($FC-LIB) is symbol('FcPatternIterStart') {...};
    method iter-next(Iter --> FcBool) is native($FC-LIB) is symbol('FcPatternIterNext') {...};
    method iter-key(Iter --> Str) is native($FC-LIB) is symbol('FcPatternIterGetObject') {...};
    method iter-elems(Iter --> int32) is native($FC-LIB) is symbol('FcPatternIterValueCount') {...};
    method iter-value(Iter, int32 $n, FcValue:D, int32 $b is rw --> int32) is native($FC-LIB) is symbol('FcPatternIterGetValue') {...};
    method iter-del(Iter, int32 $n, --> FcBool) is native($FC-LIB) is symbol('FcPatternRemove') {...};
    method TWEAK is native($FC-LIB) is symbol('FcPatternReference') {...};
    method !destroy is native($FC-LIB) is symbol('FcPatternDestroy') {...};
    method DESTROY { self!destroy }
}

class FcFontSet is repr('CStruct') is export {
    has int32 $.nfont;
    has int32 $.sfont;
    has CArray[FcPattern] $.fonts;

    our sub create(--> ::?CLASS:D) is native($FC-LIB) is symbol('FcFontSetCreate') {...};
    method new() { create() }
    method !destroy is native($FC-LIB) is symbol('FcFontSetDestroy') {...};
    submethod DESTROY { self!destroy }
}

class FcConfig is repr('CPointer') is export {
    our sub load(--> FcConfig) is native($FC-LIB) is symbol('FcInitLoadConfigAndFonts') {...}
    method substitute(FcPattern, int32 $kind) is native($FC-LIB) is symbol('FcConfigSubstitute') {...};
    method font-match(FcPattern, int32 $result is rw --> FcPattern) is native($FC-LIB) is symbol('FcFontMatch') {...};
    method font-sort(FcPattern, FcBool $trim, FcCharSet $csp, int32 $result is rw --> FcFontSet) is native($FC-LIB) is symbol('FcFontSort') {...}
    method render-prepare(FcPattern $pat, FcPattern $font --> FcPattern) is symbol('FcFontRenderPrepare') is native($FC-LIB) {...};
    method TWEAK is native($FC-LIB) is symbol('FcConfigReference') {...};
    method !destroy is native($FC-LIB) is symbol('FcConfigDestroy') {...};
    submethod DESTROY { self!destroy }
}

our sub init(--> FcBool) is native($FC-LIB) is symbol('FcInit') {...}
our sub finish() is native($FC-LIB) is symbol('FcFini') {...}
our sub version(--> int32) is native($FC-LIB) is symbol('FcGetVersion') {...}
our sub set-config-file(Str --> int32) is native($FC-BIND-LIB) is symbol('fc_raku_set_config_file') {...};
