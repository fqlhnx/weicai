//
//  RecordCell.h
//  weicai
//
//  Created by liuhongnian on 14-11-3.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RETableViewCell.h"
#import "RecordItem.h"
@interface RecordCell : RETableViewCell

@property (nonatomic,weak)IBOutlet UILabel *leftLabel;
@property (nonatomic,weak)IBOutlet UILabel *midLabel;
@property (nonatomic,weak)IBOutlet UILabel *rightLabel;

@property (nonatomic,strong)RecordItem *item;

@end
