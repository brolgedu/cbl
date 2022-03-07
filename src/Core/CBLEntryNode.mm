#import "CBLEntryNode.h"

@implementation CBLEntryNode

- (id)init {
    @autoreleasepool {
        self = [super init];
        return self;
    }
}

+ (CBLEntryNode *)CreateEntryNode:(NSString *)timestamp :(NSString *)contents {
    CBLEntryNode* entryNode = [[CBLEntryNode alloc] init];
    entryNode->mTimestamp = timestamp;
    entryNode->mContents = contents;
    return entryNode;
}

-(NSString*)GetTimestamp{
    return mTimestamp;
}
-(NSString*)GetContents{
    return mContents;
}

@end