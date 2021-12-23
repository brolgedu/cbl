#import "CBLFileSystem.h"

#import "Core.h"

#import <Foundation/Foundation.h>

@implementation CBLFileSystem
- (id)init {
    self = [super init];
    mAutoreleasePool = [[NSAutoreleasePool alloc] init];
    return self;
}

- (void)dealloc {
    [(NSAutoreleasePool *) mAutoreleasePool release];
    [super dealloc];
}

- (const char *)GetPathForDirectory:(NSSearchPathDirectory)directory :(NSSearchPathDomainMask)domainMask {
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
    return mFilePath;
}

- (BOOL)FileExistsAtPath:(const char *)filePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:(filePath)]];
}

- (BOOL)CreateDirectoryAtPath:(const char *)directoryPath {
    NSError *error = 0;
    if (directoryPath) {
        if (!FileExistsAtPath:(directoryPath)) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithUTF8String:directoryPath]
                                      withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                CBLLog(@"[NSFileManager]: error creating directory: %@", error);
            }
        } else {
            CBLLog(@"[NSFileManager]: directory already exists!");
        }
    }

    return !error ? true : false;
}

- (NSData *)GetContentsOfFileAtPath:(const char *)filePath {
    NSData *data;

    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:(filePath)]]) {
        data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithUTF8String:(filePath)]];
    } else {
        data = [[NSData alloc] init];
        CBLLog(@"[NSFileManager]: File not found!");
    }

    return data;
}

- (const char *)NSStringToCString:(NSString *)nsString {
}

- (NSString *)CStringToNSString:(const char *)cString {
    return nil;
}


// Creates and writes contents to file
- (const char *)CreateFileAtPath:(const char *)directoryPath :(const char *)fileName :(const char *)fileType :(const char *)data {
    [self CreateDirectoryAtPath:directoryPath];

    NSString *filePath = [[NSString stringWithUTF8String:(directoryPath)] stringByAppendingPathComponent:
            directoryPath != nil
            ? [NSString stringWithFormat:@"/%@.%@", [NSString stringWithUTF8String:(fileName)], [NSString stringWithUTF8String:(fileType)]]
            : [NSString stringWithFormat:@"/%@", [NSString stringWithUTF8String:(fileName)]]];


    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        CBLLog(@"[NSFileManager]: file already exists!");
    } else {
        // Create and write to file
        if ([[NSFileManager defaultManager] createFileAtPath:filePath contents:[NSData dataWithBytes:(const void *) data length:(NSUInteger) strlen(
                data)]                                                attributes:nil]) {
            CBLLog(@"[NSFileManager]: file created successfully!");
        } else {
            CBLLog(@"[NSFileManager]: file creation failed!");
        }
    }

    mFilePath = filePath.fileSystemRepresentation;

    return mFilePath;
}

// Overwrites content of file.
- (BOOL)OverwriteFileAtPath:(const char *)filePath :(const char *)data {
    NSData *newData = [NSData dataWithBytes:(const void *) data length:(NSUInteger) strlen(data)];
    NSError *error = 0;

    if (![[NSFileManager defaultManager] isWritableFileAtPath:[NSString stringWithUTF8String:(filePath)]]) {
        CBLLog(@"[Error]: Cannot write to file!");
    } else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[NSString stringWithUTF8String:(filePath)]];
        [fileHandle seekToFileOffset:0];

        if ([fileHandle writeData:newData error:&error]) {
            CBLLog(@"[NSFileHandle]: Write successful!");
        } else {
            CBLLog(@"[NSFileHandle]: Error writing to file: %@", error);
        }

        // This will shrink the file if data was removed
        [fileHandle truncateFileAtOffset:newData.length];
        [fileHandle closeFile];
    }

    return !error ? true : false;
}

// Appends to contents of file.
- (BOOL)AppendFileAtPath:(const char *)filePath :(const char *)data {
    NSError *error = 0;

    if (![[NSFileManager defaultManager] isWritableFileAtPath:[NSString stringWithUTF8String:(filePath)]]) {
        CBLLog(@"[Error]: Cannot write to file!");
        return false;
    } else {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:[NSString stringWithUTF8String:(filePath)]];
        auto offset = fileHandle.seekToEndOfFile;
        [fileHandle seekToFileOffset:offset];

        NSData *dataToWrite = [NSData dataWithBytes:(const void *) data length:(NSUInteger) strlen(data)];

        if ([fileHandle writeData:(NSData *) dataToWrite error:&error]) {
            CBLLog(@"[NSFileHandle]: Write successful!");
        } else {
            CBLLog(@"[NSFileHandle]: Error writing to file: %@", error);
        }

        [fileHandle closeFile];
    }

    return !error ? true : false;
}

- (BOOL)RemoveTextFromFileAtPath:(const char *)filePath :(const char *)data {
    // [fileHandle truncateFileAtOffset:data.length]; // This will shrink the file if data was removed

}

@end