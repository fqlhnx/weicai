//
//  ChannelInfo.h
//  weicai
//
//  Created by liuhongnian on 14-10-14.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

//"channel_name" = sss;
//id = 1;
//"is_deleted" = 0;
//"is_display" = 1;
//"is_recommend" = 0;
//key = 122222;
//"max_integral" = 100;
//order = 3;
//"sub_name" = ss;
//"total_integral" = 10001;

typedef enum : NSUInteger {
    ChuKongPlatform = 6,
    WanPuPlatform = 5,
    DianRuPlatform = 7,
    AnWoPlatform = 4,
    YouMiPlatform = 3,
    MiDiPlatform = 2,
    DuoMengPlatform = 1,
} PlatformName;


@interface ChannelInfo : NSObject

@property (nonatomic,copy)NSString *channel_name;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *is_deleted;
@property (nonatomic,copy)NSString *is_display;
@property (nonatomic,copy)NSString *is_recommend;
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *max_integral;
@property (nonatomic,copy)NSString *order;
@property (nonatomic,copy)NSString *sub_name;
@property (nonatomic,copy)NSString *total_integral;

@end
