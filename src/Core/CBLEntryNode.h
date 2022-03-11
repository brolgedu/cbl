#pragma once

#include <vector>
#include <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================
// EntryNode struct and sort algorithm used for Table sorting
// ============================================================
#define IMGUI_CDECL

enum EntryNodeColumnID {
    EntryNodeColumnID_Timestamp,
    EntryNodeColumnID_Contents
};

// ============================================================
// CBLEntryNode object
// ============================================================
@interface CBLEntryNode : NSObject {
    NSString *mTimestamp;
    NSString *mContents;
    int ID;

    bool mSelected;
}
- (id)init;

+ (CBLEntryNode *)CreateEntryNode:(NSString *)timestamp :(NSString *)contents;
+ (CBLEntryNode*)CopyNode:(CBLEntryNode*) entryNode;
+ (CBLEntryNode*)GetNodeContents:(CBLEntryNode*) entryNode;

-(NSString*)GetTimestamp;
-(NSString*)GetContents;
-(unsigned int)GetContentsLength;

-(bool)IsSelected;

@end

#ifdef __cplusplus
}
#endif
