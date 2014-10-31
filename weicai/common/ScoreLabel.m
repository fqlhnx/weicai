//
//  ScoreLabel.m
//  weicai
//
//  Created by liuhongnian on 14-10-5.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "ScoreLabel.h"

@implementation ScoreLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapTouched)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)tapTouched
{
    if (self.didTouchedBlock) {
        self.didTouchedBlock();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
