#import "CBLFileSystem.h"

#import "Core/Core.h"
#import "Core/CBLog.h"

#import <Foundation/Foundation.h>

@implementation CBLFileSystem

- (id)init {
    @autoreleasepool {
        self = [super init];

        // Initialize variables
        mDateFormatter = [[NSDateFormatter alloc] init];
        mFileManager = [NSFileManager defaultManager];
        mFileHandle = [[NSFileHandle alloc] init];

        [self SetDefaultDirectory];
        [self SetDefaultFileNameAndPath];

        // Create file
        CBLAssert([self CreateFileAtDefaultPath], @"[CreateFileAtDefaultPath]: Error creating file!");

        return self;
    }
}

- (void)dealloc {
}

- (NSString *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, domainMask, YES);
    if (paths.count == 0) { return nil; }

    NSString *path = [paths objectAtIndex:0];
    CBLog(@"[PathForDirectory] path: %@", path);
    return [NSString stringWithUTF8String:path.fileSystemRepresentation];
}

- (NSString *)GetFilePath {
    return mFilePath;
}

- (bool)SetFilePath:(NSString *)filepath {
    if (!filepath) { return false; }
    mFilePath = [filepath mutableCopy];
    CBLog(@"[SetFilePath]: %@", mFilePath);
    return true;
}

- (NSString *)GetFileName {
    return mFileName;
}

- (void)SetDefaultDirectory {
    NSString *cblFolder = @"cbl";
    NSString *cblHistoryFolder = @"history";

    // Create file directory tree
    mAppSupportDirectory = [[self NSGetPathForDirectory:NSApplicationSupportDirectory :NSUserDomainMask] mutableCopy];
    mCBLDirectory = [[NSString stringWithFormat:@"%@/%@", mAppSupportDirectory, cblFolder] mutableCopy];
    mCBLHistoryDirectory = [[NSString stringWithFormat:@"%@/%@", mCBLDirectory, cblHistoryFolder] mutableCopy];
}

- (void)SetDefaultFileNameAndPath {
    // Create filename appended with current date
    [mDateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *currentDate = [mDateFormatter stringFromDate:[NSDate now]];

    NSString *filename = [NSString stringWithFormat:@"cbl-%@.txt", currentDate];
    [self SetFileName:filename];

    NSString *filepath = [NSString stringWithFormat:@"%@/%@", mCBLHistoryDirectory, mFileName];
    [self SetFilePath:filepath];
}

- (bool)SetFileName:(NSString *)filename {
    if (!filename) { return false; }
    mFileName = [filename mutableCopy];
    CBLog(@"[SetFileName]: %@", mFileName);
    return true;
}

- (bool)OpenFileAtPath:(NSString *)filepath {
    if (!filepath) { return false; }
    [self SetFilePath:filepath];
    mFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:mFilePath];
    mFileContentsLength = [mFileHandle seekToEndOfFile];
    [mFileHandle seekToFileOffset:0];
    return true;
}

- (ul)GetFileContentsLength {
    return mFileContentsLength;
}

- (bool)FileExistsAtPath:(NSString *)filepath {
    return [mFileManager fileExistsAtPath:filepath];
}

/* If directoryPath has a file extension, then remove the file extension
 * and name from the path to get the directory */
- (NSString *)GetDirectoryPath:(NSString *)filepath {
    char *directoryPath = (char *) [filepath UTF8String];
    uint idx = filepath.length - 1;
    bool done = false;

    while (idx != 0 && !done) {
        switch (directoryPath[idx]) {
            case '/':done = true;
                break;
            case '.':
                while (idx > 0 && !done) {
                    --idx;
                    if (directoryPath[idx] == '/') {
                        directoryPath[idx] = '\0';
                        done = true;
                    }
                }
        }
        --idx;
    }
    return [NSString stringWithCString:directoryPath encoding:NSUTF8StringEncoding];
}

- (bool)CreateDirectoryAtPath:(NSString *)directoryPath {
    if (!directoryPath) { return false; }

    if (![self FileExistsAtPath:directoryPath]) {
        NSError *error = nil;
        [mFileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            CBLog(@"[CreateDirectoryAtPath]: error creating directory: %@", error);
            return false;
        }
    } else {
        CBLog(@"[CreateDirectoryAtPath]: directory already exists!");
    }
    return true;
}

- (NSString *)GetContentsOfFileAtPath:(NSString *)filepath {
    if (![self FileExistsAtPath:filepath]) {
        CBLog(@"[GetContentsOfFileAtPath]: File not found!");
        return nil;
    }
    NSData *utf8data = [[NSData alloc] initWithContentsOfFile:filepath];
    return [[NSString alloc] initWithData:utf8data encoding:NSUTF8StringEncoding];
}

- (bool)CreateFileAtPathWithContents:(NSString *)directoryPath :(NSString *)filename :(NSString *)contents {
    if (![self CreateDirectoryAtPath:directoryPath]) { return false; }

    NSString *filepath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", filename]];
    return [self CreateFileAtPathWithContents:filepath :contents];
}

