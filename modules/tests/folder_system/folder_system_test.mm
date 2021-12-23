#import "Core/CBLClipboard.h"

#import "Core/Core.h"
#import "Core/CBLFileSystem.h"

int main(int argc, char *argv[]) {
    char *folderPath = NULL;
    CBLFolderManager *folderManager = [[CBLFolderManager alloc] init];
    folderPath = (char *) [folderManager PathForDirectory:NSApplicationSupportDirectory :NSUserDomainMask];
    printf("folderPath == %s\n", folderPath);

    folderPath = (char *) [folderManager PathForDirectory:NSApplicationSupportDirectory :NSLocalDomainMask];
    printf("folderPath == %s\n", folderPath);

    folderPath = (char *) [folderManager PathForDirectory:NSTrashDirectory: NSAllDomainsMask];
    printf("folderPath == %s\n", folderPath);

    if (argc > 1) {
        folderPath = (char *) [folderManager PathForDirectoryForItemAtPath:NSTrashDirectory :NSAllDomainsMask : argv[1]: true];
        printf("folderPath == %s\n", folderPath);

        folderPath = (char *) [folderManager PathForDirectoryForItemAtPath:NSItemReplacementDirectory :
                NSUserDomainMask :argv[1] :true];
        printf("folderPath == %s\n", folderPath);
    }

}