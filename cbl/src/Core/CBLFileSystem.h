#pragma once

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
    NSFileManager *mFileManager;
    NSFileHandle *mFileHandle;
    NSDateFormatter *mDateFormatter;

    NSMutableString *mFilePath;
    NSMutableString *mFileName;

    NSMutableString *mCBLDirectory;
    NSMutableString *mAppSupportDirectory;
    NSMutableString *mCBLHistoryDirectory;

    ul mFileContentsLength;
    ul mLengthOfLastWrite;
}

- (id)init;
- (void)dealloc;

- (void)SetDefaultDirectory;
- (void)SetDefaultFileNameAndPath;
- (bool)SetFileName:(NSString *)filename;
- (bool)SetFilePath:(NSString *)filepath;

- (NSString *)GetFilePath;
- (NSString *)GetFileName;
- (NSString *)GetDirectoryPath:(NSString *)filepath;
- (NSString *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask;
- (bool)CreateDirectoryAtPath:(NSString *)directoryPath;

- (bool)CreateFileAtDefaultPath;
- (bool)CreateFileAtPath:(NSString *)filepath;
- (bool)CreateFileAtPathWithContents:(NSString *)filepath :(NSString *)contents;
- (bool)CreateFileAtPathWithContents:(NSString *)filepathDirectory :(NSString *)filename :(NSString *)contents;

- (bool)WriteData:(NSData *)data;
- (bool)OpenFileAtPath:(NSString *)filepath;
- (bool)FileExistsAtPath:(NSString *)filepath;
- (bool)AppendFileAtPathWithContents:(NSString *)filepath :(NSString *)contents;
- (bool)OverwriteFileAtPathWithContents:(NSString *)filepath :(NSString *)contents;

- (void)TailFile:(NSString *)filepath;
- (NSString *)ReadFileStream:(NSString *)filepath;
- (NSString *)GetContentsOfFileAtPath:(NSString *)filepath;
- (NSData *)GetDataFromContents:(NSString *)contents;

- (NSString *)GetTimeStamp;
- (NSString *)TrimString:(NSString *)nsString;
- (NSString *)AppendEndline:(NSString *)nsString;
- (ul)GetFileContentsLength;

@end

#ifdef __cplusplus
}
#endif