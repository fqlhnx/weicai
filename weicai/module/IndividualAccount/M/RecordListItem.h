//
//  RecordListItem.h
//  weicai
//
//  Created by liuhongnian on 14-11-2.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "RETableViewItem.h"

@interface RecordListItem : RETableViewItem

@property(nonatomic,copy)NSString *leftTitle;
@property(nonatomic,copy)NSString *midTitle;
@property(nonatomic,copy)NSString *rightTitle;

+ (instancetype)itemWithLeftTitle:(NSString*)leftTitle
                         midTitle:(NSString*)midTitle
                       rightTitle:(NSString*)rightTitle;
@end
