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
    entryNode->mTimestamp = timestamp;
    entryNode->mContents = contents;
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

- (unsigned int)GetContentsLength {
    return [mContents length];
}

- (bool)IsSelected {
    return mSelected;
}

@end