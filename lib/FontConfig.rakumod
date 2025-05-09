# Base class for FontConfig Patterns and Matches
unit class FontConfig:ver<0.1.8>;

use FontConfig::Raw;
use FontConfig::Defs :enums;
use NativeCall;

has FcConfig $!config;
method !config { $!config //= FcConfig::load(); }

has FcPattern:D $.pattern handles<elems format Str> = FcPattern::create();
has Bool $.configured is built;
has %!store;

submethod TWEAK(:$configure, :pattern($), :all($), :best($), *%props) {
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
        self!config.substitute($!pattern, FcMatchPattern);
        $!pattern.substitute();
        %!store = ();
        True;
    }
    self!config;
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

multi method ASSIGN-KEY(Str() $key, Str:D $name where FcObjectType::get-object-type($key).type == FcTypeInteger|FcTypeBool|FcTypeRange) {
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

method Hash handles<keys values pairs EXISTS-KEY>{
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

        for %!store.keys.grep({.ends-with("lang") and .chars > 4}) -> $lang-prop {
            my $base-prop = $lang-prop.substr(0, *-4);
            my %map;
            for %!store{$lang-prop}.pairs {
                %map{.value}.push: %!store{$base-prop}[.key];
            }
            %!store{$lang-prop} = %map;
        }
    }
    %!store;
}

my constant %PropTypes = %(
    :antialias(Bool), :aspect(Num), :autohint(Bool), :capability(Str),
    :charset(FcCharSet), :color(Bool), :decorative(Bool), :dpi(Num),
    :embeddedbitmap(Bool), :embolden(Bool), :family(Str),
    :familylang(Hash), :file(Str), :fontfeatures(Str),
    :fontformat(Str), :fontvariations(Str), :fontversion(Int),
    :foundry(Str), :ftface(Pointer), :fullname(Str),
    :fullnamelang(Hash), :globaladvance(Bool), :hash(Str),
    :hinting(Bool), :hintstyle(Int), :index(Int), :lang(Str),
    :lcdfilter(Int), :matrix(FcMatrix), :minspace(Bool), :namelang(Hash), :outline(Bool),
    :pixelsize(Num), :postscriptname(Str), :prgname(Str),
    :rasterizer(Str), :rgba(Int), :scalable(Bool), :scale(Num),
    :size(Range), :slant(Int), :source(Str), :spacing(Int),
    :style(Str), :stylelang(Hash), :symbol(Bool), :variable(Bool),
    :verticallayout(Bool), :weight(Int), :width(Int)
);

method AT-KEY(Str:D() $k) {
    self.Hash{$k} // %PropTypes{$k}
}

method match(|c) # is DEPRECATED<Font::Config::Pattern.match>
{
    (require FontConfig::Pattern).new(:$!pattern).match: |c;
}

method parse(|c) is hidden-from-backtrace is DEPRECATED<FontConfig::Pattern.parse> {
    (require FontConfig::Pattern).parse: |c;
}

multi method FALLBACK(FontConfig:D: $prop where FcObjectType::get-object-type($prop).type != FcTypeUnknown) is rw {
    Proxy.new(
        FETCH => { self.AT-KEY($prop); },
        STORE => -> $, $v is raw { self.ASSIGN-KEY($prop, $v) }
    );
}

multi method FALLBACK(\name, |) {
    die X::Method::NotFound.new( :method(name), :typename(self.^name));
}

INIT FontConfig::Raw::init();

=begin pod

=head2 Description

L<FontConfig> is the base class for L<FontConfig::Pattern> (queries) and L<FontConfig::Match> (matches).

=head2 Font Properties

Common font properties include:

=begin table
Field | Values / Constants | Description
====================================
family | Str | Font family names
familylang | Hash | Family names by language code
style | Str | Font style. Overrides weight and slant
stylelang | Str | Styles by language code
fullname | Str |  Font full names (often includes style)
fullnamelang| Hash |  Fullnames by language code
slant | Int / roman=0, italic=100, oblique=110 | Slant of glyphs
weight | Int / thin=0, extralight=40, ultralight=40, light=50 demilight=55 book=70 regular=80 normal=80 medium=100 demibold=180 bold=200 extrabold=205 black=210 extrablack=215 | Weight of glyphs
size | Range | Point size
width | Int / ultracondensed=50, extracondensed=63, condensed=75, semicondensed=87, normal=100, semiexpanded=113, expanded=125, extraexpanded=150, ultraexpanded=200 | Width of glyphs
pixelsize | Num | Pixel size
spacing | Int / proportional=0, dual=90, mono=100, charcell=110 | Spacing between glyphs
foundry | Str | Font foundry name
antialias | Bool | Whether glyphs can be antialiased
hinting | Bool | Whether the rasterizer uses hinting
file | Str | The filename holding the font
outline | Bool | Whether the glyphs are outlines
charset | CharSet | Unicode chars encoded by the font
color | Bool | Whether any glyphs have color
fontformat | Str | E.g. 'CFF', 'TrueType', 'Type 1'
fontversion | Int | Version number of the font
postscriptname | Str | Font postscript name
scalable | Bool | Whether glyphs can be scaled
=end table

The full list of properties is extensive and implementation dependant. For more properties,

=item see [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html), which lists many properties.

=item The C<query-info> method returns a pattern with all suported properties for a given face

=item FontConfig command-line tools such as [fc-query](https://linux.die.net/man/1/fc-query) and [fc-match](https://linux.die.net/man/1/fc-match) can be used to query fonts and properties.

=head2 Methods

=head3 constant

=for code :lang<raku>
method constant(Str $name --> UInt)

Fontconfig has symbolic constants for numeric properties. For example, in the pattern: `Ariel;weight=bold`, `bold`,
evaluates to 200. The `constant()` method can be used to look-up these constants.

    my \bold = FontConfig.constant("bold"); # 200
    if $match<bold> >= bold {
        say "matching font is bold";
    }

Note that the Raku bindings resolve symbolic constants when a string is assigned
to a numeric property. So:

=for code :lang<raku>
$match<weight> = "extrabold";

Is equivalent to:

=for code :lang<raku>
$match<weight> = FontConfig.constant("extrabold");

=head3 query-ft-face

=for code :lang<raku>
method query-ft-face(Pointer() $face, Str() :$file, UInt :$id --> FontConfig)

This method computes a FontConfig pattern based on the attributes of an existing
FreeType font. It can be used to discover FontConfig attributes for a specific font.

The match() method will find the best font, reachable by FontConfig's configuration,
that matches the original font, which may or may not be the original font.

**The following example requires installation of the `Font::FreeType` module.**

    =begin code :lang<raku>
    use FontConfig;
    use Font::FreeType;
    my $file = "t/fonts/Vera.ttf";
    my Font::FreeType::Face $face = Font::FreeType.face($file);
    my FontConfig $patt .= query-ft-face($face, :$file);
    say $patt.fullname; # Bitstream Vera Sans
    say $patt.file;     # t/fonts/Vera.ttf
    say $patt.weight;   # 80
    =end code

=head3 AT-KEY, ASSIGN-KEY, keys, elems, pairs, values

    =begin code :lang<raku>
    $patt<weight> = 205;
    $patt<weight> = 'bold';
    say $patt<weight>;
    $patt<weight>:delete;
    =end code

This class provides am associative interface to [FontConfig properties](https://www.freedesktop.org/software/fontconfig/fontconfig-user.html).

Numeric values in the pattern may be set to ranges:

=for code :lang<raku>
$patt<weight> = 195..205;

Values may also hold a list, such as a list of font families:

=for code :lang<raku>
$patt<family> = <Arial sans>;

=head3 Str

The Str method serializes a pattern to a string representation;

=for code :lang<raku>
say $patt.Str; # Arial,sans:style=italic:weight=205

=head3 version

=for code :lang<raku>
method version returns Version

This method returns the installed fontconfig library version. Please note that
the minimum supported version is `v2.13.1`.

=end pod
