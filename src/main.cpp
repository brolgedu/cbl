#include "Core/pbl.h"

#include <iostream>
#include <thread>
#include <chrono>


bool pollKeyEvent(PBL::PblManager &manager, const char key, unsigned int wait_time_ms) {
    unsigned int cycle = 4;
    unsigned int sleep = wait_time_ms / cycle;

    for (unsigned int i = 0; i < cycle; ++i) {
        if (manager.GetKeyEvent(key)) {
            return true;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(sleep));
    }
    return false;
}

int main() {
    std::cout << ">>> This was called from main()!\n";

    PBL::PblManager m;
    bool running = true;
    char escKey = 0x35;     // CGKeyCode::ESC

    while (running) {
        if (m.UpdateClipboardText()) {
            std::cout << m.GetClipboardText() << std::flush << std::endl;
        }

        // End loop if specified key is pressed
        running = !pollKeyEvent(m, escKey, 400);

    }


}