#import "CBLFileSystem.h"
#import "cblpch.h"

#import "Core/Core.h"

#import <Foundation/Foundation.h>

@implementation CBLFileSystem

- (id)init {
    self = [super init];

    mAutoreleasePool = [[NSAutoreleasePool alloc] init];
    mFileManager = [NSFileManager defaultManager];
    mFileHandle = [[NSFileHandle alloc] init];

    mAppSupportDirectory = [self NSGetPathForDirectory:NSApplicationSupportDirectory :NSUserDomainMask];
    mCBLDirectory = [mAppSupportDirectory stringByAppendingPathComponent:@"/cbl"];
    mCBLHistoryDirectory = [mCBLDirectory stringByAppendingPathComponent:@"/history"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate now]]];
    NSString *filename = [NSString stringWithFormat:@"history-%@.txt", currentDate];
    CBLLog(@"[currentDate]: %@", currentDate);

    mFileName = [filename mutableCopy];
    mFilepath = [[mCBLHistoryDirectory stringByAppendingPathComponent:
                                               [NSString stringWithFormat:@"/%@", mFileName]] mutableCopy];
    CBLLog(@"[mFilepath]: %@", mFilepath);

    if (![self FileExistsAtPath:mFilepath]) {
        if (![self CreateFileAtDefaultPath]) {
            CBLLog(@"[CreateFileAtDefaultPath]: Error creating file!");
            return nil;
        }
    }

    return self;
}

- (void)dealloc {
    [(NSAutoreleasePool *) mAutoreleasePool release];
    [super dealloc];
}

- (NSString *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, domainMask, YES);
    if (paths.count == 0) {
        return nil;
    }
    NSString *path = [paths objectAtIndex:0];
    CBLLog(@"[PathForDirectory] path: %@", path);

    return [NSString stringWithUTF8String:path.fileSystemRepresentation];
}

- (NSString *)GetFilePath {
    return mFilepath;
}

- (bool)OpenFileAtPath:(NSString *)filepath {
    if (filepath) {
        mFilepath = [filepath mutableCopy];
        mFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:mFilepath];
        mFileContentsLength = [mFileHandle seekToEndOfFile];
        [mFileHandle seekToFileOffset:0];
        return true;
    }

    return false;
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
                break;
        }
        --idx;
    }
    return [NSString stringWithCString:directoryPath];
}

- (bool)CreateDirectoryAtPath:(NSString *)directoryPath {
    if (!directoryPath) { return false; }

    if (![self FileExistsAtPath:directoryPath]) {
        NSError *error = nil;
        [mFileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            CBLLog(@"[CreateDirectoryAtPath]: error creating directory: %@", error);
            [error release];
            return false;
        }
    } else {
        CBLLog(@"[CreateDirectoryAtPath]: directory already exists!");
    }

    return true;
}

- (NSString *)GetContentsOfFileAtPath:(NSString *)filepath {
    if (![self FileExistsAtPath:filepath]) {
        CBLLog(@"[GetContentsOfFileAtPath]: File not found!");
        return nil;
    }
    NSData *utf8data = [[NSData alloc] initWithContentsOfFile:filepath];
    return [[NSString alloc] initWithData:utf8data encoding:NSUTF8StringEncoding];
}

- (bool)CreateFileAtPathWithContents:(NSString *)directoryPath :(NSString *)fileName :(NSString *)contents {
    if (![self CreateDirectoryAtPath:directoryPath]) { return false; }

    NSString *filepath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
    return [self CreateFileAtPathWithContents:filepath :contents];
}

- (bool)CreateFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    bool success = false;

    if (!filepath) {
        CBLLog(@"[CreateFileAtPathWithContents] Invalid filepath!");
    } else if ([self FileExistsAtPath:filepath]) {
        CBLLog(@"[CreateFileAtPathWithContents] file already exists!");
        success = true;
    } else {
        NSString *directoryPath = [self GetDirectoryPath:filepath];

        if ([self CreateDirectoryAtPath:directoryPath]) {
            NSData *dataToWrite = nil;

            if (contents) {
                NSString *timeStamp = [self GetTimeStamp];
                NSString *string = [self TrimString:contents];

                NSString *textToWrite = [NSString stringWithFormat:@"%@ %@", timeStamp, string];
                textToWrite = [self AppendEndline:textToWrite];
                dataToWrite = [textToWrite dataUsingEncoding:NSUTF8StringEncoding];

                [textToWrite release];
                [string release];
            }

            // Create file
            if ([mFileManager createFileAtPath:filepath contents:dataToWrite attributes:nil]) {
                mLengthOfLastWrite = dataToWrite ? dataToWrite.length : 0;
                mFileContentsLength = mLengthOfLastWrite;
                success = true;
                CBLLog(@"[CreateFileAtPathWithContents] file created successfully!");
            } else {
                CBLLog(@"[CreateFileAtPathWithContents] file creation failed!");
            }
            [dataToWrite release];
        }

        // Update class members
        if (![self OpenFileAtPath:(filepath)]) {
            CBLLog(@"[CreateFileAtPathWithContents] Could not open file!");
        }
    }

    return success;
}

