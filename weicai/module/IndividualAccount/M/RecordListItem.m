//
//  RecordListItem.m
//  weicai
//
//  Created by liuhongnian on 14-11-2.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "RecordListItem.h"

@implementation RecordListItem

+ (instancetype)itemWithLeftTitle:(NSString *)leftTitle
                         midTitle:(NSString *)midTitle
                       rightTitle:(NSString *)rightTitle
{
    return [[self alloc]initWithLeftTitle:leftTitle
                                 midTitle:midTitle
                               rightTitle:rightTitle];
}

- (instancetype)initWithLeftTitle:(NSString *)leftTitle
                         midTitle:(NSString *)midTitle
                       rightTitle:(NSString *)rightTitle
{
    if (self = [super init]) {
        
        _leftTitle = leftTitle;
        _midTitle = midTitle;
        _rightTitle = rightTitle;
    }
    
    return self;
}
@end
