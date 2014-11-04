//
//  ExchangeRecordCell.m
//  weicai
//
//  Created by liuhongnian on 14-11-3.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ExchangeRecordCell.h"

@implementation ExchangeRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWillAppear
{
    self.userLabel.text = self.item.userID;
    self.exchangeInfo.text = self.item.info;
    self.timeLabel.text = self.item.timeString;
}

@end
