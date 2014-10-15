//
//  ScoreLabel.h
//  weicai
//
//  Created by liuhongnian on 14-10-5.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchedBlock)();

@interface ScoreLabel : UILabel

@property (nonatomic,copy)TouchedBlock didTouchedBlock;
@end
