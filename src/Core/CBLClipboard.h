#pragma once

#include "cblpch.h"

#include <Carbon/Carbon.h> // Use old API to avoid need for separate .mm file

namespace CBL {

    class Clipboard {
    public:
        Clipboard();
        ~Clipboard();

        bool UpdateClipboardText();

        void SetClipboardText(const char *text);
        const std::string GetClipboardText();
        const unsigned long GetItemCount();
        const char GetKeyEvent(const char key);

    private:
        struct _PblLibraryNS {
            CGEventSourceStateID eventSourceStateID;
            CFDataRef CFData;
            CFArrayRef flavorTypeArray;
            ItemCount itemCount;
            PasteboardItemID itemId;
        };

    private:
        _PblLibraryNS ns;
        bool mTextChanged;
        std::vector<char> mClipboardText;
        std::vector<char> mClipboardHandlerData;

    };

} // namespace PB