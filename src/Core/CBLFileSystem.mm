#import "cblpch.h"
#import "CBLFileSystem.h"

#import "Core/Core.h"

#import <Foundation/Foundation.h>

@implementation CBLFileSystem

- (id)init {
    self = [super init];

    mAutoreleasePool = [[NSAutoreleasePool alloc] init];
    mFileManager = [NSFileManager defaultManager];
    mFileHandle = [[NSFileHandle alloc] init];

    mAppSupportDirectory = [NSString stringWithUTF8String:(
            [self NSGetPathForDirectory:(NSApplicationSupportDirectory) :(NSUserDomainMask)])];

    mCBLDirectory = [mAppSupportDirectory stringByAppendingPathComponent:@"/cbl"];
    mCBLHistoryDirectory = [mCBLDirectory stringByAppendingPathComponent:@"/history"];

    mFileName = [@"history.txt" mutableCopy];
    mFilePath = [[mCBLHistoryDirectory stringByAppendingPathComponent:
                                               [NSString stringWithFormat:@"/%@", mFileName]] mutableCopy];
    CBLLog(@"[mFilePath]: %@", mFilePath);


    if (![self FileExistsAtPath:[self NSStringToCString:mFilePath]]) {
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

- (const char *)NSGetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, domainMask, YES);

    if (paths.count == 0) {
        return NULL;
    }

    NSString *path = [paths objectAtIndex:0];
    CBLLog(@"[PathForDirectory] path: %@", path);

    // `fileSystemRepresentation` on an `NSString` gives a path suitable for POSIX APIs
    return path.fileSystemRepresentation;
}

- (const char *)GetFilePath {
    return mFilePath.fileSystemRepresentation;
}

- (bool)OpenFileAtPath:(const char *)filePath {
    if (filePath != nil) {
        mFilePath = [[self CStringToNSString:filePath] mutableCopy];
        mFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:mFilePath];
        mFileContentsLength = [mFileHandle seekToEndOfFile];
        [mFileHandle seekToFileOffset:0];
        return true;
    }

    return false;
}

- (ULONG)GetFileContentsLength {
    return mFileContentsLength;
}

- (bool)FileExistsAtPath:(const char *)filePath {
    return [mFileManager fileExistsAtPath:[self CStringToNSString:filePath]];
}

/* If directoryPath has a file extension, then remove the file extension
 * and name from the path to get the directory */
- (const char *)GetDirectoryPath:(const char *)filePath {
    ULONG pathLength = std::strlen(filePath);

    char *directoryPath = (char *) std::malloc((pathLength * sizeof(filePath)));
    std::strcpy(directoryPath, filePath);

    UINT length = pathLength - 1;
    UINT i = length;
    bool done = false;

    while (i != 0 && !done) {
        switch (directoryPath[i]) {
            case '/': done = true;
                break;
            case '.':
                while (i > 0 && !done) {
                    --i;
                    if (directoryPath[i] == '/') {
                        directoryPath[i] = '\0';
                        done = true;
                    }
                }
                break;
        }
        --i;
    }
    return directoryPath;
}

- (bool)CreateDirectoryAtPath:(const char *)directoryPath {
    NSError *error = 0;
    if (directoryPath) {
        if (![self FileExistsAtPath:directoryPath]) {
            [mFileManager createDirectoryAtPath:[self CStringToNSString:directoryPath]
                    withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                CBLLog(@"[CreateDirectoryAtPath]: error creating directory: %@", error);
            }
        } else {
            CBLLog(@"[CreateDirectoryAtPath]: directory already exists!");
        }
    }

    return !error ? true : false;
}

- (const char *)GetContentsOfFileAtPath:(const char *)filePath {
    NSData *contents;

    if ([self FileExistsAtPath:filePath]) {
        contents = [[NSData alloc] initWithContentsOfFile:[self CStringToNSString:filePath]];
    } else {
        contents = [[NSData alloc] init];
        CBLLog(@"[GetContentsOfFileAtPath]: File not found!");
    }

    return (const char *) contents;
}

