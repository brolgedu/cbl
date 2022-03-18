#import "CBLEntryNode.h"

@implementation CBLEntryNode

- (id)init {
    @autoreleasepool {
        self = [super init];
        mSelected = false;
        return self;
    }
}

+ (CBLEntryNode *)CreateEntryNode:(NSString *)timestamp :(NSString *)contents {
    CBLEntryNode *entryNode = [[CBLEntryNode alloc] init];
    static unsigned int id = 0;
    entryNode->mTimestamp = timestamp;
    entryNode->mContents = contents;
    entryNode->mID = id;
    ++id;
    return entryNode;
}

+ (CBLEntryNode *)CopyNode:(CBLEntryNode *)entryNode {
    return [self CreateEntryNode:entryNode->mTimestamp :entryNode->mContents];
}

- (NSString *)GetTimestamp {
    return mTimestamp;
}

- (NSString *)GetContents {
    return mContents;
}

- (unsigned int)GetID {
    return mID;
}

- (unsigned int)GetContentsLength {
    return [mContents length];
}

- (void)SetSelected:(bool)selected {
    mSelected = selected;
}

- (bool)IsSelected {
    return mSelected;
}

- (bool)IsEqualID:(CBLEntryNode *)entryNode {
    return mID == entryNode.GetID;
}

@end