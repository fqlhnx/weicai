//
//  RecordListCell.h
//  weicai
//
//  Created by liuhongnian on 14-11-2.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "RETableViewCell.h"
@class RecordListItem;

@interface RecordListCell : RETableViewCell

@property (nonatomic,weak)IBOutlet UILabel *leftContent;
@property (nonatomic,weak)IBOutlet UILabel *rightContent;
@property (nonatomic,weak)IBOutlet UILabel *midContent;

@property (nonatomic,readwrite,strong) RecordListItem *item;

@end
