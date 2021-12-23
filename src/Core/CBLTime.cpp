#include "CBLTime.h"

#include <ctime>
#include <chrono>
#include <thread>

CBLTime::CBLTime() {
    mSeed = std::time(nullptr);
    mCurrentTime = GetCurrentTime();
}

const char *CBLTime::GetCurrentTime() {
    static char time_buf[50];
    std::snprintf(time_buf, sizeof(time_buf), "%s", std::asctime(std::localtime(&mSeed)));
    return time_buf;
}

void CBLTime::Sleep(int sleep_time_ms) {
    std::this_thread::sleep_for(std::chrono::milliseconds(sleep_time_ms));
}

