//
//  LB_DeviceInfo.m
//  lightBee
//
//  Created by liuhongnian on 14-10-23.
//  Copyright (c) 2014年 www.cz001.com.cn. All rights reserved.
//

#import "LB_DeviceInfo.h"

#import <CoreGraphics/CoreGraphics.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <dlfcn.h>


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

@implementation LB_DeviceInfo
+(NSDictionary*)deviceNamesByCode {
    
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              //iPhones
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone3,3" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone6,2" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator],
                              
                              
                              //iPads
                              @"iPad1,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,1" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,2" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,3" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,4" :[NSNumber numberWithInteger:iPad1],
                              @"iPad2,5" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,6" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad2,7" :[NSNumber numberWithInteger:iPadMini],
                              @"iPad3,1" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,2" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,3" :[NSNumber numberWithInteger:iPad3],
                              @"iPad3,4" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,5" :[NSNumber numberWithInteger:iPad4],
                              @"iPad3,6" :[NSNumber numberWithInteger:iPad4],
                              @"iPad4,1" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,2" :[NSNumber numberWithInteger:iPadAir],
                              @"iPad4,4" :[NSNumber numberWithInteger:iPadMiniRetina],
                              @"iPad4,5" :[NSNumber numberWithInteger:iPadMiniRetina]
                              
                              
                              };
    });
    
    return deviceNamesByCode;
}

+(DeviceVersion)deviceVersion {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    DeviceVersion version = (DeviceVersion)[[self.deviceNamesByCode objectForKey:code] integerValue];
    
    return version;
}

+(DeviceSize)deviceSize {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480)
        return iPhone35inch;
    else if(screenHeight == 568)
        return iPhone4inch;
    else if(screenHeight == 667)
        return  iPhone47inch;
    else if(screenHeight == 736)
        return iPhone55inch;
    else
        return 0;
}

+(NSString*)deviceName {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([code isEqualToString:@"x86_64"] || [code isEqualToString:@"i386"]) {
        code = @"Simulator";
    }
    
    return code;
}

+ (BOOL)isDevicePhone
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    NSString * deviceType = [UIDevice currentDevice].model;
    
    if ( [deviceType rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
        [deviceType rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
    {
        return YES;
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    
    return NO;
}

+ (BOOL)isDevicePad
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        NSString * deviceType = [UIDevice currentDevice].model;
        
        if ( [deviceType rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
        {
            return YES;
        }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        
        return NO;
}

+ (NSString *)getUDID
{
    NSString *udid = nil;
    
    NSBundle *a = [NSBundle bundleWithPath:@"System/Library/PrivateFrameworks/AppleAccount.framework"];
    NSBundle *b = [NSBundle bundleWithPath:@"System/Library/PrivateFrameworks/ApplePushService.framework"];
    if ([a load]) {
        if ([b load]) {
            NSLog(@"%s>>>>>>%d",__func__,__LINE__);
            Class aa = NSClassFromString(@"AADeviceInfo");
            udid = (NSString*)[aa performSelector:@selector(udid)];
        }
    }
    
    return udid;
}

+ (NSString *)serialNumber
{
    void *IOKit = dlopen("/System/Library/Frameworks/IOKit.framework/IOKit", RTLD_NOW);
    if (!IOKit) {
        return nil;
    }
    IOServiceGetMatchingService pIOServiceGetMatchingService = dlsym(IOKit, "IOServiceGetMatchingService");
    IOServiceMatching pIOServiceMatching = dlsym(IOKit, "IOServiceMatching");
    IORegistryEntryCreateCFProperty pIORegistryEntryCreateCFProperty = dlsym(IOKit, "IORegistryEntryCreateCFProperty");
    IORegistryEntryCreateCFProperties pIORegistryEntryCreateCFProperties = dlsym(IOKit, "IORegistryEntryCreateCFProperties");
    IOObjectRelease pIOObjectRelease = dlsym(IOKit, "IOObjectRelease");
    mach_port_t *kIOMasterPortDefault = dlsym(IOKit, "kIOMasterPortDefault");
    io_object_t platformExpert;
    IOServiceNameMatching pIOServiceNameMatching = dlsym(IOKit, "IOServiceNameMatching");
    CFDictionaryRef ma = pIOServiceMatching("IOPlatformExpertDevice");
    platformExpert = pIOServiceGetMatchingService(*kIOMasterPortDefault, ma);
    NSString *sNum = nil;
    if (platformExpert) {
        CFTypeRef sn = pIORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformSerialNumber"), kCFAllocatorDefault, 0);
        NSLog(@"device SN = %@\n",sn);
        sNum = (NSString*)CFBridgingRelease(sn);
        pIOObjectRelease(platformExpert);
    }
    return sNum;
}

@end
