#pragma once

#include "CBLTime.h"

#import <Foundation/NSPathUtilities.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSFileHandle.h>

#import <memory>

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned long long ULONG;
typedef unsigned int UINT;

@interface CBLFileSystem : NSObject {

@private
    void *mAutoreleasePool;

    CBLTime mTime;

    NSFileManager *mFileManager;
    NSFileHandle *mFileHandle;

    NSMutableString *mFilePath;
    NSMutableString *mFileName;

    NSString *mCBLDirectory;
    NSString *mAppSupportDirectory;
    NSString *mCBLHistoryDirectory;

    ULONG mFileContentsLength;
    ULONG mLengthOfLastWrite;

    UINT mNumberOfEntries;
}

- (id)init;
- (void)dealloc;

- (const char *)GetFilePath;
- (const char *)GetDirectoryPath:(const char *)filePath;
- (const char *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask;

- (void)TailFile:(const char *)filePath;
- (const char *)ReadFileStream:(const char *)filePath;
- (const char *)GetContentsOfFileAtPath:(const char *)filePath;

- (bool)CreateDirectoryAtPath:(const char *)directoryPath;
- (bool)CreateFileAtPath:(const char *)filePathDirectory :(const char *)fileName :(const char *)contents;
- (bool)CreateFileAtPath:(const char *)filePath :(const char *)contents;
- (bool)CreateFileAtPath:(const char *)filePath;
- (bool)CreateFileAtDefaultPath;

- (bool)OpenFileAtPath:(const char *)filePath;
- (bool)FileExistsAtPath:(const char *)filePath;
- (bool)RemoveTextFromFileAtPath:(const char *)filePath :(const char *)contents;
- (bool)AppendFileAtPathWithContent:(const char *)filePath :(const char *)contents;
- (bool)OverwriteFileAtPathWithContent:(const char *)filePath :(const char *)contents;

- (ULONG)GetFileContentsLength;


//////////////////////////////////////////////////////////
//                  Helper Functions                    //
//////////////////////////////////////////////////////////

- (NSString *)CStringToNSString:(const char *)cString;
- (const char *)NSStringToCString:(NSString *)nsString;

- (const char*)WrapTimeStamp:(const char *)contents;
- (const char *)RemoveLeadingWhiteSpace:(const char *)contents;


@end

#ifdef __cplusplus
}
#endif