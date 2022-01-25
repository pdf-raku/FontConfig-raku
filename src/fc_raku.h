#ifndef __FC_RAKU_H
#define __FC_RAKU_H

#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT extern
#endif

#include <fontconfig/fontconfig.h>

DLLEXPORT FcBool fc_raku_pattern_add (FcPattern *p, const char *object, FcValue *value, FcBool append);

#endif /* __FC_RAKU_H */
