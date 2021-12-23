#import "Core/Core.h"

#import "Core/CBLFileSystem.h"
#import "Core/CBLClipboard.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    CBLFileSystem *fs = [[CBLFileSystem alloc] init];

    NSString *appSupportDirectory =
            [fs CStringToNSString:[fs NSGetPathForDirectory:NSApplicationSupportDirectory :NSUserDomainMask]];
    CBLLog(@"[appSupportDirectory]: %@", appSupportDirectory);

    NSString *test_Directory = @"cbl/tests/file_system";
    NSString *directoryPath = [appSupportDirectory stringByAppendingPathComponent:test_Directory];
    CBLLog(@"[directoryPath]: %@", directoryPath);


    const char *textToBeginFile = "This is the first write to the file!\n";
    const char *filePath = [fs NSStringToCString:directoryPath];
    const char *fileName = "test.txt";
    CBLLog(@"[filePath]: %s", filePath);
    CBLLog(@"[fileName]: %s", fileName);

    if ([fs CreateFileAtPath:filePath :fileName :textToBeginFile]) {
        CBLLog(@"[CBLFileSystem]: File created at %s", filePath);
    } else {
        CBLLog(@"[CBLFileSystem]: Error creating file. File may already exist.");
    }

    filePath = [fs GetFilePath];

    const char *textToAppendFile = "This text is appending to the file!\n";
    if ([fs AppendFileAtPath:filePath :textToAppendFile]) {
        CBLLog(@"[CBLFileSystem]: AppendFileAtPath successful!");
    } else {
        CBLLog(@"[CBLFileSystem]: AppendFileAtPath failed!");
    }

    const char* textToOverwriteFile = "Every this in this file has been overwritten!";
    if ([fs OverwriteFileAtPath:filePath :textToOverwriteFile]) {
        CBLLog(@"[CBLFileSystem]: OverwriteFileAtPath successful!");
    } else {
        CBLLog(@"[CBLFileSystem]: OverwriteFileAtPath failed!");
    }

    [pool drain];
    return 0;
}