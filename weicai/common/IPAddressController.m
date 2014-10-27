//
//  IPAddressController.m
//  weicai
//
//  Created by liuhongnian on 14-10-27.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "IPAddressController.h"

#import "BeeDeviceInfo.h"

@interface IPAddressController ()
@property (nonatomic,strong) NSString *currentIP;
@end

@implementation IPAddressController

+ (instancetype)sharedInstance
{
    static IPAddressController *sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^(void) {
        sharedSingleton = [[self alloc] init];
    });
    return sharedSingleton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //获取ip
        [self getCurrentIp];
    }
    return self;
}

- (void) getCurrentIp
{
    [BeeDeviceInfo connectedToTheInternetToGetIPAddress:^(NSString *ipAddr, NSError *error) {
        
        if (!error) {
            self.currentIP = ipAddr;
            [[NSNotificationCenter defaultCenter]postNotificationName:DidGetCurrentIPAddress
                                                               object:self.currentIP];
        }else{
            [self getCurrentIp];
        }
    }];
    
}

@end
