#pragma once

#include "CBLTime.h"

#import <Foundation/NSPathUtilities.h>
#import <Foundation/NSFileManager.h>
#import <Foundation/NSFileHandle.h>
#import <Foundation/NSDateFormatter.h>

#import <memory>

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned long ul;
typedef unsigned int uint;

@interface CBLFileSystem : NSObject {

@private
    void *mAutoreleasePool;

    CBLTime mTime;

    NSFileManager *mFileManager;
    NSFileHandle *mFileHandle;
    NSDateFormatter *mDateFormatter;

    NSMutableString *mFilepath;
    NSMutableString *mFileName;

    NSString *mCBLDirectory;
    NSString *mAppSupportDirectory;
    NSString *mCBLHistoryDirectory;

    ul mFileContentsLength;
    ul mLengthOfLastWrite;

    uint mNumberOfEntries;
}

- (id)init;
- (void)dealloc;

- (NSString *)GetFilePath;
- (NSString *)GetDirectoryPath:(NSString *)filePath;
- (NSString *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask;

- (void)TailFile:(NSString *)filePath;
- (NSString *)ReadFileStream:(NSString *)filePath;
- (NSString *)GetContentsOfFileAtPath:(NSString *)filePath;
- (NSData *)GetDataFromContents:(NSString *)contents;

- (bool)WriteData:(NSData*) data;
- (bool)CreateDirectoryAtPath:(NSString *)directoryPath;
- (bool)CreateFileAtPathWithContents:(NSString *)filePathDirectory :(NSString *)fileName :(NSString *)contents;
- (bool)CreateFileAtPathWithContents:(NSString *)filePath :(NSString *)contents;
- (bool)CreateFileAtPath:(NSString *)filePath;
- (bool)CreateFileAtDefaultPath;

- (bool)OpenFileAtPath:(NSString *)filePath;
- (bool)FileExistsAtPath:(NSString *)filePath;
- (bool)AppendFileAtPathWithContents:(NSString *)filePath :(NSString *)contents;
- (bool)OverwriteFileAtPathWithContents:(NSString *)filePath :(NSString *)contents;

- (NSString *)GetTimeStamp;
- (NSString *)AppendEndline:(NSString *)nsString;
- (NSString *)TrimString:(NSString *)nsString;
- (ul)GetFileContentsLength;

@end

#ifdef __cplusplus
}
#endif