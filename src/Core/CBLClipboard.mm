#include "CBLClipboard.h"

static PasteboardRef sMainClipboard = 0;

CBLClipboard::CBLClipboard()
        : mTextChanged(true) {
    UpdateClipboardText();
}

CBLClipboard::~CBLClipboard() {
    CFRelease(ns.CFData);
    CFRelease(ns.flavorTypeArray);
}

void CBLClipboard::SetClipboardText(const char *text) {
    if (!sMainClipboard) {
        PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
    }

    PasteboardClear(sMainClipboard);
    ns.CFData = CFDataCreate(kCFAllocatorDefault, (const UInt8 *) text, strlen(text));
    if (ns.CFData) {
        PasteboardPutItemFlavor(sMainClipboard, (PasteboardItemID) 1, CFSTR("public.utf8-plain-text"),
                                ns.CFData, 0);
        CFRelease(ns.CFData);
    }
}

bool CBLClipboard::UpdateClipboardText() {
    if (!sMainClipboard) {
        PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
    }

    PasteboardSynchronize(sMainClipboard);
    PasteboardGetItemCount(sMainClipboard, &ns.itemCount);
    for (ItemCount i = 0; i < ns.itemCount; i++) {
        ns.itemId = 0;
        PasteboardGetItemIdentifier(sMainClipboard, i + 1, &ns.itemId);

        ns.flavorTypeArray = 0;
        PasteboardCopyItemFlavors(sMainClipboard, ns.itemId, &ns.flavorTypeArray);

        mTextChanged = false;
        for (CFIndex j = 0, nj = CFArrayGetCount(ns.flavorTypeArray); j < nj; j++) {
            if (PasteboardCopyItemFlavorData(sMainClipboard, ns.itemId, CFSTR("public.utf8-plain-text"),
                                             &ns.CFData) == noErr) {
                mClipboardHandlerData.clear();
                int length = (int) CFDataGetLength(ns.CFData);
                mClipboardHandlerData.resize(length + 1);
                CFDataGetBytes(ns.CFData, CFRangeMake(0, length), (UInt8 *) mClipboardHandlerData.data());
                mClipboardHandlerData[length] = 0;
                CFRelease(ns.CFData);

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

const char *CBLClipboard::GetClipboardText() {
    return mClipboardText.data();
}

const unsigned long CBLClipboard::GetItemCount() {
    return ns.itemCount;
}

const char CBLClipboard::GetKeyEvent(const char key) {
    return CGEventSourceKeyState(ns.eventSourceStateID, key);
}