- (const char *)NSStringToCString:(NSString *)nsString {
    return [nsString UTF8String];
}

- (NSString *)CStringToNSString:(const char *)cString {
    return [NSString stringWithUTF8String:cString];
}

// Creates and writes contents to file
- (bool)CreateFileAtPath:(const char *)directoryPath :(const char *)fileName :(const char *)contents {
    [self CreateDirectoryAtPath:directoryPath];

    NSString *filePath = [[self CStringToNSString:directoryPath] stringByAppendingPathComponent:
            [NSString stringWithFormat:@"/%@", [self CStringToNSString:fileName]]];

    return [self CreateFileAtPath:[self NSStringToCString:filePath] :contents];
}

- (bool)CreateFileAtPath:(const char *)filePath :(const char *)contents {
    bool success = false;
    char *directoryPath = (char *) std::malloc((std::strlen(filePath) * sizeof(filePath)));
    std::strcpy(directoryPath, (char *) [self GetDirectoryPath:filePath]);

    if ([self CreateDirectoryAtPath:directoryPath]) {
        if ([self FileExistsAtPath:filePath]) {
            CBLLog(@"[CreateFileAtPath]: file already exists!");
        } else {
            NSString *textToWrite = [[NSString alloc] initWithCString:[self WrapTimeStamp:contents]
                                                             encoding:NSUTF8StringEncoding];
            NSData *dataToWrite = [NSData dataWithBytes:[self NSStringToCString:textToWrite]
                                                 length:textToWrite.length];
            CBLLog(@"[CreateFileAtPath]: textToWrite.length == %lu", (unsigned long) textToWrite.length);

            // Create file
            if ([mFileManager createFileAtPath:[self CStringToNSString:filePath]
                                      contents:dataToWrite attributes:nil]) {
                success = true;
                mLengthOfLastWrite = dataToWrite ? dataToWrite.length : 0;
                CBLLog(@"[CreateFileAtPath]: file created successfully!");
            } else {
                CBLLog(@"[CreateFileAtPath]: file creation failed!");
            }
        }

        if (![self OpenFileAtPath:(filePath)]) {
            CBLLog(@"[CreateFileAtPath]: Could not open file!");
        }
    }

    return success;
}

- (bool)CreateFileAtPath:(const char *)filePath {
    return [self CreateFileAtPath:filePath :NULL];
}

- (bool)CreateFileAtDefaultPath {
    return [self CreateFileAtPath:[self NSStringToCString:mFilePath]];
}

// Overwrites content of file.
- (bool)OverwriteFileAtPathWithContent:(const char *)filePath :(const char *)contents {
    NSData *dataToWrite = [NSData dataWithBytes:contents length:(NSUInteger) strlen(contents)];
    NSError *error = 0;

    if (![mFileManager isWritableFileAtPath:[self CStringToNSString:filePath]]) {
        CBLLog(@"[OverwriteFileAtPathWithContent]: Cannot write to file!");
    } else {
        if ([self OpenFileAtPath:filePath]) {
            if ([mFileHandle writeData:dataToWrite error:&error]) {
                mLengthOfLastWrite = dataToWrite ? std::strlen(contents) : 0;
                mFileContentsLength += mLengthOfLastWrite;
                CBLLog(@"[OverwriteFileAtPathWithContent]: Write successful!");
            } else {
                CBLLog(@"[OverwriteFileAtPathWithContent]: Error writing to file: %@", error);
            }

            // This will shrink the file if data was removed
            [mFileHandle truncateFileAtOffset:dataToWrite.length];
            [mFileHandle closeFile];
        } else {
            CBLLog(@"[OverwriteFileAtPathWithContent]: Could not open file!");
        }
    }

    return !error ? true : false;
}

