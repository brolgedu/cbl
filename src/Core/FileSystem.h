#pragma once

#import <string>
#import <Foundation/NSPathUtilities.h>

#ifdef __cplusplus
extern "C" {
#endif

namespace CBL {

    class FileSystem {
    public:
        FileSystem();
        ~FileSystem();

        const char *PathForDirectory(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask);
        const char *PathForDirectoryForItemAtPath(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask,
                                                  const char *itemPath, bool create = false);

    private:
        void *mAutoreleasePool;
    };
}

#ifdef __cplusplus
};
#endif