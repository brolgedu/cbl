#import "cblpch.h"
#import "CBLEvents.h"

#import "Core/Core.h"
#import <thread>

@implementation CBLEvents
- (id)init {
    // mEvent = [CGEventTap];
}

- (const char *)GetKeyEvent:(const char*) key {
    // return CGEventSourceKeyState(mEventSourceStateID, key);
    return nullptr;
}

- (const char *)PollEvents {
    unsigned int wait_time_ms = 400;
    unsigned int cycle = 4;
    unsigned int sleep = wait_time_ms / cycle;

    for (unsigned int i = 0; i < cycle; ++i) {
        // if (GetKeyEvent(key)) {
        //     return true;
        // }
        std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
    }
    // return false;
    return nullptr;
}

@end