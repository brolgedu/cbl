#pragma once

#include <Foundation/NSPathUtilities.h>

namespace CBL {

    class FileManager {
    public:
        FileManager();
        ~FileManager();

        const char *PathForDirectory(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask);
        const char *PathForDirectoryForItemAtPath(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask,
                                                  const char *itemPath, bool create = false);

    private:
        void *mAutoreleasePool;
    };
}