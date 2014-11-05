//
//  DescriptionInfoCell.m
//  weicai
//
//  Created by liuhongnian on 14-11-5.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "DescriptionInfoCell.h"
#import "DescriptionInfoItem.h"

@interface DescriptionInfoCell ()

@property (nonatomic,strong)DescriptionInfoItem *item;

@end

@implementation DescriptionInfoCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)cellWillAppear
{
    self.textLabel.numberOfLines = 0;
    self.textLabel.text = self.item.title;
}

@end
