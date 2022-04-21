// ** Base64 encoding / decoding **
#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
/* Get prototype. */
#include "fc_raku.h"

// Raku doesn't support pass by value yet
DLLEXPORT FcBool fc_raku_pattern_add (FcPattern *p, const char *object, FcValue *value, FcBool append) {
    return FcPatternAdd (p, object, *value, append);
}

// Just because Rakudo's %*ENV only affects child processes, so
// setting %*ENV<FONTCONFIG_FILE> isn't enough
DLLEXPORT int fc_raku_set_config_file (char* value) {
    int overwrite = 1;
    value = strdup(value);
    return setenv("FONTCONFIG_FILE", value, overwrite);
}
