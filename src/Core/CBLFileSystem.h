#pragma once

#import <Foundation/NSPathUtilities.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSFileHandle.h>

#ifdef __cplusplus
extern "C" {
#endif

@interface CBLFileSystem : NSObject {
@private
    void *mAutoreleasePool;
    const char* mFilePath;
}

- (id)init;
- (void)dealloc;

- (const char *)GetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask;
- (const char*)GetFilePath;
- (const char *)CreateFileAtPath:(const char *)filePathDirectory :(const char *)fileName :(const char *)fileType :(const char *)data;

- (BOOL)FileExistsAtPath:(const char*)filePath;
- (BOOL)CreateDirectoryAtPath:(const char *)directoryPath;
- (BOOL)OverwriteFileAtPath:(const char *)filePath :(const char *)data;
- (BOOL)AppendFileAtPath:(const char *)filePath :(const char *)data;
- (BOOL)RemoveTextFromFileAtPath:(const char *)filePath :(const char *)data;

- (NSData *)GetContentsOfFileAtPath:(const char *)filePath;

- (const char*)NSStringToCString:(NSString*)nsString;
- (NSString*)CStringToNSString:(const char*)cString;

@end

#ifdef __cplusplus
}
#endif