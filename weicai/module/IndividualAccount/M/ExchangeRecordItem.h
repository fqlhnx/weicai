//
//  ExchangeRecordItem.h
//  weicai
//
//  Created by liuhongnian on 14-11-3.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "RETableViewItem.h"

@interface ExchangeRecordItem : RETableViewItem

@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *timeString;

- (instancetype)initWithExchangeInfo:(NSString*)info
                           timeValue:(NSString*)time;

@end