- (bool)CreateFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    bool success = false;

    if (!filepath) {
        CBLog(@"[CreateFileAtPathWithContents] Invalid filepath!");
    } else if ([self FileExistsAtPath:filepath]) {
        CBLog(@"[CreateFileAtPathWithContents] file already exists!");
        success = true;
    } else {
        NSString *directoryPath = [self GetDirectoryPath:filepath];
        if (![self CreateDirectoryAtPath:directoryPath]) {
            CBLog(@"[CreateFileAtPathWithContents] Failed to create directory!");
            return false;
        }

        NSData *dataToWrite = [self GetDataFromContents:contents];
        success = [mFileManager createFileAtPath:filepath contents:dataToWrite attributes:nil];
        if (success) {
            mLengthOfLastWrite = dataToWrite ? dataToWrite.length : 0;
            mFileContentsLength = mLengthOfLastWrite;
            CBLog(@"[CreateFileAtPathWithContents] file created successfully!");
        } else {
            CBLog(@"[CreateFileAtPathWithContents] file creation failed!");
        }

        // Update class members
        if (![self OpenFileAtPath:(filepath)]) {
            CBLog(@"[CreateFileAtPathWithContents] Could not open file!");
        }
    }
    return success;
}

- (bool)CreateFileAtPath:(NSString *)filepath {
    return [self CreateFileAtPathWithContents:filepath :nil];
}

- (bool)CreateFileAtDefaultPath {
    return [self CreateFileAtPath:mFilePath];
}

// Overwrites content of file.
- (bool)OverwriteFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    NSError *error = nil;

    if (contents) {
        NSData *dataToWrite = [contents dataUsingEncoding:NSUTF8StringEncoding];

        if (![mFileManager isWritableFileAtPath:filepath]) {
            CBLog(@"[OverwriteFileAtPathWithContent] Cannot write to file!");
        } else {
            if ([self OpenFileAtPath:filepath]) {
                [self WriteData:dataToWrite];

                // This will shrink the file if data was removed
                [mFileHandle truncateFileAtOffset:dataToWrite.length];
                [mFileHandle closeFile];
            } else {
                CBLog(@"[OverwriteFileAtPathWithContent] Could not open file!");
            }
        }
    }
    return !error;
}

- (bool)WriteData:(NSData *)data {
    if (!data) { return false; }

    NSError *error = nil;
    if ([mFileHandle writeData:data error:&error]) { ;
        mLengthOfLastWrite = data.length;
        mFileContentsLength += mLengthOfLastWrite;
        CBLog(@"[WriteData] Write successful!");
    } else {
        CBLog(@"[WriteData] Error writing to file: %@", error);
        return false;
    }
    return true;
}

// Appends to contents of file.
- (bool)AppendFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    bool success = false;

    if (!filepath) {
        CBLog(@"[AppendFileAtPathWithContents]: Invalid filepath!");
    } else if ([self CreateFileAtPathWithContents:filepath :contents]) {
        if (![mFileManager isWritableFileAtPath:filepath]) {
            CBLog(@"[AppendFileAtPathWithContents]: Cannot write to file!");
        } else {
            NSData *dataToWrite = [self GetDataFromContents:contents];

            if (![self OpenFileAtPath:filepath]) {
                CBLog(@"[AppendFileAtPathWithContents] Could not open file!");
            } else {
                [mFileHandle seekToEndOfFile];
                success = [self WriteData:dataToWrite];
                [mFileHandle closeFile];
            }
        }
    }
    return success;
}

- (NSData *)GetDataFromContents:(NSString *)contents {
    if (!contents) { return nil; }
    NSString *timeStamp = [self GetTimeStamp];
    NSString *string = [self TrimString:contents];
    NSString *textToWrite = [NSString stringWithFormat:@"%@ %@", timeStamp, string];
    textToWrite = [self AppendEndline:textToWrite];

    return [textToWrite dataUsingEncoding:NSUTF8StringEncoding];
}

- (bool)RemoveTextFromFileAtPath:(NSString *)filepath :(NSString *)contents {
    // [mFileHandle truncateFileAtOffset:data.length]; // This will shrink the
    // file if data was removed
    return false;
}

// Shows file contents as contents are updated
- (void)TailFile:(NSString *)filepath {
    if (![self OpenFileAtPath:filepath]) { return; }
    [mFileHandle seekToFileOffset:(mFileContentsLength - mLengthOfLastWrite)];
    NSData *data = [mFileHandle readDataToEndOfFile];
    NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    const char *str = [contents UTF8String];
    std::cout << str << std::endl << std::flush;
}

// Not complete
- (NSString *)ReadFileStream:(NSString *)filepath {
    if ([self OpenFileAtPath:filepath]) { return nil; }
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:mFilePath];
    NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    std::cout << [self TrimString:contents] << std::endl << std::flush;
    return nil;
}

- (NSString *)TrimString:(NSString *)nsString {
    return [[nsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString *)GetTimeStamp {
    [mDateFormatter setDateFormat:@"MMM-dd-yyyy HH:mm:ss"];
    NSString *currTime = [mDateFormatter stringFromDate:[NSDate now]];
    return [NSString stringWithFormat:@"[%@]:", currTime];
}

- (NSString *)AppendEndline:(NSString *)nsString {
    return [NSString stringWithFormat:@"%@\n", nsString];
}

@end
