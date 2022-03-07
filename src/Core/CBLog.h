#pragma once

#include <Foundation/NSObjCRuntime.h> // For NSLog

#define CBL_DEBUG
#define CBL_ERROR


#ifdef CBL_ERROR
#define CBLError(...) NSLog(__VA_ARGS__)
#define CBLCoreError(...) NSLog(__VA_ARGS__)
#else
#define CBLError(...)
#define CBLCoreError(...)
#endif

#ifdef CBL_DEBUG
#define CBLog(...) NSLog(__VA_ARGS__)
#else
#define CBLog(...)
#endif