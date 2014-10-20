//
//  ScrollContentInfo.h
//  weicai
//
//  Created by liuhongnian on 14-10-16.
//  Copyright (c) 2014年 www.51weicai.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

//created = 1412309397;
//id = 7;
//"is_deleted" = 0;
//order = 10;
//"scroll_content" = 12325;

//amount = 2;
//created = 1413769942;
//"exchange_target" = "\U652f\U4ed8\U5b9d\U63d0\U73b0";
//id = 48;
//integral = 1;
//ip = "218.93.54.147";
//"is_deleted" = 0;
//status = 5;
//"telmember_id" = U00000142;

@interface ScrollContentInfo : NSObject

@property (nonatomic,copy)NSString *scroll_content;

@property (nonatomic,copy)NSString *telmember_id;
@property (nonatomic,copy)NSString *exchange_target;

@end
