#pragma once

#include <Foundation/NSObjCRuntime.h> // For NSLog

#ifdef CBL_DEBUG
#define CBLog(...) NSLog(__VA_ARGS__)
#define CBLError(...) NSLog(__VA_ARGS__)
#define CBLCoreError(...) NSLog(__VA_ARGS__)
#else
#define CBLog(...)
#define CBLError(...)
#define CBLCoreError(...)
#endif