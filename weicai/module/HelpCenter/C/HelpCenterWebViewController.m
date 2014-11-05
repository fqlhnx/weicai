//
//  HelpCenterWebViewController.m
//  weicai
//
//  Created by liuhongnian on 14-10-22.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import "HelpCenterWebViewController.h"

@implementation HelpCenterWebViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:@"http://121.40.193.213/Integral/public/index.php/api/help"];
        self.showPageTitles = NO;
                
        self.title = @"帮助中心";
    }
    return self;
}

@end
