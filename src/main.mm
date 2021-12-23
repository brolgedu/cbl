#include "objc/objc.h"
#include "Core/CBLClipboard.h"
#include "Core/CBLFileSystem.h"

#include <iostream>
#include <thread>
#include <chrono>
#include <ctime>

class CBLFileSystem;

static const char *getCurrentTime() {
    char buffer[50];
    std::time_t seed = std::time(nullptr);
    return reinterpret_cast<const char *>(sprintf(buffer, "%s", std::asctime(std::localtime(&seed))));
}

bool pollKeyEvent(CBLClipboard &clipboard, const char key, unsigned int wait_time_ms) {
    unsigned int cycle = 4;
    unsigned int sleep = wait_time_ms / cycle;

    for (unsigned int i = 0; i < cycle; ++i) {
        if (clipboard.GetKeyEvent(key)) {
            return true;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
    }
    return false;
}

int main(int argc, char *argv[]) {
    // if (std::strcmp(argv[1], "start") == 0) { // Used to invoke the program
    CBLClipboard cb;
    CBLFileSystem *fs = fs->init;
    bool running = true;
    char escKey = 0x35;     // CGKeyCode::ESC
    const char *clipboardText = cb.GetClipboardText();
    if (![fs FileExistsAtPath:fs.GetFilePath]) {
        assert([fs CreateFileAtPath:fs.GetFilePath :getCurrentTime()]);

    }

    while (running) {
        if (cb.UpdateClipboardText()) {

        }

        // End loop if specified key is pressed
        running = !pollKeyEvent(cb, escKey, 400);

    }



    // }

}