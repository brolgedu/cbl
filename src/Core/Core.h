#pragma once

#ifdef CBL_DEBUG
#define CBLLog(...) NSLog(__VA_ARGS__)
#else
#define CBLLog(...)
#endif