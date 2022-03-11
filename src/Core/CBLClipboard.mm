#import "cblpch.h"
#import "CBLClipboard.h"

#import "Core/Core.h"

#import <Foundation/Foundation.h>

@implementation CBLClipboard

static PasteboardRef sMainClipboard = nil;

- (id)init {
    @autoreleasepool {
        self = [super init];
        mDateFormatter = [[NSDateFormatter alloc] init];
        [self UpdateClipboardText];
        return self;
    }
}

- (void)dealloc {
    CFRelease(mCFData);
}

- (CBLClipboard *)GetClipboard {
    if (!self) { return [[CBLClipboard alloc] init]; }
    return (CBLClipboard *) self;
}

- (void)SetClipboardText:(const char *)text {
    if (!sMainClipboard) {
        PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
    }

    PasteboardClear(sMainClipboard);
    mCFData = CFDataCreate(kCFAllocatorDefault, (const UInt8 *) text, (long) strlen(text));
    if (mCFData) {
        PasteboardPutItemFlavor(sMainClipboard, (PasteboardItemID) 1,
                                CFSTR("public.utf8-plain-text"), mCFData, 0);
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
        PasteboardGetItemIdentifier(sMainClipboard, (long) i + 1, &mItemId);

        CFArrayRef flavorTypeArray = nil;
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

- (NSString *)GetClipboardText {
    NSString *string = [NSString stringWithUTF8String:mClipboardText.data()];
    return [self TrimString:string];
}

- (NSString *)GetClipboardTextWithTimestamp:(NSString *)contents {
    if (!contents) { return nil; }
    NSString *timeStamp = [self GetTimeStamp];
    NSString *string = [self TrimString:contents];
    return [NSString stringWithFormat:@"%@ %@", timeStamp, string];
}


- (NSString *)TrimString:(NSString *)nsString {
    return [[nsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString *)GetTimeStamp {
    [mDateFormatter setDateFormat:@"MMM-dd-yyyy HH:mm:ss"];
    NSString *currTime = [mDateFormatter stringFromDate:[NSDate now]];
    return [NSString stringWithFormat:@"[%@]:", currTime];
}

@end