#import <Core/Clipboard.h>
#import <Core/FileManager.h>

int main(int argc, char *argv[]) {
    char *filePath = NULL;
    CBL::FileManager fileManager;
    filePath = (char *) fileManager.PathForDirectory(NSApplicationSupportDirectory, NSUserDomainMask);
    printf("filePath == %s\n", filePath);

    filePath = (char *) fileManager.PathForDirectory(NSApplicationSupportDirectory, NSLocalDomainMask);
    printf("filePath == %s\n", filePath);

    filePath = (char *) fileManager.PathForDirectory(NSTrashDirectory, NSAllDomainsMask);
    printf("filePath == %s\n", filePath);

    if (argc > 1) {
        filePath = (char *) fileManager.PathForDirectoryForItemAtPath(NSTrashDirectory, NSAllDomainsMask,
                                                                      argv[1]);
        printf("filePath == %s\n", filePath);

        filePath = (char *) fileManager.PathForDirectoryForItemAtPath(NSItemReplacementDirectory,
                                                                      NSUserDomainMask, argv[1], true);
        printf("filePath == %s\n", filePath);
    }

}