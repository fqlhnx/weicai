//
//  ExchangeRecordItem.m
//  weicai
//
//  Created by liuhongnian on 14-11-3.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeRecordItem.h"

@implementation ExchangeRecordItem

- (instancetype)initWithUserID:(NSString *)uid ExchangeInfo:(NSString *)info timeValue:(NSString *)time
{
    if (self = [super init]) {
        
        self.userID = uid;
        self.info = info;
        self.timeString = time;
        
    }
    return self;
}

@end
