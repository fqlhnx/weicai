//
//  BeeDeviceInfo.h
//  weicai
//
//  Created by liuhongnian on 14-10-9.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeeDeviceInfo : NSObject

//联网获取公网IP地址
+ (void)connectedToTheInternetToGetIPAddress:(void (^)(NSString *ipAddr ,NSError *error))result;

@end
