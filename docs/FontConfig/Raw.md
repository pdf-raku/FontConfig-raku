[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[FontConfig Module]](https://pdf-raku.github.io/FontConfig-raku)
 / [FontConfig](https://pdf-raku.github.io/FontConfig-raku/FontConfig)
 :: [Raw](https://pdf-raku.github.io/FontConfig-raku/FontConfig/Raw)

module FontConfig::Raw
----------------------

Native FontConfig Raku bindings

class FontConfig::Raw::FcRange
------------------------------

An FcRange holds an integer or numeric range between two values

class FontConfig::Raw::FcValue
------------------------------

An FcValue object holds a single value with one of a number of different types. The 'type' attribute indicates which member is valid.

class FontConfig::Raw::FcObjectType
-----------------------------------

marks the type of a pattern element generated when parsing font names. Applications can add new object types so that font names may contain the new elements.

class FontConfig::Raw::FcPattern
--------------------------------

An FcPattern holds a set of names with associated value lists; each name refers to a property of a font. FcPatterns are used as inputs to the matching code as well as holding information about specific fonts. Each property can hold one or more values; conventionally all of the same type, although the interface doesn't demand that. An FcPatternIter is used during iteration to access properties in FcPattern.

class FontConfig::Raw::FcFontSet
--------------------------------

An FcFontSet contains a list of FcPatterns. Internally fontconfig uses this data structure to hold sets of fonts. Externally, fontconfig returns the results of listing fonts in this format. 'nfont' holds the number of patterns in the 'fonts' array; 'sfont' is used to indicate the size of that array.

class FontConfig::Raw::FcConfig
-------------------------------

holds a complete configuration of the library; there is one default configuration, other can be constructed from XML data structures. All public entry points that need global data can take an optional FcConfig* argument; passing 0 uses the default configuration. FcConfig objects hold two sets of fonts, the first contains those specified by the configuration, the second set holds those added by the application at run-time. Interfaces that need to reference a particular set use one of the FcSetName enumerated values.

