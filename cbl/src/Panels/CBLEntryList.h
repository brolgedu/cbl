#pragma once

#include "Entity/CBLEntryNode.h"
#include "Core/CBLClipboard.h"

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
    bool SelectableWrapped(const char *label, bool selected = false, ImGuiSelectableFlags flags = 0, const float window_width = -1.0f);
}

#ifdef __cplusplus
}
#endif


