#pragma once

#include "CBLEntryNode.h"
#include "CBLClipboard.h"

#include "imgui.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLEntryList : NSObject {
    std::vector<CBLEntryNode *> mEntryNodes;
    CBLClipboard *mClipboard;

    bool mScrollToBottom;
}
enum ContentsType {
    CT_Text, CT_Button, CT_SmallButton, CT_FillButton, CT_Selectable, CT_SelectableSpanRow
};
- (id)init;

- (CBLEntryList *)GetEntryList;

- (int)GetSize;
- (CBLEntryNode *)GetSelectedEntry;
- (std::vector<CBLEntryNode *>)GetNodes;
- (CBLEntryNode *)GetEntryAtIndex:(int)index;

- (bool)AddNodeToEntries:(CBLEntryNode *)entryNode;
- (bool)ContainsContents:(NSString *)contents;

- (void)ClearTable;
- (void)SortEntryList;
- (void)ShowEntryTable;
- (void)BuildEntryTable;
- (void)UpdateEntryList;
- (void)ClearSelectedEntries;
- (void)DeleteEntryNode:(CBLEntryNode *)entryNode;


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


