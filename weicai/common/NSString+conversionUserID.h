//
//  NSString+conversionUserID.h
//  weicai
//
//  Created by liuhongnian on 14-11-5.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UserType)
{
    defaultUser = 1,
};

@interface NSString (conversionUserID)

- (NSString*)conversionIDbyUserType:(UserType)type;

@end
