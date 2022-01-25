// ** Base64 encoding / decoding **
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
/* Get prototype. */
#include "fc_raku.h"

// Raku doesn't support pass by value yet
DLLEXPORT FcBool fc_raku_pattern_add (FcPattern *p, const char *object, FcValue *value, FcBool append) {
    return FcPatternAdd (p, object, *value, append);
}

