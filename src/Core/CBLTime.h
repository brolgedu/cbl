#pragma once

class CBLTime {
public:
    CBLTime();

    void Sleep(int sleep_time_ms);
    const char* GetCurrentTime();

private:
    const char* mCurrentTime;
    std::time_t mSeed;
};