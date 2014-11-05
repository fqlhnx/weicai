//
//  NSString+conversionUserID.m
//  weicai
//
//  Created by liuhongnian on 14-11-5.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "NSString+conversionUserID.h"

@implementation NSString (conversionUserID)

- (NSString*)conversionIDbyUserType:(UserType)type
{
    switch (type) {
        case defaultUser:
        {
            NSString *current = [self copy];
            if ([current hasPrefix:@"UAA"])
            {
                return current;
            }
            else
            {
                if ([current hasPrefix:@"U00"]) {
                    NSString *userID = [current substringFromIndex:1];
                    NSString *resultUID = [NSString stringWithFormat:@"UBC%@",userID];
                    return resultUID;
                }
            }
            break;

        }
            
        default:
            break;
    }
    return nil;
}

@end
