//
//  NSString+BeeExtension.h
//  weicai
//
//  Created by liuhongnian on 14-10-16.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BeeExtension)

- (BOOL)isEmpty;

- (BOOL)isEmail;
- (BOOL)isPhoneNumber;

@end
