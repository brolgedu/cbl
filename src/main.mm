
#include "Core/Clipboard.h"
#include "Core/FileSystem.h"

#include <iostream>
#include <thread>
#include <chrono>


bool pollKeyEvent(CBL::Clipboard &clipboard, const char key, unsigned int wait_time_ms) {
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
    std::cout << ">>> This was called from main()!\n";

    CBL::Clipboard cb;
    bool running = true;
    char escKey = 0x35;     // CGKeyCode::ESC

    while (running) {
        if (cb.UpdateClipboardText()) {
            std::cout << cb.GetClipboardText() << std::flush << std::endl;
        }

        // End loop if specified key is pressed
        running = !pollKeyEvent(cb, escKey, 400);

    }



    // }

}