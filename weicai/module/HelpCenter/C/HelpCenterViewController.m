//
//  HelpCenterViewController.m
//  weicai
//
//  Created by liuhongnian on 14-10-20.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "HelpCenterViewController.h"

NSString *const kHelpWebURL = @"http://121.40.193.213/Integral/public/index.php/api/help";

@implementation HelpCenterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"帮助中心";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.url = [NSURL URLWithString:kHelpWebURL];
}

@end
