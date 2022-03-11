#pragma once

#include "CBLEntryNode.h"
#include "CBLClipboard.h"

#include "imgui.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLEntryList : NSObject {
    std::vector<CBLEntryNode *> mEntryNodes;
    CBLClipboard* mClipboard;

    ImVector<CBLEntryNode*> mSelection;
}
enum ContentsType {
    CT_Text, CT_Button, CT_SmallButton, CT_FillButton, CT_Selectable, CT_SelectableSpanRow
};
- (id)init;

- (CBLEntryList *)GetEntryList;

- (bool)AddNodeToEntries:(CBLEntryNode *)entryNode;
- (CBLEntryNode *)GetEntryAtIndex:(int)index;
- (std::vector<CBLEntryNode *>)GetNodes;
- (int)GetSize;

- (void)ShowTable;
- (void)PopulateTable;
- (void)SortEntries;
- (void)UpdateList;

// TEST ONLY
- (void)PopulateRandomEntries;

@end

// Custom ImGui functions
namespace ImGui {
    void SelectableWrapped();
}

#ifdef __cplusplus
}
#endif


