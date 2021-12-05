#pragma once

#include <vector>

#include <Carbon/Carbon.h> // Use old API to avoid need for separate .mm file

#include <hid/IOHIDManager.h>

namespace PBL {

    typedef struct _PblLibraryNS {
        CGEventSourceRef eventSource;
        id delegate;
        TISInputSourceRef inputSource;
        IOHIDManagerRef hidManager;
        id unicodeData;
        id helper;
        id keyUpMonitor;
        id nibObjects;

        // char keynames[GLFW_KEY_LAST + 1][17];
        short int keycodes[256];
        // short int scancodes[GLFW_KEY_LAST + 1];
        char *clipboardString;

        struct {
            CFBundleRef bundle;
            // PFN_TISCopyCurrentKeyboardLayoutInputSource CopyCurrentKeyboardLayoutInputSource;
            // PFN_TISGetInputSourceProperty GetInputSourceProperty;
            // PFN_LMGetKbdType GetKbdType;
            CFStringRef kPropertyUnicodeKeyLayoutData;
        } tis;

    } _PblLibraryNS;

    class PblManager {
    public:
        PblManager();
        void Init();

        void SetClipboardText(void *, const char *text);
        const char *GetClipboardText(void *);

    private:
        std::vector<char> mClipboardHandlerData;
        CFDataRef mCFData;
        ItemCount mItemCount = 0;
        PasteboardItemID mItemId = 0;
    };

} // namespace PB