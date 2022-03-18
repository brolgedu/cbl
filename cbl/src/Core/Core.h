#pragma once

#define CBLEnableAsserts

#if defined(__clang__)
#define DEBUG_BREAK __builtin_debugtrap()
#elif defined(_MSC_VER)
#define DEBUG_BREAK __debugbreak()
#endif

#ifdef CBLEnableAsserts
#define CBLAssert(x, ...) { if(!x) { CBLError(@"Assertion Failed: %@", __VA_ARGS__); DEBUG_BREAK; } }
#define CBLCoreAssert(x, ...) { if(!x) { CBLCoreError(@"Assertion Failed: %@", __VA_ARGS__); DEBUG_BREAK; } }
#else
#define CBLAssert(x, ...)
#define CBLCoreAssert(x, ...)
#endif