#include "pblpch.h"
#include "pbl.h"

namespace PBL {

    static PasteboardRef sMainClipboard = 0;

    PblManager::PblManager() {
        Init();
    }

    void PblManager::Init() {
    }

    // OSX clipboard implementation
    // If you enable this you will need to add '-framework ApplicationServices' to your linker command-line!
    void PblManager::SetClipboardText(void *, const char *text) {
        if (!sMainClipboard) {
            PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
        }
        PasteboardClear(sMainClipboard);

        mCFData = CFDataCreate(kCFAllocatorDefault, (const UInt8 *) text, strlen(text));
        if (mCFData) {
            PasteboardPutItemFlavor(sMainClipboard, (PasteboardItemID) 1, CFSTR("public.utf8-plain-text"), mCFData, 0);
            CFRelease(mCFData);
        }
    }

    const char *PblManager::GetClipboardText(void *) {
        if (!sMainClipboard) {
            PasteboardCreate(kPasteboardClipboard, &sMainClipboard);
        }
        PasteboardSynchronize(sMainClipboard);
        PasteboardGetItemCount(sMainClipboard, &mItemCount);
        for (ItemCount i = 0; i < mItemCount; i++) {
            mItemId = 0;
            PasteboardGetItemIdentifier(sMainClipboard, i + 1, &mItemId);

            CFArrayRef flavor_type_array = 0;
            PasteboardCopyItemFlavors(sMainClipboard, mItemId, &flavor_type_array);

            for (CFIndex j = 0, nj = CFArrayGetCount(flavor_type_array); j < nj; j++) {
                if (PasteboardCopyItemFlavorData(sMainClipboard, mItemId, CFSTR("public.utf8-plain-text"), &mCFData) ==
                    noErr) {
                    mClipboardHandlerData.clear();
                    int length = (int) CFDataGetLength(mCFData);
                    mClipboardHandlerData.resize(length + 1);
                    CFDataGetBytes(mCFData, CFRangeMake(0, length), (UInt8 *) mClipboardHandlerData.data());
                    mClipboardHandlerData[length] = 0;
                    CFRelease(mCFData);

                    return mClipboardHandlerData.data();
                }
            }
        }
        return NULL;
    }


} // namespace PB

int main() {
    std::cout << ">>> This was called from main()!\n";

    PBL::PblManager m;
    // m->Run();
}
