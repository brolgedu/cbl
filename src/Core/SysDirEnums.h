namespace PBL {

    // MacOS enums from sysdir.h
    enum {
        SYSDIR_DIRECTORY_APPLICATION            = 1,    // supported applications (Applications)
        SYSDIR_DIRECTORY_DEMO_APPLICATION       = 2,    // unsupported applications, demonstration versions (Applications/Demos)
        SYSDIR_DIRECTORY_DEVELOPER_APPLICATION  = 3,    // developer applications (Developer/Applications) Soft deprecated as of __MAC_10_5 - there is no one single Developer directory
        SYSDIR_DIRECTORY_ADMIN_APPLICATION      = 4,    // system and network administration applications (Applications/Utilities)
        SYSDIR_DIRECTORY_LIBRARY                = 5,    // various user-visible documentation, support, and configuration files, resources (Library)
        SYSDIR_DIRECTORY_DEVELOPER              = 6,    // developer resources (Developer) Soft deprecated as of __MAC_10_5 - there is no one single Developer directory
        SYSDIR_DIRECTORY_USER                   = 7,    // user home directories (Users)
        SYSDIR_DIRECTORY_DOCUMENTATION          = 8,    // documentation (Library/Documentation)
        SYSDIR_DIRECTORY_DOCUMENT               = 9,    // documents (Documents)
        SYSDIR_DIRECTORY_CORESERVICE            = 10,   // location of core services (Library/CoreServices)
        SYSDIR_DIRECTORY_AUTOSAVED_INFORMATION  = 11,   // location of user's directory for use with autosaving (Library/Autosave Information)
        SYSDIR_DIRECTORY_DESKTOP                = 12,   // location of user's Desktop (Desktop)
        SYSDIR_DIRECTORY_CACHES                 = 13,   // location of discardable cache files (Library/Caches)
        SYSDIR_DIRECTORY_APPLICATION_SUPPORT    = 14,   // location of application support files (plug-ins, etc) (Library/Application Support)
        SYSDIR_DIRECTORY_DOWNLOADS              = 15,   // location of user's Downloads directory (Downloads)
        SYSDIR_DIRECTORY_INPUT_METHODS          = 16,   // input methods (Library/Input Methods)
        SYSDIR_DIRECTORY_MOVIES                 = 17,   // location of user's Movies directory (Movies)
        SYSDIR_DIRECTORY_MUSIC                  = 18,   // location of user's Music directory (Music)
        SYSDIR_DIRECTORY_PICTURES               = 19,   // location of user's Pictures directory (Pictures)
        SYSDIR_DIRECTORY_PRINTER_DESCRIPTION    = 20,   // location of system's PPDs directory (Library/Printers/PPDs)
        SYSDIR_DIRECTORY_SHARED_PUBLIC          = 21,   // location of user's Public sharing directory (Public)
        SYSDIR_DIRECTORY_PREFERENCE_PANES       = 22,   // location of the PreferencePanes directory for use with System Preferences (Library/PreferencePanes)
        SYSDIR_DIRECTORY_ALL_APPLICATIONS       = 100,  // all directories where applications can occur (Applications, Applications/Utilities, Developer/Applications, ...)
        SYSDIR_DIRECTORY_ALL_LIBRARIES          = 101,  // all directories where resources can occur (Library, Developer)
    };
    typedef unsigned long SearchPathDirectory;

    enum {
        SYSDIR_DOMAIN_MASK_USER                 = ( 1UL << 0 ), // user's home directory --- place to install user's personal items (~)
        SYSDIR_DOMAIN_MASK_LOCAL                = ( 1UL << 1 ), // local to the current machine --- place to install items available to everyone on this machine
        SYSDIR_DOMAIN_MASK_NETWORK              = ( 1UL << 2 ), // publically available location in the local area network --- place to install items available on the network (/Network)
        SYSDIR_DOMAIN_MASK_SYSTEM               = ( 1UL << 3 ), // provided by Apple
        SYSDIR_DOMAIN_MASK_ALL                  = 0x0ffff,      // all domains: all of the above and more, future items
    };
    typedef unsigned long SearchPathDomainMask;
}