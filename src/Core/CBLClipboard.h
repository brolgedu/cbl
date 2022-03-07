#pragma once

#include "cblpch.h"
#import <Foundation/NSDateFormatter.h>

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLClipboard : NSObject {

@private
    void *mAutoreleasePool;
    NSDateFormatter *mDateFormatter;

    CGEventSourceStateID mEventSourceStateID;
    PasteboardItemID mItemId;
    CFDataRef mCFData;

    std::vector<char> mClipboardHandlerData;
    std::vector<char> mClipboardText;
    bool mTextChanged;
}

- (id)init;
- (void)dealloc;

+(CBLClipboard*)GetClipboard;

- (bool)UpdateClipboardText;
- (void)SetClipboardText:(const char *)text;
- (NSString *)GetClipboardText;
// - (NSString*)GetClipboardTextWithTimeStamp;
- (NSString *)GetTimeStamp;
- (NSString *)TrimString:(NSString *)nsString;
- (const char)GetKeyEvent:(const char)key;

@end

#ifdef __cplusplus
}
#endif