// Appends to contents of file.
- (bool)AppendFileAtPathWithContent:(const char *)filePath :(const char *)contents {
    NSError *error = 0;

    if (filePath == nil) {
        CBLLog(@"[AppendFileAtPathWithContent]: Invalid filepath!");
        error = [NSError alloc];
    } else {
        if (![self FileExistsAtPath:filePath]) { // File was deleted during program execution.
            [self CreateFileAtPath:filePath :contents];
        } else if (![mFileManager isWritableFileAtPath:[self CStringToNSString:filePath]]) {
            CBLLog(@"[AppendFileAtPathWithContent]: Cannot write to file!");
            error = [NSError alloc];
        } else {
            NSString *textToWrite = [[NSString alloc] initWithCString:[self WrapTimeStamp:contents]
                                                             encoding:NSUTF8StringEncoding];
            NSData *dataToWrite = [NSData dataWithBytes:[self NSStringToCString:textToWrite]
                                                 length:textToWrite.length];
            CBLLog(@"[CreateFileAtPath]: textToWrite.length == %lu", (unsigned long) textToWrite.length);

            if ([self OpenFileAtPath:filePath]) {
                [mFileHandle seekToEndOfFile];

                if ([mFileHandle writeData:dataToWrite error:&error]) {
                    mLengthOfLastWrite = dataToWrite ? dataToWrite.length : 0;
                    mFileContentsLength += mLengthOfLastWrite;
                    CBLLog(@"[AppendFileAtPathWithContent]: Write successful!");
                } else {
                    CBLLog(@"[AppendFileAtPathWithContent]: Error writing to file: %@", error);
                }

                [mFileHandle closeFile];
            } else {
                CBLLog(@"[AppendFileAtPathWithContent]: Could not open file!");
            }
        }
    }

    return !error ? true : false;
}

- (bool)RemoveTextFromFileAtPath:(const char *)filePath :(const char *)contents {
    // [mFileHandle truncateFileAtOffset:data.length]; // This will shrink the file if data was removed
    return false;
}

// Shows file contents as contents are updated
- (void)TailFile:(const char *)filePath {
    if ([self OpenFileAtPath:filePath]) {
        [mFileHandle seekToFileOffset:(mFileContentsLength - mLengthOfLastWrite)];
        NSData *data = [mFileHandle readDataToEndOfFile];
        NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        std::cout << [self RemoveLeadingWhiteSpace:[self NSStringToCString:contents]] << std::endl
                  << std::flush;
    }
}

- (const char *)ReadFileStream:
        (const char *)filePath {
    if ([self OpenFileAtPath:filePath]) {
        NSMutableData *data = [NSMutableData dataWithContentsOfFile:mFilePath];
        NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        std::cout << [self RemoveLeadingWhiteSpace:[self NSStringToCString:contents]] << std::endl
                  << std::flush;
    }
}


- (const char *)RemoveLeadingWhiteSpace:(const char *)contents {
    char *output;
    UINT i = 0;
    UINT j = 0;

    while ((contents[i] == ' ' || contents[i] == '\n') && (contents[i] != '\0')) {
        ++i;
    }

    output = (char *) std::malloc((std::strlen(contents - i) * sizeof(contents - i)) + 1);

    while (contents[i] != '\0') {
        output[j++] = contents[i++];
    }

    output[j] = '\0';

    return output;
}

- (const char *)WrapTimeStamp:(const char *)contents {
    NSString *toReturn = @"[";
    char *time_stamp = (char *) mTime.GetCurrentTime();

    time_stamp[std::strlen(time_stamp) - 1] = '\0';

    toReturn = [toReturn stringByAppendingFormat:@"%s]:\n", time_stamp];
    if (contents) {
        toReturn = [toReturn stringByAppendingFormat:@"%s", contents];
    }
    toReturn = [toReturn stringByAppendingString:[self CStringToNSString:"\n\n"]];

    return [self NSStringToCString:toReturn];
}

@end


