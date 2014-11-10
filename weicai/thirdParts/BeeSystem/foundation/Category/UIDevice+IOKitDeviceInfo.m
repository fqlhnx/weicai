//
//  UIDevice+IOKitDeviceInfo.m
//  lightBee
//
//  Created by liuhongnian on 14-11-9.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import "UIDevice+IOKitDeviceInfo.h"
#include <dlfcn.h>

@implementation UIDevice (IOKitDeviceInfo)

#define IOKit_PATH "/System/Library/Frameworks/IOKit.framework/IOKit"

typedef UInt32 IOOptionBits;
typedef mach_port_t io_object_t;
typedef mach_port_t io_service_t;
typedef io_object_t io_registry_entry_t;
extern const mach_port_t kIOMasterPortDefault;
typedef kern_return_t (* IOObjectRelease)(io_object_t	object );
typedef CFMutableDictionaryRef (* IOServiceMatching)(const char *name );
typedef CFMutableDictionaryRef (* IOServiceNameMatching)(const char *name);
typedef io_service_t (* IOServiceGetMatchingService)( mach_port_t masterPort, CFDictionaryRef matching );
typedef kern_return_t (*IORegistryEntryCreateCFProperties)(
                                                           io_registry_entry_t entry,
                                                           CFMutableDictionaryRef *properties,
                                                           CFAllocatorRef allocator,
                                                           IOOptionBits options );
typedef CFTypeRef (* IORegistryEntryCreateCFProperty)(
                                                      io_registry_entry_t entry,
                                                      CFStringRef key,
                                                      CFAllocatorRef allocator,
                                                      IOOptionBits options );


+ (NSString *)IOSerialNumber
{
    return [[self class]IODeviceInfoForKey:CFSTR("IOPlatformSerialNumber")];;
}

+ (NSString *)IOPlatformUUID
{
    return [[self class] IODeviceInfoForKey:CFSTR("IOPlatformUUID")];
}

+ (NSString*)IODeviceInfoForKey:(CFStringRef)key
{
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (!IOKit) {
        return nil;
    }
    NSString *retVal = nil;

    IOServiceGetMatchingService pIOServiceGetMatchingService = dlsym(IOKit, "IOServiceGetMatchingService");
    IOServiceMatching pIOServiceMatching = dlsym(IOKit, "IOServiceMatching");
    IORegistryEntryCreateCFProperty pIORegistryEntryCreateCFProperty = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
//    IORegistryEntryCreateCFProperties pIORegistryEntryCreateCFProperties = dlsym(IOKit, "IORegistryEntryCreateCFProperties");
    
    IOObjectRelease pIOObjectRelease = dlsym(IOKit, "IOObjectRelease");
    mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
    io_object_t platformExpert;
//    IOServiceNameMatching pIOServiceNameMatching = dlsym(IOKit, "IOServiceNameMatching");
    CFDictionaryRef ma = pIOServiceMatching("IOPlatformExpertDevice");
    platformExpert = pIOServiceGetMatchingService(*kIOMasterPortDefault, ma);
    if (platformExpert) {
        CFTypeRef sn = pIORegistryEntryCreateCFProperty(platformExpert, key, kCFAllocatorDefault, 0);
        retVal = (NSString*)CFBridgingRelease(sn);
        pIOObjectRelease(platformExpert);
    }

    return retVal;
}

+ (NSString *)DeviceUDID
{
    CFStringRef (*pMGCopyAnswer)(CFStringRef,UInt32);
    
    NSString *udidStr = nil;
    void *mgHandle = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_NOW);
    if (mgHandle) {
        pMGCopyAnswer = dlsym(mgHandle, "MGCopyAnswer");
        CFStringRef udid = pMGCopyAnswer(CFSTR("UniqueDeviceID"),1);
        udidStr = (NSString*)CFBridgingRelease(udid);
    }
    return udidStr;
    
}

+ (NSString *)serialNumber
{
    NSString *serialNumber = nil;
    
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (IOKit)
    {
        mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
        CFMutableDictionaryRef (*IOServiceMatching)(const char *name) = dlsym(IOKit, "IOServiceMatching");
        mach_port_t (*IOServiceGetMatchingService)(mach_port_t masterPort, CFDictionaryRef matching) = dlsym(IOKit, "IOServiceGetMatchingService");
        CFTypeRef (*IORegistryEntryCreateCFProperty)(mach_port_t entry, CFStringRef key, CFAllocatorRef allocator, uint32_t options) = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
        kern_return_t (*IOObjectRelease)(mach_port_t object) = dlsym(IOKit, "IOObjectRelease");
        
        if (kIOMasterPortDefault && IOServiceGetMatchingService && IORegistryEntryCreateCFProperty && IOObjectRelease)
        {
            mach_port_t platformExpertDevice = IOServiceGetMatchingService(*kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
            if (platformExpertDevice)
            {
                CFTypeRef platformSerialNumber = IORegistryEntryCreateCFProperty(platformExpertDevice, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
                if (CFGetTypeID(platformSerialNumber) == CFStringGetTypeID())
                {
                    serialNumber = [NSString stringWithString:(NSString*)(CFBridgingRelease(platformSerialNumber))];
                    
                    CFRelease(platformSerialNumber);
                }
                IOObjectRelease(platformExpertDevice);
            }
        }
        dlclose(IOKit);
    }
    
    return serialNumber;
}
@end
