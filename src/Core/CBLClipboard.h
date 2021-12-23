#pragma once

#include "cblpch.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLClipboard : NSObject {

@private
    void *mAutoreleasePool;

    CGEventSourceStateID mEventSourceStateID;
    PasteboardItemID mItemId;
    CFDataRef mCFData;

    std::vector<char> mClipboardHandlerData;
    std::vector<char> mClipboardText;
    bool mTextChanged;
}

- (id)init;
- (void)dealloc;

- (bool)UpdateClipboardText;
- (void)SetClipboardText:(const char *)text;
- (const char *)GetClipboardText;
- (const char)GetKeyEvent:(const char)key;

@end

#ifdef __cplusplus
}
#endif