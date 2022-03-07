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
    EntryNodeColumnID_Date,
    EntryNodeColumnID_Contents
};

// ============================================================
// CBLEntryNode object
// ============================================================
@interface CBLEntryNode : NSObject {
    NSString *mTimestamp;
    NSString *mContents;
    int ID;
}
- (id)init;

+ (CBLEntryNode *)CreateEntryNode:(NSString *)timestamp :(NSString *)contents;

-(NSString*)GetTimestamp;
-(NSString*)GetContents;

@end

#ifdef __cplusplus
}
#endif
