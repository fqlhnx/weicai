//
//  RecordListCell.m
//  weicai
//
//  Created by liuhongnian on 14-11-2.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "RecordListCell.h"
#import "RecordListItem.h"

@implementation RecordListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWillAppear
{
    self.leftContent.text = self.item.leftTitle;
    self.midContent.text = self.item.midTitle;
    self.rightContent.text = self.item.rightTitle;
    
}

@end
