#pragma once

#include "pblpch.h"

#include <Carbon/Carbon.h> // Use old API to avoid need for separate .mm file

namespace PBL {

    class PblManager {
    public:
        PblManager();
        ~PblManager();

        bool UpdateClipboardText();

        const std::string GetClipboardText();
        const unsigned long GetItemCount();
        const char GetKeyEvent(const char key);

    private:
        std::vector<char> mClipboardText;
        std::vector<char> mClipboardHandlerData;
        bool mTextChanged;

    private:
        struct _PblLibraryNS {
            CGEventSourceStateID eventSourceStateID;
            CFDataRef CFData;
            CFArrayRef flavorTypeArray;
            ItemCount itemCount;
            PasteboardItemID itemId;
        };

        _PblLibraryNS ns;

    };

} // namespace PB