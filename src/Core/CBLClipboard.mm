#import "cblpch.h"
#import "CBLClipboard.h"

#import "Core/Core.h"

#import <Foundation/Foundation.h>

@implementation CBLClipboard

static PasteboardRef sMainClipboard = nil;

- (id)init {
    mAutoreleasePool = [[NSAutoreleasePool alloc] init];

    self = [super init];
    [self UpdateClipboardText];

    return self;
}

- (void)dealloc {
    [(NSAutoreleasePool *) mAutoreleasePool release];
    CFRelease(mCFData);
    [super dealloc];
}

- (void)SetClipboardText:(const char *)text {
    if (!sMainClipboard) {
        PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
    }

    PasteboardClear(sMainClipboard);
    mCFData = CFDataCreate(kCFAllocatorDefault, (const UInt8 *) text, strlen(text));
    if (mCFData) {
        PasteboardPutItemFlavor(sMainClipboard, (PasteboardItemID) 1, CFSTR("public.utf8-plain-text"),
                                mCFData, 0);
        CFRelease(mCFData);
    }
}

- (bool)UpdateClipboardText {
    if (!sMainClipboard) {
        PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
    }

    ItemCount itemCount;
    PasteboardSynchronize(sMainClipboard);
    PasteboardGetItemCount(sMainClipboard, &itemCount);
    for (ItemCount i = 0; i < itemCount; i++) {
        mItemId = nil;
        PasteboardGetItemIdentifier(sMainClipboard, i + 1, &mItemId);

        CFArrayRef flavorTypeArray = 0;
        PasteboardCopyItemFlavors(sMainClipboard, mItemId, &flavorTypeArray);

        mTextChanged = false;
        for (CFIndex j = 0, nj = CFArrayGetCount(flavorTypeArray); j < nj; j++) {


            if (PasteboardCopyItemFlavorData(sMainClipboard, mItemId,
                                             CFSTR("public.utf8-plain-text"), &mCFData) == noErr) {
                mClipboardHandlerData.clear();
                int length = (int) CFDataGetLength(mCFData);
                mClipboardHandlerData.resize(length + 1);
                CFDataGetBytes(mCFData, CFRangeMake(0, length), (UInt8 *) mClipboardHandlerData.data());
                mClipboardHandlerData[length] = 0;
                CFRelease(mCFData);

                if (mClipboardText != mClipboardHandlerData) {
                    mClipboardText = mClipboardHandlerData;
                    mTextChanged = true;
                }

                return mTextChanged;
            }
        }
    }


    return mTextChanged;
}

- (const char *)GetClipboardText {
    return mClipboardText.data();
}

- (const char)GetKeyEvent:(const char)key {
    return CGEventSourceKeyState(mEventSourceStateID, key);
}

@end