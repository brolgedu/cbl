#pragma once

#include "SysDirEnums.h"

namespace PBL {

    class FileManager {
    public:
        FileManager();
        ~FileManager();

        const char *PathForDirectory(SearchPathDirectory directory, SearchPathDomainMask domainMask);
        const char *PathForDirectoryForItemAtPath(SearchPathDirectory directory, SearchPathDomainMask domainMask,
                                                  const char *itemPath, bool create = false);

    private:
        void *mAutoreleasePool;
    };
}