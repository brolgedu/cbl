#pragma once

#import "cblpch.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLEvents : NSObject {
@private
    CFMachPortRef mEvent;
    CGEventSourceStateID mEventSourceStateID;
    char *mLastKeyPressed;
}

- (id)init;

- (const char *)PollEvents;
- (const char *)GetKeyEvent:(const char)key;

@end

#ifdef __cplusplus
}
#endif
