#include "FileManager.h"
#import <Foundation/Foundation.h>

namespace CBL {

    FileManager::FileManager() {
        mAutoreleasePool = [[NSAutoreleasePool alloc] init];
    }

    FileManager::~FileManager() {
        [(NSAutoreleasePool *) mAutoreleasePool release];
    }

    const char *FileManager::PathForDirectory(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *URLs = [fileManager URLsForDirectory:directory
                                            inDomains:domainMask];
        if (URLs.count == 0) {
            return NULL;
        }

        NSURL *URL = [URLs objectAtIndex:0];
        NSString *path = URL.path;

        // `fileSystemRepresentation` on an `NSString` gives a path suitable for POSIX APIs
        return path.fileSystemRepresentation;
    }

    const char *FileManager::PathForDirectoryForItemAtPath(NSSearchPathDirectory directory,
                                                           NSSearchPathDomainMask domainMask,
                                                           const char *itemPath, bool create) {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *nsPath = [fileManager stringWithFileSystemRepresentation:itemPath length:strlen(itemPath)];
        NSURL *itemURL = (nsPath ? [NSURL fileURLWithPath:nsPath] : nil);

        NSURL *URL = [fileManager URLForDirectory:directory
                                         inDomain:domainMask
                                appropriateForURL:itemURL
                                           create:create error:NULL];

        return URL.path.fileSystemRepresentation;
    }
}