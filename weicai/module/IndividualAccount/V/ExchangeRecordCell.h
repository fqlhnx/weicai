//
//  ExchangeRecordCell.h
//  weicai
//
//  Created by liuhongnian on 14-11-3.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RETableViewCell.h"
#import "ExchangeRecordItem.h"
@interface ExchangeRecordCell : RETableViewCell

@property (weak, nonatomic) IBOutlet UILabel *exchangeInfo;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)ExchangeRecordItem *item;

@end
