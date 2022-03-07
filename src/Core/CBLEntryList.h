#pragma once

#include "CBLEntryNode.h"

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLEntryList : NSObject {
    std::vector<CBLEntryNode *> mEntryNodes;
}
enum ContentsType {
    CT_Text, CT_Button, CT_SmallButton, CT_FillButton, CT_Selectable, CT_SelectableSpanRow
};
- (id)init;

- (bool)AddNodeToEntries:(CBLEntryNode *)entryNode;

- (int)GetSize;
+ (CBLEntryList *)GetEntryList;
- (std::vector<CBLEntryNode *>)GetNodes;
- (CBLEntryNode *)GetEntryAtIndex:(int)index;

- (void)ShowTable;
- (void)PopulateTable;
- (void)SortEntries;

@end

#ifdef __cplusplus
}
#endif


