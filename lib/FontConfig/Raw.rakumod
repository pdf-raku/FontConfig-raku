#| Native FontConfig Raku bindings
unit module FontConfig::Raw;

use FontConfig::Defs :$FC-LIB, :$types, :enums;
use NativeCall;

class FcPattern is repr('CPointer') is export {
    our sub parse(Str --> FcPattern) is native($FC-LIB) is symbol('FcNameParse') {...}
    method substitute() is native($FC-LIB) is symbol('FcDefaultSubstitute') {...};
    method format(Str --> Str) is native($FC-LIB) is symbol('FcPatternFormat') {...};
    method DESTROY is native($FC-LIB) is symbol('FcPatternDestroy') {...};
}
class FcConfig is repr('CPointer') is export {
    our sub load(--> FcConfig) is native($FC-LIB) is symbol('FcInitLoadConfigAndFonts') {...}
    method substitute(FcPattern, int32 $kind) is native($FC-LIB) is symbol('FcConfigSubstitute') {...};
    method font-match(FcPattern, int32 $result is rw --> FcPattern) is native($FC-LIB) is symbol('FcFontMatch') {...};
    method destroy is native($FC-LIB) is symbol('FcPatternDestroy') {...};
}

our sub init(--> FcBool) is native($FC-LIB) is symbol('FcInit') {...}
our sub finish() is native($FC-LIB) is symbol('FcFini') {...}

