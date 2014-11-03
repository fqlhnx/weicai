//
//  TaskInfo.m
//  weicai
//
//  Created by liuhongnian on 14-10-17.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "TaskInfo.h"
#import "ChannelInfo.h"

@implementation TaskInfo

+ (NSString*)channelNameByID:(NSString *)channelID
{
    NSUInteger channelType = channelID.integerValue;
    
    NSString *result = nil;
    switch (channelType) {
        case YouMiPlatform:
        {
            result = @"有米";
            break;
        }
        case ChuKongPlatform:
        {
            result = @"触控";
            break;
        }
        case AnWoPlatform:
        {
            result = @"安沃";
            break;
        }
        case DuoMengPlatform:
        {
            result = @"多盟";
            break;
        }
        case DianRuPlatform:
        {
            result = @"点入";
            break;
        }
        case MiDiPlatform:
        {
            result = @"米迪";
            break;
        }
        case DianJoyPlatform:
        {
            result = @"点乐";
            break;
        }
        case GuoMengPlatform:
        {
            result = @"果盟";
        }
        default:
        {
            NSLog(@"未知的平台ID%lu",(unsigned long)channelType);
            break;
        }
    }
    
    return result;
}

@end
