//
//  IPAddressController.h
//  weicai
//
//  Created by liuhongnian on 14-10-27.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const DidGetCurrentIPAddress = @"DidGetIPAddress";

@interface IPAddressController : NSObject

@property (nonatomic,readonly)NSString *currentIP;

+ (instancetype)sharedInstance;

@end
