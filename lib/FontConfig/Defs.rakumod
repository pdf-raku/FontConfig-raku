#| Enums and constants
unit module FontConfig::Defs;
our $FC-LIB is export(:FC-LIB) = Rakudo::Internals.IS-WIN ?? 'libfontconfig' !! ('fontconfig', v1);
our $FC-BIND-LIB is export(:FC-BIND-LIB) = %?RESOURCES<libraries/fc_raku>;

constant FcBool       is export(:types) = int32;
constant FcObject     is export(:types) = int32;

enum FcMatchKind is export(:enums) <FcMatchPattern FcMatchFont FcMatchScan FcMatchKindEnd>;

enum FcResult is export(:enums) <FcResultMatch FcResultNoMatch FcResultTypeMismatch FcResultNoId FcResultOutOfMemory>;

enum FcValueBinding is export(:enums) <FcValueBindingWeak FcValueBindingStrong FcValueBindingSame>;

enum FC_ELEMENT is export(:enums) (
    :FC_FAMILY<family>,		# String
    :FC_STYLE<style>,		# String
    :FC_SLANT<slant>,		# Int
    :FC_WEIGHT<weight>,		# Int
    :FC_SIZE<size>,		# Range (double)
    :FC_ASPECT<aspect>,		# Double
    :FC_PIXEL_SIZE<pixelsize>,		# Double
    :FC_SPACING<spacing>,		# Int
    :FC_FOUNDRY<foundry>,		# String
    :FC_ANTIALIAS<antialias>,		# Bool (depends)
    :FC_HINTING<hinting>,		# Bool (true)
    :FC_HINT_STYLE<hintstyle>,		# Int
    :FC_VERTICAL_LAYOUT<verticallayout>,	# Bool (false)
    :FC_AUTOHINT<autohint>,		# Bool (false)
    # FC_GLOBAL_ADVANCE is deprecated. this is simply ignored on freetype 2.4.5 or later
    :FC_GLOBAL_ADVANCE<globaladvance>,	# Bool (true)
    :FC_WIDTH<width>,		# Int
    :FC_FILE<file>,		# String
    :FC_INDEX<index>,		# Int
    :FC_FT_FACE<ftface>,		# FT_Face
    :FC_RASTERIZER<rasterizer>,	# String (deprecated)
    :FC_OUTLINE<outline>,		# Bool
    :FC_SCALABLE<scalable>,		# Bool
    :FC_COLOR<color>,		# Bool
    :FC_VARIABLE<variable>,		# Bool
    :FC_SCALE<scale>,		# double (deprecated)
    :FC_SYMBOL<symbol>,		# Bool
    :FC_DPI<dpi>,		# double
    :FC_RGBA<rgba>,		# Int
    :FC_MINSPACE<minspace>,		# Bool use minimum line spacing
    :FC_SOURCE<source>,		# String (deprecated)
    :FC_CHARSET<charset>,		# CharSet
    :FC_LANG<lang>,		# String RFC 3066 langs
    :FC_FONTVERSION<fontversion>,	# Int from 'head' table
    :FC_FULLNAME<fullname>,		# String
    :FC_FAMILYLANG<familylang>,	# String RFC 3066 langs
    :FC_STYLELANG<stylelang>,		# String RFC 3066 langs
    :FC_FULLNAMELANG<fullnamelang>,	# String RFC 3066 langs
    :FC_CAPABILITY<capability>,	# String
    :FC_FONTFORMAT<fontformat>,	# String
    :FC_EMBOLDEN<embolden>,		# Bool - true if emboldening needed*/
    :FC_EMBEDDED_BITMAP<embeddedbitmap>,	# Bool - true to enable embedded bitmaps
    :FC_DECORATIVE<decorative>,	# Bool - true if style is a decorative variant
    :FC_LCD_FILTER<lcdfilter>,		# Int
    :FC_FONT_FEATURES<fontfeatures>,	# String
    :FC_FONT_VARIATIONS<fontvariations>,	# String
    :FC_NAMELANG<namelang>,		# String RFC 3866 langs
    :FC_PRGNAME<prgname>,		# String
    :FC_HASH<hash>,		# String (deprecated)
    :FC_POSTSCRIPT_NAME<postscriptname>,	# String
);

enum FcType is export(:enums) (
        :FcTypeUnknown(-1),
        slip <FcTypeVoid FcTypeInteger FcTypeDouble FcTypeString
              FcTypeBool FcTypeMatrix FcTypeCharSet FcTypeFTFace
              FcTypeLangSet FcTypeRange>
);
