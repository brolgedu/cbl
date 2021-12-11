#include "pbl.h"

namespace PBL {

    static PasteboardRef sMainClipboard = 0;

    PblManager::PblManager()
            : mTextChanged(true) {
        UpdateClipboardText();
    }

    PblManager::~PblManager() {
        CFRelease(ns.CFData);
        CFRelease(ns.flavorTypeArray);
    }

    bool PblManager::UpdateClipboardText() {
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
                    } else {
                        mTextChanged = false;
                    }

                    return mTextChanged;
                }
            }
        }
        return false;
    }

    const std::string PblManager::GetClipboardText() {
        return mClipboardText.data();
    }

    const unsigned long PblManager::GetItemCount() {
        return ns.itemCount;
    }

    const char PblManager::GetKeyEvent(const char key) {
        return CGEventSourceKeyState(ns.eventSourceStateID, key);
    }

} // namespace PBL


