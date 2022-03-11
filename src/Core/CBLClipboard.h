#pragma once

#include "cblpch.h"
#import <Foundation/NSDateFormatter.h>

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLClipboard : NSObject {

@private
    PasteboardItemID mItemId;
    CFDataRef mCFData;

    std::vector<char> mClipboardHandlerData;
    std::vector<char> mClipboardText;

    NSDateFormatter *mDateFormatter;

    bool mTextChanged;
}

- (id)init;

- (CBLClipboard*)GetClipboard;

- (bool)UpdateClipboardText;
- (void)SetClipboardText:(const char *)text;
- (NSString *)GetClipboardText;
- (NSString*)GetClipboardTextWithTimeStamp;
- (NSString *)GetTimeStamp;
- (NSString *)TrimString:(NSString *)nsString;

@end

#ifdef __cplusplus
}
#endif