- (bool)CreateFileAtPath:(NSString *)filepath {
    return [self CreateFileAtPathWithContents:filepath :nil];
}

- (bool)CreateFileAtDefaultPath {
    return [self CreateFileAtPath:mFilepath];
}

// Overwrites content of file.
- (bool)OverwriteFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    NSError *error = nil;

    if (contents) {
        NSData *dataToWrite = [contents dataUsingEncoding:NSUTF8StringEncoding];

        if (![mFileManager isWritableFileAtPath:filepath]) {
            CBLLog(@"[OverwriteFileAtPathWithContent] Cannot write to file!");
        } else {
            if ([self OpenFileAtPath:filepath]) {
                if ([mFileHandle writeData:dataToWrite error:&error]) {
                    mLengthOfLastWrite = dataToWrite ? contents.length : 0;
                    mFileContentsLength += mLengthOfLastWrite;
                    CBLLog(@"[OverwriteFileAtPathWithContent] Write successful!");
                } else {
                    CBLLog(@"[OverwriteFileAtPathWithContent] Error writing to file: %@", error);
                    [error release];
                }

                // This will shrink the file if data was removed
                [mFileHandle truncateFileAtOffset:dataToWrite.length];
                [mFileHandle closeFile];
            } else {
                CBLLog(@"[OverwriteFileAtPathWithContent] Could not open file!");
            }
        }
        [dataToWrite release];
    }

    return !error;
}

// Appends to contents of file.
- (bool)AppendFileAtPathWithContents:(NSString *)filepath :(NSString *)contents {
    bool success = false;

    if (!filepath) {
        CBLLog(@"[AppendFileAtPathWithContents]: Invalid filepath!");
    } else if ([self CreateFileAtPathWithContents:filepath :contents]) {
        if (![mFileManager isWritableFileAtPath:filepath]) {
            CBLLog(@"[AppendFileAtPathWithContents]: Cannot write to file!");
        } else {
            NSData *dataToWrite = nil;
            if (contents) {
                NSString *timeStamp = [self GetTimeStamp];
                NSString *string = [self TrimString:contents];
                NSString *textToWrite = [NSString stringWithFormat:@"%@ %@", timeStamp, string];

                textToWrite = [self AppendEndline:textToWrite];
                dataToWrite = [textToWrite dataUsingEncoding:NSUTF8StringEncoding];

                [textToWrite release];
                [string release];
            }

            if (![self OpenFileAtPath:filepath]) {
                CBLLog(@"[AppendFileAtPathWithContents] Could not open file!");
            } else {
                [mFileHandle seekToEndOfFile];
                NSError *error = nil;

                if ([mFileHandle writeData:dataToWrite error:&error]) {
                    mLengthOfLastWrite = dataToWrite.length;
                    mFileContentsLength += mLengthOfLastWrite;
                    success = true;
                    CBLLog(@"[AppendFileAtPathWithContents] Write successful!");
                } else {
                    CBLLog(@"[AppendFileAtPathWithContents] Error writing to file: %@", error);
                    [error release];
                }

                [mFileHandle closeFile];
                [dataToWrite release];
            }
        }

    }

    return success;
}

- (bool)RemoveTextFromFileAtPath:(NSString *)filepath :(NSString *)contents {
    // [mFileHandle truncateFileAtOffset:data.length]; // This will shrink the
    // file if data was removed
    return false;
}

// Shows file contents as contents are updated
- (void)TailFile:(NSString *)filepath {
    if ([self OpenFileAtPath:filepath]) {
        [mFileHandle seekToFileOffset:(mFileContentsLength - mLengthOfLastWrite)];
        NSData *data = [mFileHandle readDataToEndOfFile];
        NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        const char *str = [contents UTF8String];
        std::cout << str << std::endl << std::flush;
    }
}

- (NSString *)ReadFileStream:(NSString *)filepath {
    if ([self OpenFileAtPath:filepath]) {
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:mFilepath];
        NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        std::cout << [self TrimString:contents] << std::endl << std::flush;
    }
}

- (NSString *)TrimString:(NSString *)nsString {
    return [[nsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString *)GetTimeStamp {
    char *time_stamp = (char *) mTime.GetCurrentTime();

    time_stamp[std::strlen(time_stamp) - 1] = '\0'; // Remove endl

    NSString *toReturn = [[NSString alloc] initWithFormat:@"[%s]:", time_stamp];

    return toReturn;
}

- (NSString *)AppendEndline:(NSString *)nsString {
    return [NSString stringWithFormat:@"%@\n", nsString];
}

@end
