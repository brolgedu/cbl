#pragma once

#ifdef CBL_DEBUG
#define CBLog(...) NSLog(__VA_ARGS__)
#else
#define CBLog(...)
#endif